'use client';

import React, { useState, useEffect, Suspense } from 'react';
import { useRouter, useSearchParams } from 'next/navigation';
import { ShieldCheck, Lock, Mail, Eye, EyeOff, AlertCircle, Sun, Moon } from 'lucide-react';
import { supabase } from '@/lib/supabase';
import { useTheme } from '@/context/ThemeContext';

function LoginForm() {
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [showPassword, setShowPassword] = useState(false);
  const [loading, setLoading] = useState(false);
  const [errorMsg, setErrorMsg] = useState<string | null>(null);

  const { theme, toggleTheme } = useTheme();
  const router = useRouter();
  const searchParams = useSearchParams();

  useEffect(() => {
    const isUnauthorized = searchParams.get('error') === 'unauthorized';
    if (isUnauthorized) {
      Promise.resolve().then(() => {
        setErrorMsg('Access Restricted: Web Admin Panel is accessible only to Admin, Quality Manager, and Supervisor roles.');
      });
    }
  }, [searchParams]);

  const handleLogin = async (e: React.FormEvent) => {
    e.preventDefault();
    setLoading(true);
    setErrorMsg(null);

    try {
      const { data, error } = await supabase.auth.signInWithPassword({
        email: email.trim(),
        password,
      });

      if (error) {
        if (error.message.includes('Invalid login credentials')) {
          setErrorMsg('Invalid email address or security password. Please try again.');
        } else {
          setErrorMsg(error.message);
        }
        setLoading(false);
        return;
      }

      if (data.session) {
        router.push('/');
      }
    } catch (err: unknown) {
      const message = err instanceof Error ? err.message : 'An unexpected error occurred';
      setErrorMsg(message);
      setLoading(false);
    }
  };

  return (
    <div className="w-full max-w-md bg-theme-card border border-theme rounded-xl shadow-2xl p-8 transition-colors relative">
      <button
        onClick={toggleTheme}
        className="absolute top-4 right-4 p-2 bg-theme-input text-[#F59E0B] rounded-lg border border-theme hover:bg-theme-main transition-colors"
        title="Toggle Light/Dark Theme"
      >
        {theme === 'dark' ? <Sun size={18} /> : <Moon size={18} />}
      </button>

      {/* Brand Header */}
      <div className="flex flex-col items-center text-center mb-8">
        <div className="p-3 bg-[#F59E0B]/10 border border-[#F59E0B]/30 rounded-xl text-[#F59E0B] mb-3">
          <ShieldCheck size={36} />
        </div>
        <h1 className="font-space font-bold text-2xl text-theme-main tracking-wider">
          ARGUS <span className="text-[#F59E0B]">{'//'}</span> CONTROL
        </h1>
        <p className="text-xs text-theme-muted font-mono mt-1">QC MANAGEMENT & ADMIN PORTAL</p>
      </div>

      {/* Error Alert */}
      {errorMsg && (
        <div className="mb-6 p-4 bg-red-500/10 border border-red-500/30 rounded-lg flex items-start gap-3 text-red-500 text-sm">
          <AlertCircle size={20} className="shrink-0 mt-0.5" />
          <div>{errorMsg}</div>
        </div>
      )}

      {/* Login Form */}
      <form onSubmit={handleLogin} className="space-y-5">
        <div>
          <label className="block text-xs font-mono font-medium text-theme-muted mb-2 uppercase">
            Plant Email Address
          </label>
          <div className="relative">
            <Mail className="absolute left-3.5 top-3 text-theme-muted" size={18} />
            <input
              type="email"
              required
              value={email}
              onChange={(e) => setEmail(e.target.value)}
              placeholder="admin@signode.com"
              className="w-full bg-theme-input border border-theme focus:border-[#F59E0B] rounded-lg pl-10 pr-4 py-2.5 text-sm text-theme-main placeholder-theme-muted focus:outline-none transition-colors"
            />
          </div>
        </div>

        <div>
          <label className="block text-xs font-mono font-medium text-theme-muted mb-2 uppercase">
            Security Password
          </label>
          <div className="relative">
            <Lock className="absolute left-3.5 top-3 text-theme-muted" size={18} />
            <input
              type={showPassword ? 'text' : 'password'}
              required
              value={password}
              onChange={(e) => setPassword(e.target.value)}
              placeholder="••••••••"
              className="w-full bg-theme-input border border-theme focus:border-[#F59E0B] rounded-lg pl-10 pr-4 py-2.5 text-sm text-theme-main placeholder-theme-muted focus:outline-none transition-colors"
            />
            <button
              type="button"
              onClick={() => setShowPassword(!showPassword)}
              className="absolute right-3.5 top-3 text-theme-muted hover:text-theme-main transition-colors"
            >
              {showPassword ? <EyeOff size={18} /> : <Eye size={18} />}
            </button>
          </div>
        </div>

        <button
          type="submit"
          disabled={loading}
          className="w-full mt-2 bg-[#F59E0B] hover:bg-[#F59E0B]/90 text-slate-950 font-space font-bold py-3 rounded-lg text-sm tracking-wider uppercase transition-all shadow-lg shadow-[#F59E0B]/10 disabled:opacity-50"
        >
          {loading ? 'Authenticating Session...' : 'Sign In to Portal'}
        </button>
      </form>
    </div>
  );
}

export default function LoginPage() {
  return (
    <div className="min-h-screen w-screen bg-theme-main flex items-center justify-center p-4 transition-colors">
      <Suspense fallback={<div className="text-theme-muted font-mono text-sm">Loading Login Portal...</div>}>
        <LoginForm />
      </Suspense>
    </div>
  );
}
