'use client';

import React, { useEffect, useState, useCallback } from 'react';
import AdminDashboardLayout from '@/components/layout/AdminDashboardLayout';
import { supabase } from '@/lib/supabase';
import { Plant, Line, Station } from '@/types/database';
import { Factory, Plus, Edit2, Check, X, Layers, Monitor } from 'lucide-react';

export default function LayoutMasterPage() {
  const [activeTab, setActiveTab] = useState<'plants' | 'lines' | 'stations'>('lines');
  const [plants, setPlants] = useState<Plant[]>([]);
  const [lines, setLines] = useState<Line[]>([]);
  const [stations, setStations] = useState<Station[]>([]);
  const [loading, setLoading] = useState(true);

  // Modal State
  const [isModalOpen, setIsModalOpen] = useState(false);
  const [editItem, setEditItem] = useState<Plant | Line | Station | null>(null);

  // Form Fields
  const [name, setName] = useState('');
  const [location, setLocation] = useState('');
  const [plantId, setPlantId] = useState('');
  const [lineId, setLineId] = useState('');
  const [active, setActive] = useState(true);
  const [saving, setSaving] = useState(false);

  const loadData = useCallback(async () => {
    try {
      const [plantsRes, linesRes, stationsRes] = await Promise.all([
        supabase.from('plants').select('*').order('name'),
        supabase.from('lines').select('*, plant:plants(*)').order('name'),
        supabase.from('stations').select('*, line:lines(*)').order('name'),
      ]);

      setPlants((plantsRes.data as Plant[]) || []);
      setLines((linesRes.data as Line[]) || []);
      setStations((stationsRes.data as Station[]) || []);
    } catch (err) {
      console.error('Error loading layout master:', err);
    } finally {
      setLoading(false);
    }
  }, []);

  useEffect(() => {
    let isMounted = true;
    const fetchData = async () => {
      try {
        const [plantsRes, linesRes, stationsRes] = await Promise.all([
          supabase.from('plants').select('*').order('name'),
          supabase.from('lines').select('*, plant:plants(*)').order('name'),
          supabase.from('stations').select('*, line:lines(*)').order('name'),
        ]);

        if (isMounted) {
          setPlants((plantsRes.data as Plant[]) || []);
          setLines((linesRes.data as Line[]) || []);
          setStations((stationsRes.data as Station[]) || []);
          setLoading(false);
        }
      } catch (err) {
        console.error('Error loading layout master:', err);
        if (isMounted) setLoading(false);
      }
    };

    fetchData();
    return () => {
      isMounted = false;
    };
  }, []);

  const openModal = (item?: Plant | Line | Station) => {
    setEditItem(item || null);
    if (item) {
      setName(item.name);
      setActive(item.active);
      if ('location' in item) setLocation(item.location);
      if ('plant_id' in item) setPlantId(item.plant_id);
      if ('line_id' in item) setLineId(item.line_id);
    } else {
      setName('');
      setLocation('');
      setPlantId(plants[0]?.id || '');
      setLineId(lines[0]?.id || '');
      setActive(true);
    }
    setIsModalOpen(true);
  };

  const handleSave = async (e: React.FormEvent) => {
    e.preventDefault();
    setSaving(true);

    try {
      if (activeTab === 'plants') {
        if (editItem) {
          await supabase.from('plants').update({ name, location, active }).eq('id', editItem.id);
        } else {
          await supabase.from('plants').insert({ name, location, active });
        }
      } else if (activeTab === 'lines') {
        if (editItem) {
          await supabase.from('lines').update({ name, plant_id: plantId, active }).eq('id', editItem.id);
        } else {
          await supabase.from('lines').insert({ name, plant_id: plantId, active });
        }
      } else if (activeTab === 'stations') {
        if (editItem) {
          await supabase.from('stations').update({ name, line_id: lineId, active }).eq('id', editItem.id);
        } else {
          await supabase.from('stations').insert({ name, line_id: lineId, active });
        }
      }

      setIsModalOpen(false);
      loadData();
    } catch (err) {
      alert(`Save failed: ${err instanceof Error ? err.message : String(err)}`);
    } finally {
      setSaving(false);
    }
  };

  return (
    <AdminDashboardLayout>
      <div className="space-y-6">
        {/* Header */}
        <div className="flex flex-col sm:flex-row justify-between sm:items-center gap-4">
          <div>
            <h1 className="font-space font-bold text-2xl text-slate-100 tracking-wide">
              PLANT LAYOUT MASTER
            </h1>
            <p className="text-xs text-slate-400 font-mono mt-1">
              Configure manufacturing facilities, production lines, and workstation nodes
            </p>
          </div>
          <button
            onClick={() => openModal()}
            className="flex items-center gap-2 bg-[#F59E0B] hover:bg-[#F59E0B]/90 text-slate-950 px-4 py-2.5 rounded-lg text-sm font-space font-bold uppercase transition-all shadow-lg shadow-[#F59E0B]/10"
          >
            <Plus size={18} />
            <span>Add New {activeTab.slice(0, -1)}</span>
          </button>
        </div>

        {/* Navigation Tabs */}
        <div className="flex border-b border-[#1E293B] gap-4">
          <button
            onClick={() => setActiveTab('lines')}
            className={`pb-3 px-2 font-space text-sm font-bold flex items-center gap-2 border-b-2 transition-colors ${
              activeTab === 'lines' ? 'border-[#F59E0B] text-[#F59E0B]' : 'border-transparent text-slate-400 hover:text-slate-200'
            }`}
          >
            <Layers size={18} />
            <span>Production Lines ({lines.length})</span>
          </button>

          <button
            onClick={() => setActiveTab('stations')}
            className={`pb-3 px-2 font-space text-sm font-bold flex items-center gap-2 border-b-2 transition-colors ${
              activeTab === 'stations' ? 'border-[#F59E0B] text-[#F59E0B]' : 'border-transparent text-slate-400 hover:text-slate-200'
            }`}
          >
            <Monitor size={18} />
            <span>Work Stations ({stations.length})</span>
          </button>

          <button
            onClick={() => setActiveTab('plants')}
            className={`pb-3 px-2 font-space text-sm font-bold flex items-center gap-2 border-b-2 transition-colors ${
              activeTab === 'plants' ? 'border-[#F59E0B] text-[#F59E0B]' : 'border-transparent text-slate-400 hover:text-slate-200'
            }`}
          >
            <Factory size={18} />
            <span>Plant Facilities ({plants.length})</span>
          </button>
        </div>

        {/* Master Table */}
        <div className="bg-[#131B2E] border border-[#1E293B] rounded-xl overflow-hidden shadow-xl">
          <table className="w-full text-left text-sm text-slate-300">
            <thead className="bg-[#0B0F19] text-xs font-mono uppercase text-slate-400 border-b border-[#1E293B]">
              <tr>
                <th className="px-6 py-3.5">Name</th>
                {activeTab === 'plants' && <th className="px-6 py-3.5">Location</th>}
                {activeTab === 'lines' && <th className="px-6 py-3.5">Assigned Plant</th>}
                {activeTab === 'stations' && <th className="px-6 py-3.5">Assigned Line</th>}
                <th className="px-6 py-3.5">Status</th>
                <th className="px-6 py-3.5 text-right">Actions</th>
              </tr>
            </thead>
            <tbody className="divide-y divide-[#1E293B]">
              {loading ? (
                <tr>
                  <td colSpan={4} className="text-center py-8 text-xs font-mono text-slate-500">
                    Loading layout master...
                  </td>
                </tr>
              ) : activeTab === 'plants' ? (
                plants.map((p) => (
                  <tr key={p.id} className="hover:bg-[#1E293B]/40">
                    <td className="px-6 py-4 font-semibold text-slate-100">{p.name}</td>
                    <td className="px-6 py-4 font-mono text-xs text-slate-400">{p.location}</td>
                    <td className="px-6 py-4">
                      <span className={`inline-flex items-center gap-1 px-2.5 py-0.5 text-xs font-mono rounded-full ${p.active ? 'bg-emerald-950/40 text-emerald-400 border border-emerald-800/40' : 'bg-red-950/40 text-red-400 border border-red-800/40'}`}>
                        {p.active ? <Check size={12} /> : <X size={12} />}
                        <span>{p.active ? 'Active' : 'Disabled'}</span>
                      </span>
                    </td>
                    <td className="px-6 py-4 text-right">
                      <button onClick={() => openModal(p)} className="p-1.5 text-slate-400 hover:text-[#F59E0B]">
                        <Edit2 size={16} />
                      </button>
                    </td>
                  </tr>
                ))
              ) : activeTab === 'lines' ? (
                lines.map((l) => (
                  <tr key={l.id} className="hover:bg-[#1E293B]/40">
                    <td className="px-6 py-4 font-semibold text-slate-100">{l.name}</td>
                    <td className="px-6 py-4 font-mono text-xs text-slate-400">{l.plant?.name || 'Main Facility'}</td>
                    <td className="px-6 py-4">
                      <span className={`inline-flex items-center gap-1 px-2.5 py-0.5 text-xs font-mono rounded-full ${l.active ? 'bg-emerald-950/40 text-emerald-400 border border-emerald-800/40' : 'bg-red-950/40 text-red-400 border border-red-800/40'}`}>
                        {l.active ? <Check size={12} /> : <X size={12} />}
                        <span>{l.active ? 'Active' : 'Disabled'}</span>
                      </span>
                    </td>
                    <td className="px-6 py-4 text-right">
                      <button onClick={() => openModal(l)} className="p-1.5 text-slate-400 hover:text-[#F59E0B]">
                        <Edit2 size={16} />
                      </button>
                    </td>
                  </tr>
                ))
              ) : (
                stations.map((s) => (
                  <tr key={s.id} className="hover:bg-[#1E293B]/40">
                    <td className="px-6 py-4 font-semibold text-slate-100">{s.name}</td>
                    <td className="px-6 py-4 font-mono text-xs text-slate-400">{s.line?.name || 'Unassigned Line'}</td>
                    <td className="px-6 py-4">
                      <span className={`inline-flex items-center gap-1 px-2.5 py-0.5 text-xs font-mono rounded-full ${s.active ? 'bg-emerald-950/40 text-emerald-400 border border-emerald-800/40' : 'bg-red-950/40 text-red-400 border border-red-800/40'}`}>
                        {s.active ? <Check size={12} /> : <X size={12} />}
                        <span>{s.active ? 'Active' : 'Disabled'}</span>
                      </span>
                    </td>
                    <td className="px-6 py-4 text-right">
                      <button onClick={() => openModal(s)} className="p-1.5 text-slate-400 hover:text-[#F59E0B]">
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
                {editItem ? `Edit ${activeTab.slice(0, -1)}` : `Add New ${activeTab.slice(0, -1)}`}
              </h2>

              <form onSubmit={handleSave} className="space-y-4">
                <div>
                  <label className="block text-xs font-mono text-slate-400 mb-1 uppercase">Name</label>
                  <input
                    type="text"
                    required
                    value={name}
                    onChange={(e) => setName(e.target.value)}
                    className="w-full bg-[#0B0F19] border border-[#1E293B] focus:border-[#F59E0B] rounded-lg px-3 py-2 text-sm text-slate-100 focus:outline-none"
                  />
                </div>

                {activeTab === 'plants' && (
                  <div>
                    <label className="block text-xs font-mono text-slate-400 mb-1 uppercase">Location</label>
                    <input
                      type="text"
                      required
                      value={location}
                      onChange={(e) => setLocation(e.target.value)}
                      className="w-full bg-[#0B0F19] border border-[#1E293B] focus:border-[#F59E0B] rounded-lg px-3 py-2 text-sm text-slate-100 focus:outline-none"
                    />
                  </div>
                )}

                {activeTab === 'lines' && (
                  <div>
                    <label className="block text-xs font-mono text-slate-400 mb-1 uppercase">Plant Facility</label>
                    <select
                      value={plantId}
                      onChange={(e) => setPlantId(e.target.value)}
                      className="w-full bg-[#0B0F19] border border-[#1E293B] focus:border-[#F59E0B] rounded-lg px-3 py-2 text-sm text-slate-100 focus:outline-none"
                    >
                      {plants.map((p) => (
                        <option key={p.id} value={p.id}>
                          {p.name}
                        </option>
                      ))}
                    </select>
                  </div>
                )}

                {activeTab === 'stations' && (
                  <div>
                    <label className="block text-xs font-mono text-slate-400 mb-1 uppercase">Production Line</label>
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
                )}

                <div className="flex items-center gap-2 pt-2">
                  <input
                    type="checkbox"
                    id="activeToggle"
                    checked={active}
                    onChange={(e) => setActive(e.target.checked)}
                    className="rounded border-[#1E293B] bg-[#0B0F19] text-[#F59E0B]"
                  />
                  <label htmlFor="activeToggle" className="text-sm text-slate-200">
                    Active & Enabled
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
                    {saving ? 'Saving...' : 'Save Record'}
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
