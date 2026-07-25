'use client';

import React, { useEffect, useState } from 'react';
import AdminDashboardLayout from '@/components/layout/AdminDashboardLayout';
import { supabase } from '@/lib/supabase';
import { Ticket, TicketEvent } from '@/types/database';
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
            <h1 className="font-space font-bold text-2xl text-theme-main tracking-wide">
              LIVE TICKET AUDITOR
            </h1>
            <p className="text-xs text-theme-muted font-mono mt-1">
              Real-time quality control issue stream and full event audit trail
            </p>
          </div>
        </div>

        {/* Filter Controls */}
        <div className="bg-theme-card border border-theme p-4 rounded-xl flex flex-col md:flex-row gap-4 justify-between">
          <div className="relative flex-1">
            <Search size={18} className="absolute left-3.5 top-3 text-theme-muted" />
            <input
              type="text"
              value={search}
              onChange={(e) => setSearch(e.target.value)}
              placeholder="Search by ticket ID (ARG-2026-...) or description..."
              className="w-full bg-theme-input border border-theme focus:border-[#F59E0B] rounded-lg pl-10 pr-4 py-2 text-sm text-theme-main placeholder-theme-muted focus:outline-none"
            />
          </div>
          <div className="flex items-center gap-2">
            <span className="text-xs font-mono text-theme-muted">STATUS:</span>
            <select
              value={statusFilter}
              onChange={(e) => setStatusFilter(e.target.value)}
              className="bg-theme-input border border-theme focus:border-[#F59E0B] rounded-lg px-3 py-2 text-sm text-theme-main focus:outline-none"
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
        <div className="bg-theme-card border border-theme rounded-xl overflow-hidden shadow-xl">
          <table className="w-full text-left text-sm text-theme-main">
            <thead className="bg-theme-table-header text-xs font-mono uppercase text-theme-muted border-b border-theme">
              <tr>
                <th className="px-6 py-3.5">Ticket Reference</th>
                <th className="px-6 py-3.5">Defect & Line</th>
                <th className="px-6 py-3.5">Severity</th>
                <th className="px-6 py-3.5">Assigned Lead</th>
                <th className="px-6 py-3.5">Status</th>
                <th className="px-6 py-3.5 text-right">View Audit</th>
              </tr>
            </thead>
            <tbody className="divide-y divide-theme">
              {loading ? (
                <tr>
                  <td colSpan={6} className="text-center py-8 text-xs font-mono text-theme-muted">
                    Loading live tickets...
                  </td>
                </tr>
              ) : filteredTickets.length === 0 ? (
                <tr>
                  <td colSpan={6} className="text-center py-8 text-xs font-mono text-theme-muted">
                    No tickets found matching current filters.
                  </td>
                </tr>
              ) : (
                filteredTickets.map((t) => (
                  <tr key={t.id} className="hover:bg-theme-input/50">
                    <td className="px-6 py-4 font-mono font-bold text-theme-main">
                      {t.human_readable_id || t.id.substring(0, 8)}
                      <p className="text-[10px] font-normal text-theme-muted">{new Date(t.created_at).toLocaleString()}</p>
                    </td>
                    <td className="px-6 py-4">
                      <p className="font-semibold text-theme-main">{t.defect_category?.name || 'Defect Category'}</p>
                      <p className="text-xs font-mono text-theme-muted">{t.line?.name} {'//'} {t.station?.name}</p>
                    </td>
                    <td className="px-6 py-4">
                      <span
                        className={`inline-block px-2 py-0.5 text-xs font-mono font-bold uppercase rounded ${
                          t.severity === 'critical'
                            ? 'bg-red-500/10 border border-red-500/30 text-red-500'
                            : t.severity === 'major'
                            ? 'bg-[#F59E0B]/10 border border-[#F59E0B]/30 text-[#F59E0B]'
                            : 'bg-blue-500/10 border border-blue-500/30 text-blue-500'
                        }`}
                      >
                        {t.severity}
                      </span>
                    </td>
                    <td className="px-6 py-4 text-xs font-mono">
                      {t.assigned_owner ? t.assigned_owner.name : <span className="text-theme-muted">Unassigned</span>}
                    </td>
                    <td className="px-6 py-4">
                      <span
                        className={`inline-block px-2.5 py-1 text-xs font-mono font-bold uppercase rounded ${
                          t.status === 'open'
                            ? 'bg-blue-500/10 text-blue-500 border border-blue-500/30'
                            : t.status === 'assigned'
                            ? 'bg-purple-500/10 text-purple-500 border border-purple-500/30'
                            : t.status === 'in_progress'
                            ? 'bg-[#F59E0B]/10 text-[#F59E0B] border border-[#F59E0B]/30'
                            : 'bg-emerald-500/10 text-emerald-500 border border-emerald-500/30'
                        }`}
                      >
                        {t.status.replace('_', ' ')}
                      </span>
                    </td>
                    <td className="px-6 py-4 text-right">
                      <button onClick={() => openDrawer(t)} className="p-1.5 text-theme-muted hover:text-[#F59E0B]">
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
            <div className="bg-theme-card border-l border-theme w-full max-w-lg h-full overflow-y-auto p-6 space-y-6 shadow-2xl">
              <div className="flex items-center justify-between border-b border-theme pb-4">
                <div>
                  <h2 className="font-mono font-bold text-lg text-theme-main">
                    {selectedTicket.human_readable_id || selectedTicket.id}
                  </h2>
                  <p className="text-xs text-[#F59E0B] font-mono">{selectedTicket.defect_category?.name}</p>
                </div>
                <button onClick={() => setSelectedTicket(null)} className="text-theme-muted hover:text-theme-main">
                  <X size={20} />
                </button>
              </div>

              <div className="space-y-3 bg-theme-input p-4 rounded-lg border border-theme">
                <p className="text-xs font-mono text-theme-muted uppercase">Issue Description</p>
                <p className="text-sm text-theme-main">{selectedTicket.description}</p>
              </div>

              {selectedTicket.photo_paths && selectedTicket.photo_paths.length > 0 && (
                <div>
                  <p className="text-xs font-mono text-theme-muted uppercase mb-2">Attached Defect Photos</p>
                  <div className="flex gap-2 overflow-x-auto">
                    {selectedTicket.photo_paths.map((p, idx) => (
                      <img key={idx} src={p} alt="Defect" className="w-24 h-24 object-cover rounded border border-theme" />
                    ))}
                  </div>
                </div>
              )}

              {/* Event Audit Trail */}
              <div>
                <h3 className="font-space font-bold text-theme-main mb-4 tracking-wide uppercase">Audit Event Timeline</h3>
                {eventsLoading ? (
                  <p className="text-xs font-mono text-theme-muted">Loading audit history...</p>
                ) : (
                  <div className="space-y-4 border-l-2 border-theme pl-4">
                    {ticketEvents.map((ev) => (
                      <div key={ev.id} className="relative space-y-1">
                        <div className="absolute -left-[21px] top-1 w-2.5 h-2.5 bg-[#F59E0B] rounded-full" />
                        <p className="text-xs font-mono font-bold text-theme-main uppercase">{ev.event_type}</p>
                        <p className="text-xs text-theme-muted">
                          Actor: <strong className="text-theme-main">{ev.actor?.name || 'System Auto-Assign'}</strong>
                        </p>
                        <p className="text-[10px] font-mono text-theme-muted">{new Date(ev.created_at).toLocaleString()}</p>
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
