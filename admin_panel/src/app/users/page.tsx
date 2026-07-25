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
            <h1 className="font-space font-bold text-2xl text-theme-main tracking-wide">
              USERS & STAFF MASTER
            </h1>
            <p className="text-xs text-theme-muted font-mono mt-1">
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
        <div className="bg-theme-card border border-theme p-4 rounded-xl flex flex-col md:flex-row gap-4 justify-between">
          <div className="relative flex-1">
            <Search size={18} className="absolute left-3.5 top-3 text-theme-muted" />
            <input
              type="text"
              value={search}
              onChange={(e) => setSearch(e.target.value)}
              placeholder="Search user by name or email address..."
              className="w-full bg-theme-input border border-theme focus:border-[#F59E0B] rounded-lg pl-10 pr-4 py-2 text-sm text-theme-main placeholder-theme-muted focus:outline-none"
            />
          </div>
          <div className="flex items-center gap-2">
            <span className="text-xs font-mono text-theme-muted">ROLE:</span>
            <select
              value={roleFilter}
              onChange={(e) => setRoleFilter(e.target.value)}
              className="bg-theme-input border border-theme focus:border-[#F59E0B] rounded-lg px-3 py-2 text-sm text-theme-main focus:outline-none"
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
        <div className="bg-theme-card border border-theme rounded-xl overflow-hidden shadow-xl">
          <div className="overflow-x-auto">
            <table className="w-full text-left text-sm text-theme-main">
              <thead className="bg-theme-table-header text-xs font-mono uppercase text-theme-muted border-b border-theme">
                <tr>
                  <th className="px-6 py-3.5">User Profile</th>
                  <th className="px-6 py-3.5">Role</th>
                  <th className="px-6 py-3.5">Line / Shift</th>
                  <th className="px-6 py-3.5">Status</th>
                  <th className="px-6 py-3.5 text-right">Actions</th>
                </tr>
              </thead>
              <tbody className="divide-y divide-theme">
                {loading ? (
                  <tr>
                    <td colSpan={5} className="text-center py-8 text-xs font-mono text-theme-muted">
                      Loading user directory...
                    </td>
                  </tr>
                ) : filteredUsers.length === 0 ? (
                  <tr>
                    <td colSpan={5} className="text-center py-8 text-xs font-mono text-theme-muted">
                      No matching user accounts found.
                    </td>
                  </tr>
                ) : (
                  filteredUsers.map((u) => {
                    const line = lines.find((l) => l.id === u.line_id);
                    return (
                      <tr key={u.id} className="hover:bg-theme-input/50 transition-colors">
                        <td className="px-6 py-4">
                          <div className="flex items-center gap-3">
                            <div className="w-9 h-9 bg-theme-input border border-theme rounded-full flex items-center justify-center text-[#F59E0B] font-bold">
                              {u.name.charAt(0).toUpperCase()}
                            </div>
                            <div>
                              <p className="font-semibold text-theme-main">{u.name}</p>
                              <p className="text-xs text-theme-muted font-mono">{u.email}</p>
                            </div>
                          </div>
                        </td>
                        <td className="px-6 py-4">
                          <span
                            className={`inline-block px-2.5 py-1 text-xs font-mono font-bold uppercase rounded border ${
                              u.role === 'admin'
                                ? 'bg-purple-500/10 border-purple-500/30 text-purple-500'
                                : u.role === 'quality_manager'
                                ? 'bg-emerald-500/10 border-emerald-500/30 text-emerald-500'
                                : u.role === 'supervisor'
                                ? 'bg-blue-500/10 border-blue-500/30 text-blue-500'
                                : u.role === 'line_owner'
                                ? 'bg-[#F59E0B]/10 border-[#F59E0B]/30 text-[#F59E0B]'
                                : 'bg-slate-500/10 border-slate-500/30 text-slate-400'
                            }`}
                          >
                            {u.role.replace('_', ' ')}
                          </span>
                        </td>
                        <td className="px-6 py-4 text-xs font-mono">
                          {line ? line.name : 'Global / Unassigned'}
                          {u.shift && <span className="ml-2 px-1.5 py-0.5 bg-theme-input rounded border border-theme text-theme-muted">Shift {u.shift}</span>}
                        </td>
                        <td className="px-6 py-4">
                          <span
                            className={`inline-flex items-center gap-1.5 px-2.5 py-0.5 text-xs font-mono rounded-full ${
                              u.is_active ? 'bg-emerald-500/10 text-emerald-500 border border-emerald-500/30' : 'bg-red-500/10 text-red-500 border border-red-500/30'
                            }`}
                          >
                            {u.is_active ? <Check size={12} /> : <X size={12} />}
                            <span>{u.is_active ? 'Active' : 'Disabled'}</span>
                          </span>
                        </td>
                        <td className="px-6 py-4 text-right">
                          <button
                            onClick={() => openEditModal(u)}
                            className="p-1.5 text-theme-muted hover:text-[#F59E0B] hover:bg-theme-input rounded transition-colors"
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
            <div className="bg-theme-card border border-theme w-full max-w-lg rounded-xl shadow-2xl p-6 space-y-6">
              <div className="flex items-center justify-between border-b border-theme pb-4">
                <h2 className="font-space font-bold text-lg text-theme-main">
                  {selectedUser ? 'Edit User Profile' : 'Add New Staff Credentials'}
                </h2>
                <button onClick={() => setIsModalOpen(false)} className="text-theme-muted hover:text-theme-main">
                  <X size={20} />
                </button>
              </div>

              <form onSubmit={handleSave} className="space-y-4">
                {!selectedUser && (
                  <div>
                    <label className="block text-xs font-mono text-theme-muted mb-1 uppercase">Email Address</label>
                    <input
                      type="email"
                      required
                      value={formEmail}
                      onChange={(e) => setFormEmail(e.target.value)}
                      placeholder="operator@signode.com"
                      className="w-full bg-theme-input border border-theme focus:border-[#F59E0B] rounded-lg px-3 py-2 text-sm text-theme-main focus:outline-none"
                    />
                  </div>
                )}

                <div>
                  <label className="block text-xs font-mono text-theme-muted mb-1 uppercase">Full Name</label>
                  <input
                    type="text"
                    required
                    value={formName}
                    onChange={(e) => setFormName(e.target.value)}
                    placeholder="e.g. Ramesh Kumar"
                    className="w-full bg-theme-input border border-theme focus:border-[#F59E0B] rounded-lg px-3 py-2 text-sm text-theme-main focus:outline-none"
                  />
                </div>

                {!selectedUser && (
                  <div>
                    <label className="block text-xs font-mono text-theme-muted mb-1 uppercase">Initial Password</label>
                    <input
                      type="text"
                      required
                      value={formPassword}
                      onChange={(e) => setFormPassword(e.target.value)}
                      className="w-full bg-theme-input border border-theme focus:border-[#F59E0B] rounded-lg px-3 py-2 text-sm font-mono text-theme-main focus:outline-none"
                    />
                  </div>
                )}

                <div className="grid grid-cols-2 gap-4">
                  <div>
                    <label className="block text-xs font-mono text-theme-muted mb-1 uppercase">Role</label>
                    <select
                      value={formRole}
                      onChange={(e) => setFormRole(e.target.value as UserRole)}
                      className="w-full bg-theme-input border border-theme focus:border-[#F59E0B] rounded-lg px-3 py-2 text-sm text-theme-main focus:outline-none"
                    >
                      <option value="staff">Staff (Operator)</option>
                      <option value="line_owner">Line Owner</option>
                      <option value="supervisor">Supervisor</option>
                      <option value="quality_manager">Quality Manager</option>
                      <option value="admin">Admin</option>
                    </select>
                  </div>

                  <div>
                    <label className="block text-xs font-mono text-theme-muted mb-1 uppercase">Shift Window</label>
                    <select
                      value={formShift}
                      onChange={(e) => setFormShift(e.target.value as 'A' | 'B' | 'C' | '')}
                      className="w-full bg-theme-input border border-theme focus:border-[#F59E0B] rounded-lg px-3 py-2 text-sm text-theme-main focus:outline-none"
                    >
                      <option value="">Global / Unassigned</option>
                      <option value="A">Shift A</option>
                      <option value="B">Shift B</option>
                      <option value="C">Shift C</option>
                    </select>
                  </div>
                </div>

                <div>
                  <label className="block text-xs font-mono text-theme-muted mb-1 uppercase">Assigned Line</label>
                  <select
                    value={formLineId}
                    onChange={(e) => setFormLineId(e.target.value)}
                    className="w-full bg-theme-input border border-theme focus:border-[#F59E0B] rounded-lg px-3 py-2 text-sm text-theme-main focus:outline-none"
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
                    className="rounded border-theme bg-theme-input text-[#F59E0B] focus:ring-0"
                  />
                  <label htmlFor="isActive" className="text-sm text-theme-main">
                    Account Active & Enabled
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
