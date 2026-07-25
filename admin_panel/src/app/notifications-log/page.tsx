'use client';

import React, { useEffect, useState } from 'react';
import AdminDashboardLayout from '@/components/layout/AdminDashboardLayout';
import { supabase } from '@/lib/supabase';
import { NotificationLog } from '@/types/database';
import { Bell, CheckCircle2, AlertCircle, Clock, Search } from 'lucide-react';

export default function NotificationsLogPage() {
  const [logs, setLogs] = useState<NotificationLog[]>([]);
  const [loading, setLoading] = useState(true);
  const [search, setSearch] = useState('');
  const [channelFilter, setChannelFilter] = useState('ALL');

  useEffect(() => {
    let isMounted = true;

    const fetchData = async () => {
      try {
        const { data, error } = await supabase
          .from('notifications_log')
          .select('*')
          .order('created_at', { ascending: false });
        if (error) throw error;

        if (isMounted) {
          setLogs((data as NotificationLog[]) || []);
          setLoading(false);
        }
      } catch (err) {
        console.error('Error loading notification logs:', err);
        if (isMounted) setLoading(false);
      }
    };

    fetchData();

    return () => {
      isMounted = false;
    };
  }, []);

  const filteredLogs = logs.filter((l) => {
    const matchesSearch =
      l.title.toLowerCase().includes(search.toLowerCase()) ||
      l.body.toLowerCase().includes(search.toLowerCase());
    const matchesChannel = channelFilter === 'ALL' || l.channel === channelFilter;
    return matchesSearch && matchesChannel;
  });

  return (
    <AdminDashboardLayout>
      <div className="space-y-6">
        {/* Header */}
        <div className="flex flex-col sm:flex-row justify-between sm:items-center gap-4">
          <div>
            <h1 className="font-space font-bold text-2xl text-slate-100 tracking-wide">
              SYSTEM NOTIFICATIONS & WEBHOOK LOG
            </h1>
            <p className="text-xs text-slate-400 font-mono mt-1">
              Inspect outbound SLA breach alerts, automated push notifications, and webhook delivery status
            </p>
          </div>
        </div>

        {/* Filters */}
        <div className="bg-[#131B2E] border border-[#1E293B] p-4 rounded-xl flex flex-col md:flex-row gap-4 justify-between">
          <div className="relative flex-1">
            <Search size={18} className="absolute left-3.5 top-3 text-slate-500" />
            <input
              type="text"
              value={search}
              onChange={(e) => setSearch(e.target.value)}
              placeholder="Search notifications by title or message content..."
              className="w-full bg-[#0B0F19] border border-[#1E293B] focus:border-[#F59E0B] rounded-lg pl-10 pr-4 py-2 text-sm text-slate-100 placeholder-slate-600 focus:outline-none"
            />
          </div>
          <div className="flex items-center gap-2">
            <span className="text-xs font-mono text-slate-400">CHANNEL:</span>
            <select
              value={channelFilter}
              onChange={(e) => setChannelFilter(e.target.value)}
              className="bg-[#0B0F19] border border-[#1E293B] focus:border-[#F59E0B] rounded-lg px-3 py-2 text-sm text-slate-200 focus:outline-none"
            >
              <option value="ALL">All Channels</option>
              <option value="push">Push Notification</option>
              <option value="email">Email Alert</option>
              <option value="in_app">In-App Alert</option>
            </select>
          </div>
        </div>

        {/* Table */}
        <div className="bg-[#131B2E] border border-[#1E293B] rounded-xl overflow-hidden shadow-xl">
          <table className="w-full text-left text-sm text-slate-300">
            <thead className="bg-[#0B0F19] text-xs font-mono uppercase text-slate-400 border-b border-[#1E293B]">
              <tr>
                <th className="px-6 py-3.5">Timestamp</th>
                <th className="px-6 py-3.5">Notification Title & Content</th>
                <th className="px-6 py-3.5">Channel</th>
                <th className="px-6 py-3.5 text-right">Delivery Status</th>
              </tr>
            </thead>
            <tbody className="divide-y divide-[#1E293B]">
              {loading ? (
                <tr>
                  <td colSpan={4} className="text-center py-8 text-xs font-mono text-slate-500">
                    Loading notification audit logs...
                  </td>
                </tr>
              ) : filteredLogs.length === 0 ? (
                <tr>
                  <td colSpan={4} className="text-center py-8 text-xs font-mono text-slate-500">
                    No notification logs recorded yet.
                  </td>
                </tr>
              ) : (
                filteredLogs.map((l) => (
                  <tr key={l.id} className="hover:bg-[#1E293B]/40">
                    <td className="px-6 py-4 font-mono text-xs text-slate-400 whitespace-nowrap">
                      {new Date(l.created_at).toLocaleString()}
                    </td>
                    <td className="px-6 py-4">
                      <p className="font-semibold text-slate-100 flex items-center gap-2">
                        <Bell size={16} className="text-[#F59E0B]" />
                        <span>{l.title}</span>
                      </p>
                      <p className="text-xs text-slate-400 mt-1">{l.body}</p>
                    </td>
                    <td className="px-6 py-4 font-mono text-xs uppercase text-slate-300">
                      <span className="px-2 py-0.5 bg-[#0B0F19] border border-slate-700 rounded">
                        {l.channel}
                      </span>
                    </td>
                    <td className="px-6 py-4 text-right">
                      <span
                        className={`inline-flex items-center gap-1.5 px-2.5 py-0.5 text-xs font-mono rounded-full ${
                          l.status === 'sent'
                            ? 'bg-emerald-950/40 text-emerald-400 border border-emerald-800/40'
                            : l.status === 'pending'
                            ? 'bg-[#F59E0B]/10 text-[#F59E0B] border border-[#F59E0B]/30'
                            : 'bg-red-950/40 text-red-400 border border-red-800/40'
                        }`}
                      >
                        {l.status === 'sent' && <CheckCircle2 size={12} />}
                        {l.status === 'pending' && <Clock size={12} />}
                        {l.status === 'failed' && <AlertCircle size={12} />}
                        <span className="uppercase">{l.status}</span>
                      </span>
                    </td>
                  </tr>
                ))
              )}
            </tbody>
          </table>
        </div>
      </div>
    </AdminDashboardLayout>
  );
}
