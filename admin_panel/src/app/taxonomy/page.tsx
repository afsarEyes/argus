'use client';

import React, { useEffect, useState, useCallback } from 'react';
import AdminDashboardLayout from '@/components/layout/AdminDashboardLayout';
import { supabase } from '@/lib/supabase';
import { DefectCategory } from '@/types/database';
import { Tag, Plus, Edit2, Check, X, Search } from 'lucide-react';

export default function TaxonomyPage() {
  const [categories, setCategories] = useState<DefectCategory[]>([]);
  const [loading, setLoading] = useState(true);
  const [search, setSearch] = useState('');

  // Modal State
  const [isModalOpen, setIsModalOpen] = useState(false);
  const [selectedCat, setSelectedCat] = useState<DefectCategory | null>(null);

  // Form Fields
  const [name, setName] = useState('');
  const [description, setDescription] = useState('');
  const [active, setActive] = useState(true);
  const [saving, setSaving] = useState(false);

  const loadData = useCallback(async () => {
    try {
      const { data, error } = await supabase.from('defect_categories').select('*').order('name');
      if (error) throw error;
      setCategories((data as DefectCategory[]) || []);
    } catch (err) {
      console.error('Error loading taxonomy:', err);
    } finally {
      setLoading(false);
    }
  }, []);

  useEffect(() => {
    let isMounted = true;
    const fetchData = async () => {
      try {
        const { data, error } = await supabase.from('defect_categories').select('*').order('name');
        if (error) throw error;
        if (isMounted) {
          setCategories((data as DefectCategory[]) || []);
          setLoading(false);
        }
      } catch (err) {
        console.error('Error loading taxonomy:', err);
        if (isMounted) setLoading(false);
      }
    };

    fetchData();
    return () => {
      isMounted = false;
    };
  }, []);

  const openModal = (cat?: DefectCategory) => {
    setSelectedCat(cat || null);
    if (cat) {
      setName(cat.name);
      setDescription(cat.description || '');
      setActive(cat.active);
    } else {
      setName('');
      setDescription('');
      setActive(true);
    }
    setIsModalOpen(true);
  };

  const handleSave = async (e: React.FormEvent) => {
    e.preventDefault();
    setSaving(true);

    try {
      if (selectedCat) {
        await supabase
          .from('defect_categories')
          .update({ name, description, active, updated_at: new Date().toISOString() })
          .eq('id', selectedCat.id);
      } else {
        await supabase.from('defect_categories').insert({ name, description, active });
      }

      setIsModalOpen(false);
      loadData();
    } catch (err) {
      alert(`Save failed: ${err instanceof Error ? err.message : String(err)}`);
    } finally {
      setSaving(false);
    }
  };

  const filteredCategories = categories.filter(
    (c) =>
      c.name.toLowerCase().includes(search.toLowerCase()) ||
      (c.description && c.description.toLowerCase().includes(search.toLowerCase()))
  );

  return (
    <AdminDashboardLayout>
      <div className="space-y-6">
        {/* Header */}
        <div className="flex flex-col sm:flex-row justify-between sm:items-center gap-4">
          <div>
            <h1 className="font-space font-bold text-2xl text-slate-100 tracking-wide">
              DEFECT TAXONOMY MASTER
            </h1>
            <p className="text-xs text-slate-400 font-mono mt-1">
              Configure standardized defect categories and failure guidelines
            </p>
          </div>
          <button
            onClick={() => openModal()}
            className="flex items-center gap-2 bg-[#F59E0B] hover:bg-[#F59E0B]/90 text-slate-950 px-4 py-2.5 rounded-lg text-sm font-space font-bold uppercase transition-all shadow-lg shadow-[#F59E0B]/10"
          >
            <Plus size={18} />
            <span>Add Defect Category</span>
          </button>
        </div>

        {/* Filter Controls */}
        <div className="bg-[#131B2E] border border-[#1E293B] p-4 rounded-xl">
          <div className="relative max-w-md">
            <Search size={18} className="absolute left-3.5 top-3 text-slate-500" />
            <input
              type="text"
              value={search}
              onChange={(e) => setSearch(e.target.value)}
              placeholder="Search taxonomy by title or description..."
              className="w-full bg-[#0B0F19] border border-[#1E293B] focus:border-[#F59E0B] rounded-lg pl-10 pr-4 py-2 text-sm text-slate-100 placeholder-slate-600 focus:outline-none"
            />
          </div>
        </div>

        {/* Table */}
        <div className="bg-[#131B2E] border border-[#1E293B] rounded-xl overflow-hidden shadow-xl">
          <table className="w-full text-left text-sm text-slate-300">
            <thead className="bg-[#0B0F19] text-xs font-mono uppercase text-slate-400 border-b border-[#1E293B]">
              <tr>
                <th className="px-6 py-3.5">Category Title</th>
                <th className="px-6 py-3.5">Description & Guidelines</th>
                <th className="px-6 py-3.5">Status</th>
                <th className="px-6 py-3.5 text-right">Actions</th>
              </tr>
            </thead>
            <tbody className="divide-y divide-[#1E293B]">
              {loading ? (
                <tr>
                  <td colSpan={4} className="text-center py-8 text-xs font-mono text-slate-500">
                    Loading taxonomy categories...
                  </td>
                </tr>
              ) : filteredCategories.length === 0 ? (
                <tr>
                  <td colSpan={4} className="text-center py-8 text-xs font-mono text-slate-500">
                    No taxonomy records found.
                  </td>
                </tr>
              ) : (
                filteredCategories.map((c) => (
                  <tr key={c.id} className="hover:bg-[#1E293B]/40">
                    <td className="px-6 py-4 font-semibold text-slate-100 flex items-center gap-2">
                      <Tag size={16} className="text-[#F59E0B]" />
                      <span>{c.name}</span>
                    </td>
                    <td className="px-6 py-4 text-xs text-slate-400 max-w-md">
                      {c.description || 'No description guidelines specified.'}
                    </td>
                    <td className="px-6 py-4">
                      <span className={`inline-flex items-center gap-1 px-2.5 py-0.5 text-xs font-mono rounded-full ${c.active ? 'bg-emerald-950/40 text-emerald-400 border border-emerald-800/40' : 'bg-red-950/40 text-red-400 border border-red-800/40'}`}>
                        {c.active ? <Check size={12} /> : <X size={12} />}
                        <span>{c.active ? 'Active' : 'Disabled'}</span>
                      </span>
                    </td>
                    <td className="px-6 py-4 text-right">
                      <button onClick={() => openModal(c)} className="p-1.5 text-slate-400 hover:text-[#F59E0B]">
                        <Edit2 size={16} />
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
              <h2 className="font-space font-bold text-lg text-slate-100">
                {selectedCat ? 'Edit Defect Category' : 'Add New Defect Category'}
              </h2>

              <form onSubmit={handleSave} className="space-y-4">
                <div>
                  <label className="block text-xs font-mono text-slate-400 mb-1 uppercase">Category Title</label>
                  <input
                    type="text"
                    required
                    value={name}
                    onChange={(e) => setName(e.target.value)}
                    placeholder="e.g. Hydraulic Seepage"
                    className="w-full bg-[#0B0F19] border border-[#1E293B] focus:border-[#F59E0B] rounded-lg px-3 py-2 text-sm text-slate-100 focus:outline-none"
                  />
                </div>

                <div>
                  <label className="block text-xs font-mono text-slate-400 mb-1 uppercase">Description & Inspection Guidelines</label>
                  <textarea
                    rows={3}
                    value={description}
                    onChange={(e) => setDescription(e.target.value)}
                    placeholder="Describe failure symptoms and inspection criteria..."
                    className="w-full bg-[#0B0F19] border border-[#1E293B] focus:border-[#F59E0B] rounded-lg px-3 py-2 text-sm text-slate-100 focus:outline-none"
                  />
                </div>

                <div className="flex items-center gap-2 pt-2">
                  <input
                    type="checkbox"
                    id="activeCatToggle"
                    checked={active}
                    onChange={(e) => setActive(e.target.checked)}
                    className="rounded border-[#1E293B] bg-[#0B0F19] text-[#F59E0B]"
                  />
                  <label htmlFor="activeCatToggle" className="text-sm text-slate-200">
                    Category Active & Available in Mobile App
                  </label>
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
                    {saving ? 'Saving...' : 'Save Category'}
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
