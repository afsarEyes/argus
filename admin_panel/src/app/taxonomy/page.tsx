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
            <h1 className="font-space font-bold text-2xl text-theme-main tracking-wide">
              DEFECT TAXONOMY MASTER
            </h1>
            <p className="text-xs text-theme-muted font-mono mt-1">
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
        <div className="bg-theme-card border border-theme p-4 rounded-xl">
          <div className="relative max-w-md">
            <Search size={18} className="absolute left-3.5 top-3 text-theme-muted" />
            <input
              type="text"
              value={search}
              onChange={(e) => setSearch(e.target.value)}
              placeholder="Search taxonomy by title or description..."
              className="w-full bg-theme-input border border-theme focus:border-[#F59E0B] rounded-lg pl-10 pr-4 py-2 text-sm text-theme-main placeholder-theme-muted focus:outline-none"
            />
          </div>
        </div>

        {/* Table */}
        <div className="bg-theme-card border border-theme rounded-xl overflow-hidden shadow-xl">
          <table className="w-full text-left text-sm text-theme-main">
            <thead className="bg-theme-table-header text-xs font-mono uppercase text-theme-muted border-b border-theme">
              <tr>
                <th className="px-6 py-3.5">Category Title</th>
                <th className="px-6 py-3.5">Description & Guidelines</th>
                <th className="px-6 py-3.5">Status</th>
                <th className="px-6 py-3.5 text-right">Actions</th>
              </tr>
            </thead>
            <tbody className="divide-y divide-theme">
              {loading ? (
                <tr>
                  <td colSpan={4} className="text-center py-8 text-xs font-mono text-theme-muted">
                    Loading taxonomy categories...
                  </td>
                </tr>
              ) : filteredCategories.length === 0 ? (
                <tr>
                  <td colSpan={4} className="text-center py-8 text-xs font-mono text-theme-muted">
                    No taxonomy records found.
                  </td>
                </tr>
              ) : (
                filteredCategories.map((c) => (
                  <tr key={c.id} className="hover:bg-theme-input/50">
                    <td className="px-6 py-4 font-semibold text-theme-main flex items-center gap-2">
                      <Tag size={16} className="text-[#F59E0B]" />
                      <span>{c.name}</span>
                    </td>
                    <td className="px-6 py-4 text-xs text-theme-muted max-w-md">
                      {c.description || 'No description guidelines specified.'}
                    </td>
                    <td className="px-6 py-4">
                      <span className={`inline-flex items-center gap-1 px-2.5 py-0.5 text-xs font-mono rounded-full ${c.active ? 'bg-emerald-500/10 text-emerald-500 border border-emerald-500/30' : 'bg-red-500/10 text-red-500 border border-red-500/30'}`}>
                        {c.active ? <Check size={12} /> : <X size={12} />}
                        <span>{c.active ? 'Active' : 'Disabled'}</span>
                      </span>
                    </td>
                    <td className="px-6 py-4 text-right">
                      <button onClick={() => openModal(c)} className="p-1.5 text-theme-muted hover:text-[#F59E0B]">
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
            <div className="bg-theme-card border border-theme w-full max-w-md rounded-xl p-6 space-y-4 shadow-2xl">
              <h2 className="font-space font-bold text-lg text-theme-main">
                {selectedCat ? 'Edit Defect Category' : 'Add New Defect Category'}
              </h2>

              <form onSubmit={handleSave} className="space-y-4">
                <div>
                  <label className="block text-xs font-mono text-theme-muted mb-1 uppercase">Category Title</label>
                  <input
                    type="text"
                    required
                    value={name}
                    onChange={(e) => setName(e.target.value)}
                    placeholder="e.g. Hydraulic Seepage"
                    className="w-full bg-theme-input border border-theme focus:border-[#F59E0B] rounded-lg px-3 py-2 text-sm text-theme-main focus:outline-none"
                  />
                </div>

                <div>
                  <label className="block text-xs font-mono text-theme-muted mb-1 uppercase">Description & Inspection Guidelines</label>
                  <textarea
                    rows={3}
                    value={description}
                    onChange={(e) => setDescription(e.target.value)}
                    placeholder="Describe failure symptoms and inspection criteria..."
                    className="w-full bg-theme-input border border-theme focus:border-[#F59E0B] rounded-lg px-3 py-2 text-sm text-theme-main focus:outline-none"
                  />
                </div>

                <div className="flex items-center gap-2 pt-2">
                  <input
                    type="checkbox"
                    id="activeCatToggle"
                    checked={active}
                    onChange={(e) => setActive(e.target.checked)}
                    className="rounded border-theme bg-theme-input text-[#F59E0B]"
                  />
                  <label htmlFor="activeCatToggle" className="text-sm text-theme-main">
                    Category Active & Available in Mobile App
                  </label>
                </div>

                <div className="flex justify-end gap-3 pt-4 border-t border-theme">
                  <button
                    type="button"
                    onClick={() => setIsModalOpen(false)}
                    className="px-4 py-2 bg-theme-input text-theme-main text-sm font-medium rounded-lg hover:bg-theme-main"
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
