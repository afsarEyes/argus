'use client';

import React, { useEffect, useState, useCallback } from 'react';
import AdminDashboardLayout from '@/components/layout/AdminDashboardLayout';
import { supabase } from '@/lib/supabase';
import { UserProfile, Line, Plant, UserRole } from '@/types/database';
import { Search, Plus, Edit2, Check, X } from 'lucide-react';

export default function UsersMasterPage() {
  const [users, setUsers] = useState<UserProfile[]>([]);
  const [lines, setLines] = useState<Line[]>([]);
  const [plants, setPlants] = useState<Plant[]>([]);
  const [loading, setLoading] = useState(true);
  const [search, setSearch] = useState('');
  const [roleFilter, setRoleFilter] = useState<string>('ALL');

  // Modal State
  const [isModalOpen, setIsModalOpen] = useState(false);
  const [selectedUser, setSelectedUser] = useState<Partial<UserProfile> | null>(null);

  // Form Fields
  const [formEmail, setFormEmail] = useState('');
  const [formName, setFormName] = useState('');
  const [formPassword, setFormPassword] = useState('admin@123');
  const [formRole, setFormRole] = useState<UserRole>('staff');
  const [formPlantId, setFormPlantId] = useState<string>('');
  const [formLineId, setFormLineId] = useState<string>('');
  const [formShift, setFormShift] = useState<'A' | 'B' | 'C' | ''>('A');
  const [formIsActive, setFormIsActive] = useState(true);
  const [saving, setSaving] = useState(false);

  const loadData = useCallback(async () => {
    try {
      const [usersRes, linesRes, plantsRes] = await Promise.all([
        supabase.from('users').select('*').order('name'),
        supabase.from('lines').select('*'),
        supabase.from('plants').select('*'),
      ]);

      setUsers((usersRes.data as UserProfile[]) || []);
      setLines((linesRes.data as Line[]) || []);
      setPlants((plantsRes.data as Plant[]) || []);
    } catch (err) {
      console.error('Error loading users:', err);
    } finally {
      setLoading(false);
    }
  }, []);

  useEffect(() => {
    let isMounted = true;
    const fetchData = async () => {
      try {
        const [usersRes, linesRes, plantsRes] = await Promise.all([
          supabase.from('users').select('*').order('name'),
          supabase.from('lines').select('*'),
          supabase.from('plants').select('*'),
        ]);
        if (isMounted) {
          setUsers((usersRes.data as UserProfile[]) || []);
          setLines((linesRes.data as Line[]) || []);
          setPlants((plantsRes.data as Plant[]) || []);
          setLoading(false);
        }
      } catch (err) {
        console.error('Error loading users:', err);
        if (isMounted) setLoading(false);
      }
    };

    fetchData();
    return () => {
      isMounted = false;
    };
  }, []);

  const openCreateModal = () => {
    setSelectedUser(null);
    setFormEmail('');
    setFormName('');
    setFormPassword('admin@123');
    setFormRole('staff');
    setFormPlantId(plants[0]?.id || '');
    setFormLineId('');
    setFormShift('A');
    setFormIsActive(true);
    setIsModalOpen(true);
  };

  const openEditModal = (user: UserProfile) => {
    setSelectedUser(user);
    setFormEmail(user.email);
    setFormName(user.name);
    setFormRole(user.role);
    setFormPlantId(user.plant_id || '');
    setFormLineId(user.line_id || '');
    setFormShift(user.shift || '');
    setFormIsActive(user.is_active);
    setIsModalOpen(true);
  };

  const handleSave = async (e: React.FormEvent) => {
    e.preventDefault();
    setSaving(true);

    try {
      if (selectedUser?.id) {
        // Update Existing User
        const { error } = await supabase
          .from('users')
          .update({
            name: formName,
            role: formRole,
            plant_id: formPlantId || null,
            line_id: formLineId || null,
            shift: formShift || null,
            is_active: formIsActive,
            updated_at: new Date().toISOString(),
          })
          .eq('id', selectedUser.id);

        if (error) throw error;
      } else {
        // Create New User via Auth Signup
        const { data: authData, error: authError } = await supabase.auth.signUp({
          email: formEmail,
          password: formPassword,
          options: {
            data: {
              name: formName,
              role: formRole,
            },
          },
        });

        if (authError) throw authError;

        if (authData.user) {
          await supabase.from('users').upsert({
            id: authData.user.id,
            email: formEmail,
            name: formName,
            role: formRole,
            plant_id: formPlantId || null,
            line_id: formLineId || null,
            shift: formShift || null,
            is_active: formIsActive,
          });
        }
      }

      setIsModalOpen(false);
      loadData();
    } catch (err) {
      alert(`Failed to save user: ${err instanceof Error ? err.message : String(err)}`);
    } finally {
      setSaving(false);
    }
  };

  const filteredUsers = users.filter((u) => {
    const matchesSearch =
      u.name.toLowerCase().includes(search.toLowerCase()) ||
      u.email.toLowerCase().includes(search.toLowerCase());
    const matchesRole = roleFilter === 'ALL' || u.role === roleFilter;
    return matchesSearch && matchesRole;
  });

  return (
    <AdminDashboardLayout>
      <div className="space-y-6">
        {/* Page Header */}
        <div className="flex flex-col sm:flex-row justify-between sm:items-center gap-4">
          <div>
            <h1 className="font-space font-bold text-2xl text-slate-100 tracking-wide">
              USERS & STAFF MASTER
            </h1>
            <p className="text-xs text-slate-400 font-mono mt-1">
              Manage operators, department leads, supervisors, and administrative credentials
            </p>
          </div>
          <button
            onClick={openCreateModal}
            className="flex items-center gap-2 bg-[#F59E0B] hover:bg-[#F59E0B]/90 text-slate-950 px-4 py-2.5 rounded-lg text-sm font-space font-bold uppercase transition-all shadow-lg shadow-[#F59E0B]/10"
          >
            <Plus size={18} />
            <span>Add New Staff</span>
          </button>
        </div>

        {/* Filter Controls */}
        <div className="bg-[#131B2E] border border-[#1E293B] p-4 rounded-xl flex flex-col md:flex-row gap-4 justify-between">
          <div className="relative flex-1">
            <Search size={18} className="absolute left-3.5 top-3 text-slate-500" />
            <input
              type="text"
              value={search}
              onChange={(e) => setSearch(e.target.value)}
              placeholder="Search user by name or email address..."
              className="w-full bg-[#0B0F19] border border-[#1E293B] focus:border-[#F59E0B] rounded-lg pl-10 pr-4 py-2 text-sm text-slate-100 placeholder-slate-600 focus:outline-none"
            />
          </div>
          <div className="flex items-center gap-2">
            <span className="text-xs font-mono text-slate-400">ROLE:</span>
            <select
              value={roleFilter}
              onChange={(e) => setRoleFilter(e.target.value)}
              className="bg-[#0B0F19] border border-[#1E293B] focus:border-[#F59E0B] rounded-lg px-3 py-2 text-sm text-slate-200 focus:outline-none"
            >
              <option value="ALL">All Roles</option>
              <option value="staff">Staff (Operator)</option>
              <option value="line_owner">Line Owner</option>
              <option value="supervisor">Supervisor</option>
              <option value="quality_manager">Quality Manager</option>
              <option value="admin">Admin</option>
            </select>
          </div>
        </div>

        {/* Users Table */}
        <div className="bg-[#131B2E] border border-[#1E293B] rounded-xl overflow-hidden shadow-xl">
          <div className="overflow-x-auto">
            <table className="w-full text-left text-sm text-slate-300">
              <thead className="bg-[#0B0F19] text-xs font-mono uppercase text-slate-400 border-b border-[#1E293B]">
                <tr>
                  <th className="px-6 py-3.5">User Profile</th>
                  <th className="px-6 py-3.5">Role</th>
                  <th className="px-6 py-3.5">Line / Shift</th>
                  <th className="px-6 py-3.5">Status</th>
                  <th className="px-6 py-3.5 text-right">Actions</th>
                </tr>
              </thead>
              <tbody className="divide-y divide-[#1E293B]">
                {loading ? (
                  <tr>
                    <td colSpan={5} className="text-center py-8 text-xs font-mono text-slate-500">
                      Loading user directory...
                    </td>
                  </tr>
                ) : filteredUsers.length === 0 ? (
                  <tr>
                    <td colSpan={5} className="text-center py-8 text-xs font-mono text-slate-500">
                      No matching user accounts found.
                    </td>
                  </tr>
                ) : (
                  filteredUsers.map((u) => {
                    const line = lines.find((l) => l.id === u.line_id);
                    return (
                      <tr key={u.id} className="hover:bg-[#1E293B]/40 transition-colors">
                        <td className="px-6 py-4">
                          <div className="flex items-center gap-3">
                            <div className="w-9 h-9 bg-[#1E293B] rounded-full flex items-center justify-center text-[#F59E0B] font-bold">
                              {u.name.charAt(0).toUpperCase()}
                            </div>
                            <div>
                              <p className="font-semibold text-slate-100">{u.name}</p>
                              <p className="text-xs text-slate-400 font-mono">{u.email}</p>
                            </div>
                          </div>
                        </td>
                        <td className="px-6 py-4">
                          <span
                            className={`inline-block px-2.5 py-1 text-xs font-mono font-bold uppercase rounded border ${
                              u.role === 'admin'
                                ? 'bg-purple-950/50 border-purple-800 text-purple-300'
                                : u.role === 'quality_manager'
                                ? 'bg-emerald-950/50 border-emerald-800 text-emerald-300'
                                : u.role === 'supervisor'
                                ? 'bg-blue-950/50 border-blue-800 text-blue-300'
                                : u.role === 'line_owner'
                                ? 'bg-[#F59E0B]/10 border-[#F59E0B]/30 text-[#F59E0B]'
                                : 'bg-slate-800 border-slate-700 text-slate-300'
                            }`}
                          >
                            {u.role.replace('_', ' ')}
                          </span>
                        </td>
                        <td className="px-6 py-4 text-xs font-mono">
                          {line ? line.name : 'Global / Unassigned'}
                          {u.shift && <span className="ml-2 px-1.5 py-0.5 bg-[#0B0F19] rounded border border-slate-700 text-slate-400">Shift {u.shift}</span>}
                        </td>
                        <td className="px-6 py-4">
                          <span
                            className={`inline-flex items-center gap-1.5 px-2.5 py-0.5 text-xs font-mono rounded-full ${
                              u.is_active ? 'bg-emerald-950/40 text-emerald-400 border border-emerald-800/40' : 'bg-red-950/40 text-red-400 border border-red-800/40'
                            }`}
                          >
                            {u.is_active ? <Check size={12} /> : <X size={12} />}
                            <span>{u.is_active ? 'Active' : 'Disabled'}</span>
                          </span>
                        </td>
                        <td className="px-6 py-4 text-right">
                          <button
                            onClick={() => openEditModal(u)}
                            className="p-1.5 text-slate-400 hover:text-[#F59E0B] hover:bg-[#1E293B] rounded transition-colors"
                          >
                            <Edit2 size={16} />
                          </button>
                        </td>
                      </tr>
                    );
                  })
                )}
              </tbody>
            </table>
          </div>
        </div>

        {/* Modal Dialog */}
        {isModalOpen && (
          <div className="fixed inset-0 z-50 bg-black/70 backdrop-blur-sm flex items-center justify-center p-4">
            <div className="bg-[#131B2E] border border-[#1E293B] w-full max-w-lg rounded-xl shadow-2xl p-6 space-y-6">
              <div className="flex items-center justify-between border-b border-[#1E293B] pb-4">
                <h2 className="font-space font-bold text-lg text-slate-100">
                  {selectedUser ? 'Edit User Profile' : 'Add New Staff Credentials'}
                </h2>
                <button onClick={() => setIsModalOpen(false)} className="text-slate-400 hover:text-slate-200">
                  <X size={20} />
                </button>
              </div>

              <form onSubmit={handleSave} className="space-y-4">
                {!selectedUser && (
                  <div>
                    <label className="block text-xs font-mono text-slate-400 mb-1 uppercase">Email Address</label>
                    <input
                      type="email"
                      required
                      value={formEmail}
                      onChange={(e) => setFormEmail(e.target.value)}
                      placeholder="operator@signode.com"
                      className="w-full bg-[#0B0F19] border border-[#1E293B] focus:border-[#F59E0B] rounded-lg px-3 py-2 text-sm text-slate-100 focus:outline-none"
                    />
                  </div>
                )}

                <div>
                  <label className="block text-xs font-mono text-slate-400 mb-1 uppercase">Full Name</label>
                  <input
                    type="text"
                    required
                    value={formName}
                    onChange={(e) => setFormName(e.target.value)}
                    placeholder="e.g. Ramesh Kumar"
                    className="w-full bg-[#0B0F19] border border-[#1E293B] focus:border-[#F59E0B] rounded-lg px-3 py-2 text-sm text-slate-100 focus:outline-none"
                  />
                </div>

                {!selectedUser && (
                  <div>
                    <label className="block text-xs font-mono text-slate-400 mb-1 uppercase">Initial Password</label>
                    <input
                      type="text"
                      required
                      value={formPassword}
                      onChange={(e) => setFormPassword(e.target.value)}
                      className="w-full bg-[#0B0F19] border border-[#1E293B] focus:border-[#F59E0B] rounded-lg px-3 py-2 text-sm font-mono text-slate-100 focus:outline-none"
                    />
                  </div>
                )}

                <div className="grid grid-cols-2 gap-4">
                  <div>
                    <label className="block text-xs font-mono text-slate-400 mb-1 uppercase">Role</label>
                    <select
                      value={formRole}
                      onChange={(e) => setFormRole(e.target.value as UserRole)}
                      className="w-full bg-[#0B0F19] border border-[#1E293B] focus:border-[#F59E0B] rounded-lg px-3 py-2 text-sm text-slate-100 focus:outline-none"
                    >
                      <option value="staff">Staff (Operator)</option>
                      <option value="line_owner">Line Owner</option>
                      <option value="supervisor">Supervisor</option>
                      <option value="quality_manager">Quality Manager</option>
                      <option value="admin">Admin</option>
                    </select>
                  </div>

                  <div>
                    <label className="block text-xs font-mono text-slate-400 mb-1 uppercase">Shift Window</label>
                    <select
                      value={formShift}
                      onChange={(e) => setFormShift(e.target.value as 'A' | 'B' | 'C' | '')}
                      className="w-full bg-[#0B0F19] border border-[#1E293B] focus:border-[#F59E0B] rounded-lg px-3 py-2 text-sm text-slate-100 focus:outline-none"
                    >
                      <option value="">Global / Unassigned</option>
                      <option value="A">Shift A</option>
                      <option value="B">Shift B</option>
                      <option value="C">Shift C</option>
                    </select>
                  </div>
                </div>

                <div>
                  <label className="block text-xs font-mono text-slate-400 mb-1 uppercase">Assigned Line</label>
                  <select
                    value={formLineId}
                    onChange={(e) => setFormLineId(e.target.value)}
                    className="w-full bg-[#0B0F19] border border-[#1E293B] focus:border-[#F59E0B] rounded-lg px-3 py-2 text-sm text-slate-100 focus:outline-none"
                  >
                    <option value="">All Lines / Global</option>
                    {lines.map((l) => (
                      <option key={l.id} value={l.id}>
                        {l.name}
                      </option>
                    ))}
                  </select>
                </div>

                <div className="flex items-center gap-2 pt-2">
                  <input
                    type="checkbox"
                    id="isActive"
                    checked={formIsActive}
                    onChange={(e) => setFormIsActive(e.target.checked)}
                    className="rounded border-[#1E293B] bg-[#0B0F19] text-[#F59E0B] focus:ring-0"
                  />
                  <label htmlFor="isActive" className="text-sm text-slate-200">
                    Account Active & Enabled
                  </label>
                </div>

                <div className="flex justify-end gap-3 pt-4 border-t border-[#1E293B]">
                  <button
                    type="button"
                    onClick={() => setIsModalOpen(false)}
                    className="px-4 py-2 bg-[#1E293B] text-slate-300 text-sm font-medium rounded-lg hover:bg-[#1E293B]/80"
                  >
                    Cancel
                  </button>
                  <button
                    type="submit"
                    disabled={saving}
                    className="px-4 py-2 bg-[#F59E0B] text-slate-950 text-sm font-space font-bold rounded-lg hover:bg-[#F59E0B]/90"
                  >
                    {saving ? 'Saving...' : 'Save Profile'}
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
