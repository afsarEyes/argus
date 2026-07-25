'use client';

import React, { useEffect, useState } from 'react';
import { Activity, Radio, RefreshCw } from 'lucide-react';

export default function Header() {
  const [timeStr, setTimeStr] = useState<string>('');

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
    <header className="h-16 bg-[#131B2E] border-b border-[#1E293B] px-6 flex items-center justify-between sticky top-0 z-10">
      <div className="flex items-center gap-3">
        <div className="flex items-center gap-2 text-emerald-400 bg-emerald-950/40 border border-emerald-800/40 px-3 py-1 rounded-full text-xs font-mono">
          <Radio size={12} className="animate-pulse" />
          <span>SUPABASE LIVE SYNC</span>
        </div>
      </div>

      <div className="flex items-center gap-6">
        <div className="flex items-center gap-2 text-slate-400 font-mono text-sm">
          <Activity size={16} className="text-[#F59E0B]" />
          <span>{timeStr || '00:00:00'} UTC</span>
        </div>

        <button
          onClick={() => window.location.reload()}
          className="flex items-center gap-1.5 px-3 py-1.5 bg-[#1E293B] hover:bg-[#1E293B]/80 text-slate-200 text-xs font-medium rounded-md border border-slate-700 transition-colors"
        >
          <RefreshCw size={13} />
          <span>Refresh</span>
        </button>
      </div>
    </header>
  );
}
