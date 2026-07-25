'use client';

import React, { useEffect, useState } from 'react';
import { Activity, Radio, RefreshCw, Sun, Moon } from 'lucide-react';
import { useTheme } from '@/context/ThemeContext';

export default function Header() {
  const [timeStr, setTimeStr] = useState<string>('');
  const { theme, toggleTheme } = useTheme();

  useEffect(() => {
    const updateTime = () => {
      const now = new Date();
      setTimeStr(now.toLocaleTimeString('en-US', { hour12: false }));
    };
    updateTime();
    const interval = setInterval(updateTime, 1000);
    return () => clearInterval(interval);
  }, []);

  return (
    <header className="h-16 bg-theme-header border-b border-theme px-6 flex items-center justify-between sticky top-0 z-10 transition-colors">
      <div className="flex items-center gap-3">
        <div className="flex items-center gap-2 text-emerald-500 bg-emerald-500/10 border border-emerald-500/30 px-3 py-1 rounded-full text-xs font-mono">
          <Radio size={12} className="animate-pulse" />
          <span>SUPABASE LIVE SYNC</span>
        </div>
      </div>

      <div className="flex items-center gap-4">
        {/* Time Widget */}
        <div className="hidden sm:flex items-center gap-2 text-theme-muted font-mono text-sm">
          <Activity size={16} className="text-[#F59E0B]" />
          <span>{timeStr || '00:00:00'} UTC</span>
        </div>

        {/* Refresh Button */}
        <button
          onClick={() => window.location.reload()}
          className="flex items-center gap-1.5 px-3 py-1.5 bg-theme-input hover:bg-theme-card text-theme-main text-xs font-medium rounded-md border border-theme transition-colors"
        >
          <RefreshCw size={13} />
          <span className="hidden sm:inline">Refresh</span>
        </button>

        {/* Light / Dark Mode Toggle */}
        <button
          onClick={toggleTheme}
          title={theme === 'dark' ? 'Switch to Light Mode' : 'Switch to Dark Mode'}
          className="p-2 bg-theme-input hover:bg-theme-card text-theme-main rounded-md border border-theme transition-colors flex items-center justify-center text-[#F59E0B]"
        >
          {theme === 'dark' ? <Sun size={18} /> : <Moon size={18} />}
        </button>
      </div>
    </header>
  );
}
