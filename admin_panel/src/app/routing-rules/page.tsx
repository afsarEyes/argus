'use client';

import React, { useEffect, useState, useCallback } from 'react';
import AdminDashboardLayout from '@/components/layout/AdminDashboardLayout';
import { supabase } from '@/lib/supabase';
import { AssignmentRule, Line, DefectCategory, UserProfile } from '@/types/database';
import { GitMerge, Plus, Trash2, ArrowRight } from 'lucide-react';

export default function RoutingRulesPage() {
  const [rules, setRules] = useState<AssignmentRule[]>([]);
  const [lines, setLines] = useState<Line[]>([]);
  const [categories, setCategories] = useState<DefectCategory[]>([]);
  const [users, setUsers] = useState<UserProfile[]>([]);
  const [loading, setLoading] = useState(true);

  // Modal State
  const [isModalOpen, setIsModalOpen] = useState(false);
  const [lineId, setLineId] = useState('');
  const [categoryId, setCategoryId] = useState('');
  const [shift, setShift] = useState<'A' | 'B' | 'C' | ''>('A');
  const [assignedOwnerId, setAssignedOwnerId] = useState('');
  const [saving, setSaving] = useState(false);

  const loadData = useCallback(async () => {
    try {
      const [rulesRes, linesRes, catRes, usersRes] = await Promise.all([
        supabase.from('assignment_rules').select('*, line:lines(*), defect_category:defect_categories(*), assigned_owner:users(*)'),
        supabase.from('lines').select('*').order('name'),
        supabase.from('defect_categories').select('*').order('name'),
        supabase.from('users').select('*').in('role', ['line_owner', 'supervisor', 'quality_manager', 'admin']),
      ]);

      setRules((rulesRes.data as AssignmentRule[]) || []);
      setLines((linesRes.data as Line[]) || []);
      setCategories((catRes.data as DefectCategory[]) || []);
      setUsers((usersRes.data as UserProfile[]) || []);

      if (linesRes.data?.length) setLineId(linesRes.data[0].id);
      if (usersRes.data?.length) setAssignedOwnerId(usersRes.data[0].id);
    } catch (err) {
      console.error('Error loading routing rules:', err);
    } finally {
      setLoading(false);
    }
  }, []);

  useEffect(() => {
    let isMounted = true;

    const fetchData = async () => {
      try {
        const [rulesRes, linesRes, catRes, usersRes] = await Promise.all([
          supabase.from('assignment_rules').select('*, line:lines(*), defect_category:defect_categories(*), assigned_owner:users(*)'),
          supabase.from('lines').select('*').order('name'),
          supabase.from('defect_categories').select('*').order('name'),
          supabase.from('users').select('*').in('role', ['line_owner', 'supervisor', 'quality_manager', 'admin']),
        ]);

        if (isMounted) {
          setRules((rulesRes.data as AssignmentRule[]) || []);
          setLines((linesRes.data as Line[]) || []);
          setCategories((catRes.data as DefectCategory[]) || []);
          setUsers((usersRes.data as UserProfile[]) || []);

          if (linesRes.data?.length) setLineId(linesRes.data[0].id);
          if (usersRes.data?.length) setAssignedOwnerId(usersRes.data[0].id);
          setLoading(false);
        }
      } catch (err) {
        console.error('Error loading routing rules:', err);
        if (isMounted) setLoading(false);
      }
    };

    fetchData();

    return () => {
      isMounted = false;
    };
  }, []);

  const openModal = () => {
    setLineId(lines[0]?.id || '');
    setCategoryId('');
    setShift('A');
    setAssignedOwnerId(users[0]?.id || '');
    setIsModalOpen(true);
  };

  const handleCreate = async (e: React.FormEvent) => {
    e.preventDefault();
    setSaving(true);

    try {
      const { error } = await supabase.from('assignment_rules').insert({
        line_id: lineId,
        defect_category_id: categoryId || null,
        shift: shift || null,
        assigned_owner_id: assignedOwnerId,
      });

      if (error) throw error;
      setIsModalOpen(false);
      loadData();
    } catch (err) {
      alert(`Failed to create rule: ${err instanceof Error ? err.message : String(err)}`);
    } finally {
      setSaving(false);
    }
  };

  const handleDelete = async (id: string) => {
    if (!confirm('Are you sure you want to delete this routing rule?')) return;
    try {
      await supabase.from('assignment_rules').delete().eq('id', id);
      loadData();
    } catch (err) {
      alert('Failed to delete rule');
    }
  };

  return (
    <AdminDashboardLayout>
      <div className="space-y-6">
        {/* Header */}
        <div className="flex flex-col sm:flex-row justify-between sm:items-center gap-4">
          <div>
            <h1 className="font-space font-bold text-2xl text-slate-100 tracking-wide">
              AUTOMATED ROUTING ENGINE
            </h1>
            <p className="text-xs text-slate-400 font-mono mt-1">
              Configure automatic ticket resolution assignments based on line, defect category, and shift slots
            </p>
          </div>
          <button
            onClick={openModal}
            className="flex items-center gap-2 bg-[#F59E0B] hover:bg-[#F59E0B]/90 text-slate-950 px-4 py-2.5 rounded-lg text-sm font-space font-bold uppercase transition-all shadow-lg shadow-[#F59E0B]/10"
          >
            <Plus size={18} />
            <span>Add Routing Rule</span>
          </button>
        </div>

        {/* Rules Table */}
        <div className="bg-[#131B2E] border border-[#1E293B] rounded-xl overflow-hidden shadow-xl">
          <table className="w-full text-left text-sm text-slate-300">
            <thead className="bg-[#0B0F19] text-xs font-mono uppercase text-slate-400 border-b border-[#1E293B]">
              <tr>
                <th className="px-6 py-3.5">Trigger Condition (Line / Category / Shift)</th>
                <th className="px-6 py-3.5">Routing Target</th>
                <th className="px-6 py-3.5 text-right">Actions</th>
              </tr>
            </thead>
            <tbody className="divide-y divide-[#1E293B]">
              {loading ? (
                <tr>
                  <td colSpan={3} className="text-center py-8 text-xs font-mono text-slate-500">
                    Loading routing rules...
                  </td>
                </tr>
              ) : rules.length === 0 ? (
                <tr>
                  <td colSpan={3} className="text-center py-8 text-xs font-mono text-slate-500">
                    No automated routing rules configured.
                  </td>
                </tr>
              ) : (
                rules.map((r) => (
                  <tr key={r.id} className="hover:bg-[#1E293B]/40">
                    <td className="px-6 py-4">
                      <div className="flex items-center gap-3">
                        <div className="p-2 bg-[#F59E0B]/10 rounded border border-[#F59E0B]/30 text-[#F59E0B]">
                          <GitMerge size={16} />
                        </div>
                        <div>
                          <p className="font-semibold text-slate-100">{r.line?.name || 'Any Line'}</p>
                          <div className="flex items-center gap-2 mt-1">
                            <span className="text-xs font-mono text-slate-400">
                              Category: <strong className="text-slate-200">{r.defect_category?.name || 'Wildcard (Any Defect)'}</strong>
                            </span>
                            <span className="text-xs font-mono px-1.5 py-0.5 bg-[#0B0F19] rounded border border-slate-700 text-slate-400">
                              Shift: {r.shift || 'All Shifts'}
                            </span>
                          </div>
                        </div>
                      </div>
                    </td>
                    <td className="px-6 py-4">
                      <div className="flex items-center gap-2">
                        <ArrowRight size={16} className="text-[#F59E0B]" />
                        <span className="font-semibold text-slate-100">{r.assigned_owner?.name || 'Owner User'}</span>
                        <span className="text-xs font-mono text-slate-400">({r.assigned_owner?.email})</span>
                      </div>
                    </td>
                    <td className="px-6 py-4 text-right">
                      <button
                        onClick={() => handleDelete(r.id)}
                        className="p-1.5 text-slate-400 hover:text-red-400 hover:bg-red-950/30 rounded transition-colors"
                      >
                        <Trash2 size={16} />
                      </button>
                    </td>
                  </tr>
                ))
              )}
            </tbody>
          </table>
        </div>

        {/* Modal */}
        {isModalOpen && (
          <div className="fixed inset-0 z-50 bg-black/70 backdrop-blur-sm flex items-center justify-center p-4">
            <div className="bg-[#131B2E] border border-[#1E293B] w-full max-w-md rounded-xl p-6 space-y-4">
              <h2 className="font-space font-bold text-lg text-slate-100">Create Automatic Routing Rule</h2>

              <form onSubmit={handleCreate} className="space-y-4">
                <div>
                  <label className="block text-xs font-mono text-slate-400 mb-1 uppercase">Target Line</label>
                  <select
                    value={lineId}
                    onChange={(e) => setLineId(e.target.value)}
                    className="w-full bg-[#0B0F19] border border-[#1E293B] focus:border-[#F59E0B] rounded-lg px-3 py-2 text-sm text-slate-100 focus:outline-none"
                  >
                    {lines.map((l) => (
                      <option key={l.id} value={l.id}>
                        {l.name}
                      </option>
                    ))}
                  </select>
                </div>

                <div>
                  <label className="block text-xs font-mono text-slate-400 mb-1 uppercase">Defect Category Filter</label>
                  <select
                    value={categoryId}
                    onChange={(e) => setCategoryId(e.target.value)}
                    className="w-full bg-[#0B0F19] border border-[#1E293B] focus:border-[#F59E0B] rounded-lg px-3 py-2 text-sm text-slate-100 focus:outline-none"
                  >
                    <option value="">Wildcard (Match Any Category on Line)</option>
                    {categories.map((c) => (
                      <option key={c.id} value={c.id}>
                        {c.name}
                      </option>
                    ))}
                  </select>
                </div>

                <div>
                  <label className="block text-xs font-mono text-slate-400 mb-1 uppercase">Shift Filter</label>
                  <select
                    value={shift}
                    onChange={(e) => setShift(e.target.value as 'A' | 'B' | 'C' | '')}
                    className="w-full bg-[#0B0F19] border border-[#1E293B] focus:border-[#F59E0B] rounded-lg px-3 py-2 text-sm text-slate-100 focus:outline-none"
                  >
                    <option value="">Wildcard (All Shifts)</option>
                    <option value="A">Shift A</option>
                    <option value="B">Shift B</option>
                    <option value="C">Shift C</option>
                  </select>
                </div>

                <div>
                  <label className="block text-xs font-mono text-slate-400 mb-1 uppercase">Auto-Assign To Lead Owner</label>
                  <select
                    value={assignedOwnerId}
                    onChange={(e) => setAssignedOwnerId(e.target.value)}
                    className="w-full bg-[#0B0F19] border border-[#1E293B] focus:border-[#F59E0B] rounded-lg px-3 py-2 text-sm text-slate-100 focus:outline-none"
                  >
                    {users.map((u) => (
                      <option key={u.id} value={u.id}>
                        {u.name} ({u.role}) - {u.email}
                      </option>
                    ))}
                  </select>
                </div>

                <div className="flex justify-end gap-3 pt-4 border-t border-[#1E293B]">
                  <button
                    type="button"
                    onClick={() => setIsModalOpen(false)}
                    className="px-4 py-2 bg-[#1E293B] text-slate-300 text-sm font-medium rounded-lg"
                  >
                    Cancel
                  </button>
                  <button
                    type="submit"
                    disabled={saving}
                    className="px-4 py-2 bg-[#F59E0B] text-slate-950 text-sm font-space font-bold rounded-lg"
                  >
                    {saving ? 'Creating...' : 'Create Rule'}
                  </button>
                </div>
              </form>
            </div>
          </div>
        )}
      </div>
    </AdminDashboardLayout>
  );
}
