'use client';

import React, { useState, useEffect, Suspense } from 'react';
import { useRouter, useSearchParams } from 'next/navigation';
import { ShieldCheck, Lock, Mail, Eye, EyeOff, AlertCircle } from 'lucide-react';
import { supabase } from '@/lib/supabase';

function LoginForm() {
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [showPassword, setShowPassword] = useState(false);
  const [loading, setLoading] = useState(false);
  const [errorMsg, setErrorMsg] = useState<string | null>(null);

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
    <div className="w-full max-w-md bg-[#131B2E] border border-[#1E293B] rounded-xl shadow-2xl p-8">
      {/* Brand Header */}
      <div className="flex flex-col items-center text-center mb-8">
        <div className="p-3 bg-[#F59E0B]/10 border border-[#F59E0B]/30 rounded-xl text-[#F59E0B] mb-3">
          <ShieldCheck size={36} />
        </div>
        <h1 className="font-space font-bold text-2xl text-slate-100 tracking-wider">
          ARGUS <span className="text-[#F59E0B]">{'//'}</span> CONTROL
        </h1>
        <p className="text-xs text-slate-400 font-mono mt-1">QC MANAGEMENT & ADMIN PORTAL</p>
      </div>

      {/* Error Alert */}
      {errorMsg && (
        <div className="mb-6 p-4 bg-red-950/40 border border-red-800/50 rounded-lg flex items-start gap-3 text-red-200 text-sm">
          <AlertCircle size={20} className="text-red-400 shrink-0 mt-0.5" />
          <div>{errorMsg}</div>
        </div>
      )}

      {/* Login Form */}
      <form onSubmit={handleLogin} className="space-y-5">
        <div>
          <label className="block text-xs font-mono font-medium text-slate-300 mb-2 uppercase">
            Plant Email Address
          </label>
          <div className="relative">
            <Mail className="absolute left-3.5 top-3 text-slate-500" size={18} />
            <input
              type="email"
              required
              value={email}
              onChange={(e) => setEmail(e.target.value)}
              placeholder="admin@signode.com"
              className="w-full bg-[#0B0F19] border border-[#1E293B] focus:border-[#F59E0B] rounded-lg pl-10 pr-4 py-2.5 text-sm text-slate-100 placeholder-slate-600 focus:outline-none transition-colors"
            />
          </div>
        </div>

        <div>
          <label className="block text-xs font-mono font-medium text-slate-300 mb-2 uppercase">
            Security Password
          </label>
          <div className="relative">
            <Lock className="absolute left-3.5 top-3 text-slate-500" size={18} />
            <input
              type={showPassword ? 'text' : 'password'}
              required
              value={password}
              onChange={(e) => setPassword(e.target.value)}
              placeholder="••••••••"
              className="w-full bg-[#0B0F19] border border-[#1E293B] focus:border-[#F59E0B] rounded-lg pl-10 pr-10 py-2.5 text-sm text-slate-100 placeholder-slate-600 focus:outline-none transition-colors"
            />
            <button
              type="button"
              onClick={() => setShowPassword(!showPassword)}
              className="absolute right-3.5 top-3 text-slate-500 hover:text-slate-300 transition-colors"
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
    <div className="min-h-screen w-screen bg-[#0B0F19] flex items-center justify-center p-4">
      <Suspense fallback={<div className="text-slate-400 font-mono text-sm">Loading Login Portal...</div>}>
        <LoginForm />
      </Suspense>
    </div>
  );
}
