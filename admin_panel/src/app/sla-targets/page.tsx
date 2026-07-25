'use client';

import React, { useEffect, useState, useCallback } from 'react';
import AdminDashboardLayout from '@/components/layout/AdminDashboardLayout';
import { supabase } from '@/lib/supabase';
import { SlaTarget } from '@/types/database';
import { Clock, Save, ShieldAlert } from 'lucide-react';

export default function SlaTargetsPage() {
  const [criticalTime, setCriticalTime] = useState(30);
  const [majorTime, setMajorTime] = useState(60);
  const [minorTime, setMinorTime] = useState(120);
  const [saving, setSaving] = useState(false);

  const loadData = useCallback(async () => {
    try {
      const { data, error } = await supabase.from('sla_targets').select('*');
      if (error) throw error;
      const list = (data as SlaTarget[]) || [];

      const crit = list.find((t) => t.severity === 'critical');
      const maj = list.find((t) => t.severity === 'major');
      const min = list.find((t) => t.severity === 'minor');

      if (crit) setCriticalTime(crit.resolution_time_minutes);
      if (maj) setMajorTime(maj.resolution_time_minutes);
      if (min) setMinorTime(min.resolution_time_minutes);
    } catch (err) {
      console.error('Error loading SLA targets:', err);
    }
  }, []);

  useEffect(() => {
    let isMounted = true;

    const fetchData = async () => {
      try {
        const { data, error } = await supabase.from('sla_targets').select('*');
        if (error) throw error;
        const list = (data as SlaTarget[]) || [];

        if (isMounted) {
          const crit = list.find((t) => t.severity === 'critical');
          const maj = list.find((t) => t.severity === 'major');
          const min = list.find((t) => t.severity === 'minor');

          if (crit) setCriticalTime(crit.resolution_time_minutes);
          if (maj) setMajorTime(maj.resolution_time_minutes);
          if (min) setMinorTime(min.resolution_time_minutes);
        }
      } catch (err) {
        console.error('Error loading SLA targets:', err);
      }
    };

    fetchData();

    return () => {
      isMounted = false;
    };
  }, []);

  const handleSave = async (e: React.FormEvent) => {
    e.preventDefault();
    setSaving(true);

    try {
      await Promise.all([
        supabase.from('sla_targets').upsert({ severity: 'critical', resolution_time_minutes: criticalTime }, { onConflict: 'severity' }),
        supabase.from('sla_targets').upsert({ severity: 'major', resolution_time_minutes: majorTime }, { onConflict: 'severity' }),
        supabase.from('sla_targets').upsert({ severity: 'minor', resolution_time_minutes: minorTime }, { onConflict: 'severity' }),
      ]);

      alert('SLA Resolution Targets updated successfully!');
      loadData();
    } catch (err) {
      alert(`Save failed: ${err instanceof Error ? err.message : String(err)}`);
    } finally {
      setSaving(false);
    }
  };

  return (
    <AdminDashboardLayout>
      <div className="space-y-6 max-w-4xl">
        {/* Header */}
        <div>
          <h1 className="font-space font-bold text-2xl text-theme-main tracking-wide">
            SLA TARGET MANAGER
          </h1>
          <p className="text-xs text-theme-muted font-mono mt-1">
            Configure target resolution times (in minutes) for each defect severity level
          </p>
        </div>

        {/* SLA Form */}
        <form onSubmit={handleSave} className="space-y-4">
          {/* Critical */}
          <div className="bg-theme-card border border-red-500/30 p-6 rounded-xl flex items-center justify-between shadow-sm">
            <div className="flex items-center gap-4">
              <div className="p-3 bg-red-500/10 border border-red-500/30 rounded-xl text-red-500">
                <ShieldAlert size={24} />
              </div>
              <div>
                <h3 className="font-space font-bold text-lg text-theme-main uppercase">Critical Severity</h3>
                <p className="text-xs text-theme-muted font-mono">Immediate line shutdown or severe safety defect</p>
              </div>
            </div>
            <div className="flex items-center gap-3">
              <input
                type="number"
                min={5}
                max={480}
                value={criticalTime}
                onChange={(e) => setCriticalTime(Number(e.target.value))}
                className="w-28 bg-theme-input border border-theme focus:border-red-500 rounded-lg px-3 py-2 text-sm font-mono text-right text-theme-main font-bold"
              />
              <span className="text-xs font-mono text-theme-muted">minutes</span>
            </div>
          </div>

          {/* Major */}
          <div className="bg-theme-card border border-[#F59E0B]/30 p-6 rounded-xl flex items-center justify-between shadow-sm">
            <div className="flex items-center gap-4">
              <div className="p-3 bg-[#F59E0B]/10 border border-[#F59E0B]/30 rounded-xl text-[#F59E0B]">
                <Clock size={24} />
              </div>
              <div>
                <h3 className="font-space font-bold text-lg text-theme-main uppercase">Major Severity</h3>
                <p className="text-xs text-theme-muted font-mono">High defect rate or component mismatch</p>
              </div>
            </div>
            <div className="flex items-center gap-3">
              <input
                type="number"
                min={5}
                max={480}
                value={majorTime}
                onChange={(e) => setMajorTime(Number(e.target.value))}
                className="w-28 bg-theme-input border border-theme focus:border-[#F59E0B] rounded-lg px-3 py-2 text-sm font-mono text-right text-theme-main font-bold"
              />
              <span className="text-xs font-mono text-theme-muted">minutes</span>
            </div>
          </div>

          {/* Minor */}
          <div className="bg-theme-card border border-blue-500/30 p-6 rounded-xl flex items-center justify-between shadow-sm">
            <div className="flex items-center gap-4">
              <div className="p-3 bg-blue-500/10 border border-blue-500/30 rounded-xl text-blue-500">
                <Clock size={24} />
              </div>
              <div>
                <h3 className="font-space font-bold text-lg text-theme-main uppercase">Minor Severity</h3>
                <p className="text-xs text-theme-muted font-mono">Cosmetic scratch or minor label flaw</p>
              </div>
            </div>
            <div className="flex items-center gap-3">
              <input
                type="number"
                min={5}
                max={480}
                value={minorTime}
                onChange={(e) => setMinorTime(Number(e.target.value))}
                className="w-28 bg-theme-input border border-theme focus:border-blue-500 rounded-lg px-3 py-2 text-sm font-mono text-right text-theme-main font-bold"
              />
              <span className="text-xs font-mono text-theme-muted">minutes</span>
            </div>
          </div>

          <div className="pt-4 flex justify-end">
            <button
              type="submit"
              disabled={saving}
              className="flex items-center gap-2 bg-[#F59E0B] hover:bg-[#F59E0B]/90 text-slate-950 px-6 py-3 rounded-lg text-sm font-space font-bold uppercase transition-all shadow-lg shadow-[#F59E0B]/10"
            >
              <Save size={18} />
              <span>{saving ? 'Updating SLA Targets...' : 'Save SLA Targets'}</span>
            </button>
          </div>
        </form>
      </div>
    </AdminDashboardLayout>
  );
}
