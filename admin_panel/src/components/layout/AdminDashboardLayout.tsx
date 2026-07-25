'use client';

import React from 'react';
import Sidebar from './Sidebar';
import Header from './Header';
import { useAuth } from '@/context/AuthContext';

export default function AdminDashboardLayout({ children }: { children: React.ReactNode }) {
  const { loading, userProfile } = useAuth();

  if (loading) {
    return (
      <div className="h-screen w-screen bg-[#0B0F19] flex flex-col items-center justify-center gap-4">
        <div className="w-10 h-10 border-4 border-[#F59E0B] border-t-transparent rounded-full animate-spin"></div>
        <p className="font-mono text-sm text-slate-400">Authenticating Argus Admin Session...</p>
      </div>
    );
  }

  if (!userProfile) {
    return null;
  }

  return (
    <div className="flex min-h-screen bg-[#0B0F19]">
      <Sidebar />
      <div className="flex-1 flex flex-col min-w-0">
        <Header />
        <main className="flex-1 p-6 overflow-y-auto">{children}</main>
      </div>
    </div>
  );
}
