'use client';

import React, { createContext, useContext, useEffect, useState } from 'react';
import { useRouter, usePathname } from 'next/navigation';
import { supabase } from '@/lib/supabase';
import { UserProfile } from '@/types/database';

interface AuthContextType {
  userProfile: UserProfile | null;
  loading: boolean;
  signOut: () => Promise<void>;
}

const AuthContext = createContext<AuthContextType>({
  userProfile: null,
  loading: true,
  signOut: async () => {},
});

const ALLOWED_ROLES = ['admin', 'quality_manager', 'supervisor'];

export function AuthProvider({ children }: { children: React.ReactNode }) {
  const [userProfile, setUserProfile] = useState<UserProfile | null>(null);
  const [loading, setLoading] = useState(true);
  const router = useRouter();
  const pathname = usePathname();

  useEffect(() => {
    const checkAuth = async () => {
      try {
        const { data: { session } } = await supabase.auth.getSession();
        
        if (!session?.user) {
          setUserProfile(null);
          setLoading(false);
          if (pathname !== '/login') {
            router.push('/login');
          }
          return;
        }

        // Fetch public user profile
        const { data: profile, error } = await supabase
          .from('users')
          .select('*')
          .eq('id', session.user.id)
          .single();

        if (error || !profile) {
          console.error('Error fetching user profile:', error);
          setUserProfile(null);
          setLoading(false);
          if (pathname !== '/login') router.push('/login');
          return;
        }

        const user = profile as UserProfile;

        // Verify role authorization
        if (!ALLOWED_ROLES.includes(user.role)) {
          console.warn('Unauthorized role access attempt:', user.role);
          await supabase.auth.signOut();
          setUserProfile(null);
          setLoading(false);
          router.push('/login?error=unauthorized');
          return;
        }

        setUserProfile(user);
        setLoading(false);

        if (pathname === '/login') {
          router.push('/');
        }
      } catch (err) {
        console.error('Unexpected auth check failure:', err);
        setLoading(false);
      }
    };

    checkAuth();

    const { data: { subscription } } = supabase.auth.onAuthStateChange(() => {
      checkAuth();
    });

    return () => {
      subscription.unsubscribe();
    };
  }, [pathname, router]);

  const signOut = async () => {
    setLoading(true);
    await supabase.auth.signOut();
    setUserProfile(null);
    setLoading(false);
    router.push('/login');
  };

  return (
    <AuthContext.Provider value={{ userProfile, loading, signOut }}>
      {children}
    </AuthContext.Provider>
  );
}

export const useAuth = () => useContext(AuthContext);
