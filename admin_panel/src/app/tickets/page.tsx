'use client';

import React, { useEffect, useState } from 'react';
import AdminDashboardLayout from '@/components/layout/AdminDashboardLayout';
import { supabase } from '@/lib/supabase';
import { Ticket, TicketEvent, Line, DefectCategory } from '@/types/database';
import { Search, Eye, X } from 'lucide-react';

export default function LiveTicketsPage() {
  const [tickets, setTickets] = useState<Ticket[]>([]);
  const [loading, setLoading] = useState(true);
  const [search, setSearch] = useState('');
  const [statusFilter, setStatusFilter] = useState('ALL');

  // Detail Drawer State
  const [selectedTicket, setSelectedTicket] = useState<Ticket | null>(null);
  const [ticketEvents, setTicketEvents] = useState<TicketEvent[]>([]);
  const [eventsLoading, setEventsLoading] = useState(false);

  useEffect(() => {
    let isMounted = true;

    const fetchData = async () => {
      try {
        const [ticketsRes] = await Promise.all([
          supabase
            .from('tickets')
            .select('*, reporter:users!tickets_reporter_id_fkey(*), assigned_owner:users!tickets_assigned_owner_id_fkey(*), line:lines(*), station:stations(*), defect_category:defect_categories(*)')
            .order('created_at', { ascending: false }),
        ]);

        if (isMounted) {
          setTickets((ticketsRes.data as Ticket[]) || []);
          setLoading(false);
        }
      } catch (err) {
        console.error('Error loading tickets:', err);
        if (isMounted) setLoading(false);
      }
    };

    fetchData();

    const channel = supabase
      .channel('schema-tickets')
      .on('postgres_changes', { event: '*', schema: 'public', table: 'tickets' }, () => {
        fetchData();
      })
      .subscribe();

    return () => {
      isMounted = false;
      supabase.removeChannel(channel);
    };
  }, []);

  const openDrawer = async (ticket: Ticket) => {
    setSelectedTicket(ticket);
    setEventsLoading(true);
    try {
      const { data } = await supabase
        .from('ticket_events')
        .select('*, actor:users(*)')
        .eq('ticket_id', ticket.id)
        .order('created_at', { ascending: false });
      setTicketEvents((data as TicketEvent[]) || []);
    } catch (err) {
      console.error('Failed to load events:', err);
    } finally {
      setEventsLoading(false);
    }
  };

  const filteredTickets = tickets.filter((t) => {
    const matchesSearch =
      (t.human_readable_id && t.human_readable_id.toLowerCase().includes(search.toLowerCase())) ||
      (t.description && t.description.toLowerCase().includes(search.toLowerCase())) ||
      t.id.toLowerCase().includes(search.toLowerCase());
    const matchesStatus = statusFilter === 'ALL' || t.status === statusFilter;
    return matchesSearch && matchesStatus;
  });

  return (
    <AdminDashboardLayout>
      <div className="space-y-6">
        {/* Header */}
        <div className="flex flex-col sm:flex-row justify-between sm:items-center gap-4">
          <div>
            <h1 className="font-space font-bold text-2xl text-slate-100 tracking-wide">
              LIVE TICKET AUDITOR
            </h1>
            <p className="text-xs text-slate-400 font-mono mt-1">
              Real-time quality control issue stream and full event audit trail
            </p>
          </div>
        </div>

        {/* Filter Controls */}
        <div className="bg-[#131B2E] border border-[#1E293B] p-4 rounded-xl flex flex-col md:flex-row gap-4 justify-between">
          <div className="relative flex-1">
            <Search size={18} className="absolute left-3.5 top-3 text-slate-500" />
            <input
              type="text"
              value={search}
              onChange={(e) => setSearch(e.target.value)}
              placeholder="Search by ticket ID (ARG-2026-...) or description..."
              className="w-full bg-[#0B0F19] border border-[#1E293B] focus:border-[#F59E0B] rounded-lg pl-10 pr-4 py-2 text-sm text-slate-100 placeholder-slate-600 focus:outline-none"
            />
          </div>
          <div className="flex items-center gap-2">
            <span className="text-xs font-mono text-slate-400">STATUS:</span>
            <select
              value={statusFilter}
              onChange={(e) => setStatusFilter(e.target.value)}
              className="bg-[#0B0F19] border border-[#1E293B] focus:border-[#F59E0B] rounded-lg px-3 py-2 text-sm text-slate-200 focus:outline-none"
            >
              <option value="ALL">All Statuses</option>
              <option value="open">Open</option>
              <option value="assigned">Assigned</option>
              <option value="in_progress">In Progress</option>
              <option value="resolved">Resolved</option>
              <option value="closed">Closed</option>
            </select>
          </div>
        </div>

        {/* Table */}
        <div className="bg-[#131B2E] border border-[#1E293B] rounded-xl overflow-hidden shadow-xl">
          <table className="w-full text-left text-sm text-slate-300">
            <thead className="bg-[#0B0F19] text-xs font-mono uppercase text-slate-400 border-b border-[#1E293B]">
              <tr>
                <th className="px-6 py-3.5">Ticket Reference</th>
                <th className="px-6 py-3.5">Defect & Line</th>
                <th className="px-6 py-3.5">Severity</th>
                <th className="px-6 py-3.5">Assigned Lead</th>
                <th className="px-6 py-3.5">Status</th>
                <th className="px-6 py-3.5 text-right">View Audit</th>
              </tr>
            </thead>
            <tbody className="divide-y divide-[#1E293B]">
              {loading ? (
                <tr>
                  <td colSpan={6} className="text-center py-8 text-xs font-mono text-slate-500">
                    Loading live tickets...
                  </td>
                </tr>
              ) : filteredTickets.length === 0 ? (
                <tr>
                  <td colSpan={6} className="text-center py-8 text-xs font-mono text-slate-500">
                    No tickets found matching current filters.
                  </td>
                </tr>
              ) : (
                filteredTickets.map((t) => (
                  <tr key={t.id} className="hover:bg-[#1E293B]/40">
                    <td className="px-6 py-4 font-mono font-bold text-slate-100">
                      {t.human_readable_id || t.id.substring(0, 8)}
                      <p className="text-[10px] font-normal text-slate-400">{new Date(t.created_at).toLocaleString()}</p>
                    </td>
                    <td className="px-6 py-4">
                      <p className="font-semibold text-slate-200">{t.defect_category?.name || 'Defect Category'}</p>
                      <p className="text-xs font-mono text-slate-400">{t.line?.name} {'//'} {t.station?.name}</p>
                    </td>
                    <td className="px-6 py-4">
                      <span
                        className={`inline-block px-2 py-0.5 text-xs font-mono font-bold uppercase rounded ${
                          t.severity === 'critical'
                            ? 'bg-red-950/60 border border-red-800 text-red-400'
                            : t.severity === 'major'
                            ? 'bg-[#F59E0B]/10 border border-[#F59E0B]/30 text-[#F59E0B]'
                            : 'bg-blue-950/60 border border-blue-800 text-blue-400'
                        }`}
                      >
                        {t.severity}
                      </span>
                    </td>
                    <td className="px-6 py-4 text-xs font-mono">
                      {t.assigned_owner ? t.assigned_owner.name : <span className="text-slate-500">Unassigned</span>}
                    </td>
                    <td className="px-6 py-4">
                      <span
                        className={`inline-block px-2.5 py-1 text-xs font-mono font-bold uppercase rounded ${
                          t.status === 'open'
                            ? 'bg-blue-950/50 text-blue-300 border border-blue-800'
                            : t.status === 'assigned'
                            ? 'bg-purple-950/50 text-purple-300 border border-purple-800'
                            : t.status === 'in_progress'
                            ? 'bg-[#F59E0B]/10 text-[#F59E0B] border border-[#F59E0B]/30'
                            : 'bg-emerald-950/50 text-emerald-300 border border-emerald-800'
                        }`}
                      >
                        {t.status.replace('_', ' ')}
                      </span>
                    </td>
                    <td className="px-6 py-4 text-right">
                      <button onClick={() => openDrawer(t)} className="p-1.5 text-slate-400 hover:text-[#F59E0B]">
                        <Eye size={16} />
                      </button>
                    </td>
                  </tr>
                ))
              )}
            </tbody>
          </table>
        </div>

        {/* Audit Timeline Drawer */}
        {selectedTicket && (
          <div className="fixed inset-0 z-50 bg-black/70 backdrop-blur-sm flex justify-end">
            <div className="bg-[#131B2E] border-l border-[#1E293B] w-full max-w-lg h-full overflow-y-auto p-6 space-y-6">
              <div className="flex items-center justify-between border-b border-[#1E293B] pb-4">
                <div>
                  <h2 className="font-mono font-bold text-lg text-slate-100">
                    {selectedTicket.human_readable_id || selectedTicket.id}
                  </h2>
                  <p className="text-xs text-[#F59E0B] font-mono">{selectedTicket.defect_category?.name}</p>
                </div>
                <button onClick={() => setSelectedTicket(null)} className="text-slate-400 hover:text-slate-200">
                  <X size={20} />
                </button>
              </div>

              <div className="space-y-3 bg-[#0B0F19] p-4 rounded-lg border border-[#1E293B]">
                <p className="text-xs font-mono text-slate-400 uppercase">Issue Description</p>
                <p className="text-sm text-slate-200">{selectedTicket.description}</p>
              </div>

              {selectedTicket.photo_paths && selectedTicket.photo_paths.length > 0 && (
                <div>
                  <p className="text-xs font-mono text-slate-400 uppercase mb-2">Attached Defect Photos</p>
                  <div className="flex gap-2 overflow-x-auto">
                    {selectedTicket.photo_paths.map((p, idx) => (
                      <img key={idx} src={p} alt="Defect" className="w-24 h-24 object-cover rounded border border-[#1E293B]" />
                    ))}
                  </div>
                </div>
              )}

              {/* Event Audit Trail */}
              <div>
                <h3 className="font-space font-bold text-slate-200 mb-4 tracking-wide uppercase">Audit Event Timeline</h3>
                {eventsLoading ? (
                  <p className="text-xs font-mono text-slate-500">Loading audit history...</p>
                ) : (
                  <div className="space-y-4 border-l-2 border-[#1E293B] pl-4">
                    {ticketEvents.map((ev) => (
                      <div key={ev.id} className="relative space-y-1">
                        <div className="absolute -left-[21px] top-1 w-2.5 h-2.5 bg-[#F59E0B] rounded-full" />
                        <p className="text-xs font-mono font-bold text-slate-200 uppercase">{ev.event_type}</p>
                        <p className="text-xs text-slate-400">
                          Actor: <strong className="text-slate-300">{ev.actor?.name || 'System Auto-Assign'}</strong>
                        </p>
                        <p className="text-[10px] font-mono text-slate-500">{new Date(ev.created_at).toLocaleString()}</p>
                      </div>
                    ))}
                  </div>
                )}
              </div>
            </div>
          </div>
        )}
      </div>
    </AdminDashboardLayout>
  );
}
