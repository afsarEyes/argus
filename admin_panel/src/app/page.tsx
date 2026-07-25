'use client';

import React, { useEffect, useState, useCallback } from 'react';
import AdminDashboardLayout from '@/components/layout/AdminDashboardLayout';
import { supabase } from '@/lib/supabase';
import { Ticket, Line, DefectCategory } from '@/types/database';
import {
  Ticket as TicketIcon,
  AlertTriangle,
  Clock,
  CheckCircle2,
  TrendingUp,
  Activity,
} from 'lucide-react';
import {
  BarChart,
  Bar,
  XAxis,
  YAxis,
  Tooltip,
  ResponsiveContainer,
  PieChart,
  Pie,
  Cell,
} from 'recharts';

const COLORS = ['#F59E0B', '#3B82F6', '#EC4899', '#8B5CF6', '#10B981'];

export default function DashboardPage() {
  const [tickets, setTickets] = useState<Ticket[]>([]);
  const [lines, setLines] = useState<Line[]>([]);
  const [categories, setCategories] = useState<DefectCategory[]>([]);
  const [loading, setLoading] = useState(true);

  const loadData = useCallback(async () => {
    try {
      const [ticketsRes, linesRes, catRes] = await Promise.all([
        supabase.from('tickets').select('*'),
        supabase.from('lines').select('*'),
        supabase.from('defect_categories').select('*'),
      ]);

      setTickets((ticketsRes.data as Ticket[]) || []);
      setLines((linesRes.data as Line[]) || []);
      setCategories((catRes.data as DefectCategory[]) || []);
    } catch (err) {
      console.error('Failed to load dashboard metrics:', err);
    } finally {
      setLoading(false);
    }
  }, []);

  useEffect(() => {
    let isMounted = true;
    const fetchData = async () => {
      try {
        const [ticketsRes, linesRes, catRes] = await Promise.all([
          supabase.from('tickets').select('*'),
          supabase.from('lines').select('*'),
          supabase.from('defect_categories').select('*'),
        ]);
        if (isMounted) {
          setTickets((ticketsRes.data as Ticket[]) || []);
          setLines((linesRes.data as Line[]) || []);
          setCategories((catRes.data as DefectCategory[]) || []);
          setLoading(false);
        }
      } catch (err) {
        console.error('Failed to load metrics:', err);
        if (isMounted) setLoading(false);
      }
    };

    fetchData();

    const channel = supabase
      .channel('schema-db-changes')
      .on('postgres_changes', { event: '*', schema: 'public', table: 'tickets' }, () => {
        fetchData();
      })
      .subscribe();

    return () => {
      isMounted = false;
      supabase.removeChannel(channel);
    };
  }, []);

  // Compute Metrics
  const totalTickets = tickets.length;
  const openTickets = tickets.filter((t) => t.status === 'open' || t.status === 'assigned' || t.status === 'in_progress').length;
  const resolvedTickets = tickets.filter((t) => t.status === 'resolved' || t.status === 'closed').length;

  // Breach count
  const breachedCount = tickets.filter((t) => {
    let target = 120;
    if (t.severity === 'critical') target = 30;
    if (t.severity === 'major') target = 60;
    const deadline = new Date(new Date(t.created_at).getTime() + target * 60000);
    return new Date() > deadline && t.status !== 'resolved' && t.status !== 'closed';
  }).length;

  const breachRate = totalTickets > 0 ? Math.round((breachedCount / totalTickets) * 100) : 0;

  // Line Distribution Chart Data
  const lineChartData = lines.map((line) => {
    const count = tickets.filter((t) => t.line_id === line.id).length;
    return { name: line.name, tickets: count };
  });

  // Category Distribution Chart Data
  const categoryChartData = categories.map((cat) => {
    const count = tickets.filter((t) => t.defect_category_id === cat.id).length;
    return { name: cat.name, count };
  }).filter((c) => c.count > 0);

  return (
    <AdminDashboardLayout>
      <div className="space-y-6">
        {/* Page Header */}
        <div className="flex justify-between items-center">
          <div>
            <h1 className="font-space font-bold text-2xl text-slate-100 tracking-wide">
              OPERATIONAL ANALYTICS DASHBOARD
            </h1>
            <p className="text-xs text-slate-400 font-mono mt-1">
              Real-time plant issue tracking & SLA breach performance
            </p>
          </div>
          <div className="flex items-center gap-2 px-3 py-1.5 bg-[#131B2E] border border-[#1E293B] rounded-lg text-xs font-mono text-slate-300">
            <Activity size={14} className="text-[#F59E0B]" />
            <span>LIVE DATABASE MONITORING</span>
          </div>
        </div>

        {/* KPI Cards Grid */}
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-4">
          <div className="bg-[#131B2E] border border-[#1E293B] p-5 rounded-xl flex items-center justify-between">
            <div>
              <p className="text-xs font-mono text-slate-400 uppercase">Total Tickets Logged</p>
              <h3 className="font-space font-bold text-3xl text-slate-100 mt-1">{totalTickets}</h3>
            </div>
            <div className="p-3 bg-blue-950/40 border border-blue-800/40 rounded-xl text-blue-400">
              <TicketIcon size={24} />
            </div>
          </div>

          <div className="bg-[#131B2E] border border-[#1E293B] p-5 rounded-xl flex items-center justify-between">
            <div>
              <p className="text-xs font-mono text-slate-400 uppercase">Active Floor Issues</p>
              <h3 className="font-space font-bold text-3xl text-[#F59E0B] mt-1">{openTickets}</h3>
            </div>
            <div className="p-3 bg-[#F59E0B]/10 border border-[#F59E0B]/30 rounded-xl text-[#F59E0B]">
              <Clock size={24} />
            </div>
          </div>

          <div className="bg-[#131B2E] border border-[#1E293B] p-5 rounded-xl flex items-center justify-between">
            <div>
              <p className="text-xs font-mono text-slate-400 uppercase">SLA Breach Rate</p>
              <h3 className="font-space font-bold text-3xl text-red-400 mt-1">{breachRate}%</h3>
              <p className="text-[10px] text-slate-500 font-mono mt-0.5">{breachedCount} tickets overdue</p>
            </div>
            <div className="p-3 bg-red-950/40 border border-red-800/40 rounded-xl text-red-400">
              <AlertTriangle size={24} />
            </div>
          </div>

          <div className="bg-[#131B2E] border border-[#1E293B] p-5 rounded-xl flex items-center justify-between">
            <div>
              <p className="text-xs font-mono text-slate-400 uppercase">Resolved & Closed</p>
              <h3 className="font-space font-bold text-3xl text-emerald-400 mt-1">{resolvedTickets}</h3>
            </div>
            <div className="p-3 bg-emerald-950/40 border border-emerald-800/40 rounded-xl text-emerald-400">
              <CheckCircle2 size={24} />
            </div>
          </div>
        </div>

        {/* Charts Grid */}
        <div className="grid grid-cols-1 lg:grid-cols-3 gap-6">
          {/* Bar Chart: Tickets per Production Line */}
          <div className="lg:col-span-2 bg-[#131B2E] border border-[#1E293B] p-6 rounded-xl space-y-4">
            <div className="flex items-center justify-between">
              <h2 className="font-space font-bold text-slate-200 tracking-wide flex items-center gap-2">
                <TrendingUp size={18} className="text-[#F59E0B]" />
                <span>Ticketing Volume by Production Line</span>
              </h2>
              <span className="text-xs font-mono text-slate-500">Live Breakdown</span>
            </div>
            <div className="h-64 w-full">
              {loading ? (
                <div className="h-full flex items-center justify-center text-xs text-slate-500 font-mono">Loading chart...</div>
              ) : (
                <ResponsiveContainer width="100%" height="100%">
                  <BarChart data={lineChartData}>
                    <XAxis dataKey="name" stroke="#64748B" fontSize={11} />
                    <YAxis stroke="#64748B" fontSize={11} />
                    <Tooltip
                      contentStyle={{ backgroundColor: '#0B0F19', borderColor: '#1E293B', color: '#F8FAFC' }}
                    />
                    <Bar dataKey="tickets" fill="#F59E0B" radius={[4, 4, 0, 0]} />
                  </BarChart>
                </ResponsiveContainer>
              )}
            </div>
          </div>

          {/* Pie Chart: Defect Categories */}
          <div className="bg-[#131B2E] border border-[#1E293B] p-6 rounded-xl space-y-4">
            <h2 className="font-space font-bold text-slate-200 tracking-wide">Defect Taxonomy Distribution</h2>
            <div className="h-64 w-full flex items-center justify-center">
              {loading ? (
                <div className="text-xs text-slate-500 font-mono">Loading taxonomy...</div>
              ) : (
                <ResponsiveContainer width="100%" height="100%">
                  <PieChart>
                    <Pie
                      data={categoryChartData}
                      dataKey="count"
                      nameKey="name"
                      cx="50%"
                      cy="50%"
                      outerRadius={80}
                      label
                    >
                      {categoryChartData.map((entry, index) => (
                        <Cell key={`cell-${index}`} fill={COLORS[index % COLORS.length]} />
                      ))}
                    </Pie>
                    <Tooltip
                      contentStyle={{ backgroundColor: '#0B0F19', borderColor: '#1E293B', color: '#F8FAFC' }}
                    />
                  </PieChart>
                </ResponsiveContainer>
              )}
            </div>
          </div>
        </div>
      </div>
    </AdminDashboardLayout>
  );
}
