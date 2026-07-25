'use client';

import React from 'react';
import Link from 'next/link';
import { usePathname } from 'next/navigation';
import {
  LayoutDashboard,
  Ticket,
  Users,
  Factory,
  Tag,
  GitMerge,
  Clock,
  FileSpreadsheet,
  FileCheck2,
  Bell,
  ShieldCheck,
  LogOut,
} from 'lucide-react';
import { useAuth } from '@/context/AuthContext';

const NAV_ITEMS = [
  { label: 'Dashboard Overview', href: '/', icon: LayoutDashboard },
  { label: 'Live Ticket Auditor', href: '/tickets', icon: Ticket },
  { label: 'Daily Quality Reports', href: '/daily-reports', icon: FileCheck2 },
  { label: 'Users & Staff Master', href: '/users', icon: Users },
  { label: 'Plant Layout Master', href: '/layout-master', icon: Factory },
  { label: 'Taxonomy Master', href: '/taxonomy', icon: Tag },
  { label: 'Routing Engine', href: '/routing-rules', icon: GitMerge },
  { label: 'SLA Target Manager', href: '/sla-targets', icon: Clock },
  { label: 'Reports & Export', href: '/reports', icon: FileSpreadsheet },
  { label: 'Notifications Log', href: '/notifications-log', icon: Bell },
];

export default function Sidebar() {
  const pathname = usePathname();
  const { userProfile, signOut } = useAuth();

  return (
    <aside className="w-64 bg-theme-sidebar border-r border-theme flex flex-col justify-between h-screen sticky top-0 transition-colors">
      <div>
        {/* Brand Header */}
        <div className="p-6 border-b border-theme flex items-center gap-3">
          <div className="p-2 bg-[#F59E0B]/10 border border-[#F59E0B]/30 rounded-lg text-[#F59E0B]">
            <ShieldCheck size={24} />
          </div>
          <div>
            <h1 className="font-space font-bold text-lg text-theme-main tracking-wider">
              ARGUS <span className="text-[#F59E0B]">{'//'}</span> WEB
            </h1>
            <p className="text-xs text-theme-muted font-mono">QC CONTROL CENTER</p>
          </div>
        </div>

        {/* Navigation Section */}
        <nav className="p-4 space-y-1">
          {NAV_ITEMS.map((item) => {
            const Icon = item.icon;
            const isActive = pathname === item.href;

            return (
              <Link
                key={item.href}
                href={item.href}
                className={`flex items-center gap-3 px-3 py-2.5 rounded-md text-sm font-medium transition-all ${
                  isActive
                    ? 'bg-[#F59E0B] text-slate-950 font-bold shadow-md shadow-[#F59E0B]/10'
                    : 'text-theme-muted hover:bg-theme-input hover:text-theme-main'
                }`}
              >
                <Icon size={18} className={isActive ? 'text-slate-950' : 'text-[#F59E0B]'} />
                <span>{item.label}</span>
              </Link>
            );
          })}
        </nav>
      </div>

      {/* User Footer Profile */}
      <div className="p-4 border-t border-theme bg-theme-main/50">
        <div className="flex items-center justify-between">
          <div className="overflow-hidden">
            <p className="text-sm font-semibold text-theme-main truncate">
              {userProfile?.name || 'Operator'}
            </p>
            <span className="inline-block px-2 py-0.5 mt-0.5 text-[10px] font-mono font-semibold uppercase bg-[#F59E0B]/10 border border-[#F59E0B]/30 text-[#F59E0B] rounded">
              {userProfile?.role || 'User'}
            </span>
          </div>

          <button
            onClick={signOut}
            title="Sign Out"
            className="p-2 text-theme-muted hover:text-red-500 hover:bg-red-500/10 rounded-md transition-colors"
          >
            <LogOut size={18} />
          </button>
        </div>
      </div>
    </aside>
  );
}
