'use client';

import React, { useEffect, useState, useRef } from 'react';
import AdminDashboardLayout from '@/components/layout/AdminDashboardLayout';
import { supabase } from '@/lib/supabase';
import { Ticket, Line } from '@/types/database';
import { FileSpreadsheet, Calendar, Filter, Printer } from 'lucide-react';
import Papa from 'papaparse';
import jsPDF from 'jspdf';
import html2canvas from 'html2canvas';

export default function ReportsExportPage() {
  const [tickets, setTickets] = useState<Ticket[]>([]);
  const [lines, setLines] = useState<Line[]>([]);
  const [loading, setLoading] = useState(true);

  // Filters
  const [datePreset, setDatePreset] = useState<'all' | 'today' | 'week' | 'month'>('all');
  const [selectedLineId, setSelectedLineId] = useState('ALL');
  const [selectedSeverity, setSelectedSeverity] = useState('ALL');

  const reportRef = useRef<HTMLDivElement>(null);

  useEffect(() => {
    let isMounted = true;

    const fetchData = async () => {
      try {
        const [ticketsRes, linesRes] = await Promise.all([
          supabase
            .from('tickets')
            .select('*, line:lines(*), station:stations(*), defect_category:defect_categories(*), reporter:users!tickets_reporter_id_fkey(*), assigned_owner:users!tickets_assigned_owner_id_fkey(*)')
            .order('created_at', { ascending: false }),
          supabase.from('lines').select('*'),
        ]);

        if (isMounted) {
          setTickets((ticketsRes.data as Ticket[]) || []);
          setLines((linesRes.data as Line[]) || []);
          setLoading(false);
        }
      } catch (err) {
        console.error('Error loading report data:', err);
        if (isMounted) setLoading(false);
      }
    };

    fetchData();

    return () => {
      isMounted = false;
    };
  }, []);

  const filteredTickets = tickets.filter((t) => {
    const ticketDate = new Date(t.created_at);
    const now = new Date();

    let matchesDate = true;
    if (datePreset === 'today') {
      matchesDate = ticketDate.toDateString() === now.toDateString();
    } else if (datePreset === 'week') {
      const oneWeekAgo = new Date(now.getTime() - 7 * 24 * 60 * 60 * 1000);
      matchesDate = ticketDate >= oneWeekAgo;
    } else if (datePreset === 'month') {
      const oneMonthAgo = new Date(now.getTime() - 30 * 24 * 60 * 60 * 1000);
      matchesDate = ticketDate >= oneMonthAgo;
    }

    const matchesLine = selectedLineId === 'ALL' || t.line_id === selectedLineId;
    const matchesSeverity = selectedSeverity === 'ALL' || t.severity === selectedSeverity;

    return matchesDate && matchesLine && matchesSeverity;
  });

  // Export CSV Function
  const exportToCSV = () => {
    const dataToExport = filteredTickets.map((t) => ({
      Ticket_ID: t.human_readable_id || t.id,
      Date_Logged: new Date(t.created_at).toLocaleString(),
      Line: t.line?.name || t.line_id,
      Station: t.station?.name || t.station_id,
      Defect_Category: t.defect_category?.name || t.defect_category_id,
      Severity: t.severity,
      Status: t.status,
      Reporter: t.reporter?.name || t.reporter_id,
      Assigned_Lead: t.assigned_owner?.name || 'Unassigned',
      Description: t.description,
    }));

    const csv = Papa.unparse(dataToExport);
    const blob = new Blob([csv], { type: 'text/csv;charset=utf-8;' });
    const url = URL.createObjectURL(blob);
    const link = document.createElement('a');
    link.href = url;
    link.setAttribute('download', `Argus_QC_Report_${new Date().toISOString().split('T')[0]}.csv`);
    document.body.appendChild(link);
    link.click();
    document.body.removeChild(link);
  };

  // Export PDF Executive Summary Function
  const exportToPDF = async () => {
    if (!reportRef.current) return;
    const canvas = await html2canvas(reportRef.current, { scale: 2 });
    const imgData = canvas.toDataURL('image/png');

    const pdf = new jsPDF('p', 'mm', 'a4');
    const imgWidth = 210;
    const pageHeight = 295;
    const imgHeight = (canvas.height * imgWidth) / canvas.width;
    let heightLeft = imgHeight;
    let position = 0;

    pdf.addImage(imgData, 'PNG', 0, position, imgWidth, imgHeight);
    heightLeft -= pageHeight;

    while (heightLeft >= 0) {
      position = heightLeft - imgHeight;
      pdf.addPage();
      pdf.addImage(imgData, 'PNG', 0, position, imgWidth, imgHeight);
      heightLeft -= pageHeight;
    }

    pdf.save(`Argus_QC_Audit_Summary_${new Date().toISOString().split('T')[0]}.pdf`);
  };

  return (
    <AdminDashboardLayout>
      <div className="space-y-6">
        {/* Header */}
        <div className="flex flex-col sm:flex-row justify-between sm:items-center gap-4">
          <div>
            <h1 className="font-space font-bold text-2xl text-slate-100 tracking-wide">
              REPORTS & AUDIT EXPORT CENTER
            </h1>
            <p className="text-xs text-slate-400 font-mono mt-1">
              Generate CSV logs and printable executive PDF summaries for shift audits and ISO compliance
            </p>
          </div>
          <div className="flex items-center gap-3">
            <button
              onClick={exportToCSV}
              className="flex items-center gap-2 bg-[#1E293B] hover:bg-slate-700 text-slate-100 border border-slate-700 px-4 py-2.5 rounded-lg text-sm font-mono transition-all"
            >
              <FileSpreadsheet size={16} className="text-emerald-400" />
              <span>Export CSV</span>
            </button>
            <button
              onClick={exportToPDF}
              className="flex items-center gap-2 bg-[#F59E0B] hover:bg-[#F59E0B]/90 text-slate-950 px-4 py-2.5 rounded-lg text-sm font-space font-bold uppercase transition-all shadow-lg shadow-[#F59E0B]/10"
            >
              <Printer size={16} />
              <span>Export PDF Summary</span>
            </button>
          </div>
        </div>

        {/* Filter Controls */}
        <div className="bg-[#131B2E] border border-[#1E293B] p-4 rounded-xl flex flex-wrap gap-4 items-center">
          <div className="flex items-center gap-2">
            <Calendar size={16} className="text-[#F59E0B]" />
            <span className="text-xs font-mono text-slate-400">TIMEFRAME:</span>
            <select
              value={datePreset}
              onChange={(e) => setDatePreset(e.target.value as 'all' | 'today' | 'week' | 'month')}
              className="bg-[#0B0F19] border border-[#1E293B] rounded-lg px-3 py-1.5 text-xs text-slate-200"
            >
              <option value="all">All Available History</option>
              <option value="today">Today Only</option>
              <option value="week">Past 7 Days</option>
              <option value="month">Past 30 Days</option>
            </select>
          </div>

          <div className="flex items-center gap-2">
            <Filter size={16} className="text-[#F59E0B]" />
            <span className="text-xs font-mono text-slate-400">LINE:</span>
            <select
              value={selectedLineId}
              onChange={(e) => setSelectedLineId(e.target.value)}
              className="bg-[#0B0F19] border border-[#1E293B] rounded-lg px-3 py-1.5 text-xs text-slate-200"
            >
              <option value="ALL">All Production Lines</option>
              {lines.map((l) => (
                <option key={l.id} value={l.id}>
                  {l.name}
                </option>
              ))}
            </select>
          </div>

          <div className="flex items-center gap-2">
            <span className="text-xs font-mono text-slate-400">SEVERITY:</span>
            <select
              value={selectedSeverity}
              onChange={(e) => setSelectedSeverity(e.target.value)}
              className="bg-[#0B0F19] border border-[#1E293B] rounded-lg px-3 py-1.5 text-xs text-slate-200"
            >
              <option value="ALL">All Severities</option>
              <option value="critical">Critical Only</option>
              <option value="major">Major Only</option>
              <option value="minor">Minor Only</option>
            </select>
          </div>
        </div>

        {/* Printable Summary Report Container */}
        <div ref={reportRef} className="bg-[#131B2E] border border-[#1E293B] p-6 rounded-xl space-y-6">
          <div className="border-b border-[#1E293B] pb-4 flex justify-between items-end">
            <div>
              <h2 className="font-space font-bold text-xl text-slate-100 tracking-wide">
                ARGUS QC EXECUTIVE AUDIT REPORT
              </h2>
              <p className="text-xs text-[#F59E0B] font-mono">Generated: {new Date().toLocaleString()}</p>
            </div>
            <span className="text-xs font-mono px-3 py-1 bg-[#0B0F19] border border-slate-700 rounded text-slate-300">
              Filtered Records: {filteredTickets.length}
            </span>
          </div>

          {/* Report Data Preview Table */}
          <table className="w-full text-left text-xs font-mono text-slate-300">
            <thead className="bg-[#0B0F19] uppercase text-slate-400 border-b border-[#1E293B]">
              <tr>
                <th className="p-3">ID</th>
                <th className="p-3">Date</th>
                <th className="p-3">Line</th>
                <th className="p-3">Category</th>
                <th className="p-3">Severity</th>
                <th className="p-3">Status</th>
              </tr>
            </thead>
            <tbody className="divide-y divide-[#1E293B]">
              {loading ? (
                <tr>
                  <td colSpan={6} className="text-center py-6 text-slate-500">
                    Preparing report contents...
                  </td>
                </tr>
              ) : filteredTickets.length === 0 ? (
                <tr>
                  <td colSpan={6} className="text-center py-6 text-slate-500">
                    No tickets match criteria.
                  </td>
                </tr>
              ) : (
                filteredTickets.map((t) => (
                  <tr key={t.id} className="hover:bg-[#1E293B]/40">
                    <td className="p-3 font-bold text-slate-100">{t.human_readable_id || t.id.substring(0, 8)}</td>
                    <td className="p-3 text-slate-400">{new Date(t.created_at).toLocaleDateString()}</td>
                    <td className="p-3">{t.line?.name || 'Line'}</td>
                    <td className="p-3 text-slate-200">{t.defect_category?.name || 'Category'}</td>
                    <td className="p-3 uppercase text-[#F59E0B]">{t.severity}</td>
                    <td className="p-3 uppercase">{t.status}</td>
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
