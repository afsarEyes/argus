export type UserRole = 'staff' | 'line_owner' | 'supervisor' | 'quality_manager' | 'admin';

export type TicketStatus = 'open' | 'assigned' | 'in_progress' | 'resolved' | 'closed';

export type TicketSeverity = 'critical' | 'major' | 'minor';

export interface Plant {
  id: string;
  name: string;
  location: string;
  active: boolean;
  created_at: string;
  updated_at: string;
}

export interface Line {
  id: string;
  plant_id: string;
  name: string;
  active: boolean;
  created_at: string;
  updated_at: string;
  plant?: Plant;
}

export interface Station {
  id: string;
  line_id: string;
  name: string;
  active: boolean;
  created_at: string;
  updated_at: string;
  line?: Line;
}

export interface DefectCategory {
  id: string;
  name: string;
  description?: string;
  active: boolean;
  created_at: string;
  updated_at: string;
}

export interface UserProfile {
  id: string;
  email: string;
  name: string;
  role: UserRole;
  plant_id?: string;
  line_id?: string;
  shift?: 'A' | 'B' | 'C';
  avatar_url?: string;
  is_active: boolean;
  created_at: string;
  updated_at: string;
  plant?: Plant;
  line?: Line;
}

export interface Ticket {
  id: string;
  offline_id?: string;
  human_readable_id?: string;
  reporter_id: string;
  assigned_owner_id?: string;
  line_id: string;
  station_id: string;
  defect_category_id: string;
  severity: TicketSeverity;
  description: string;
  photo_paths?: string[];
  voice_note_path?: string;
  status: TicketStatus;
  created_at: string;
  updated_at: string;
  reporter?: UserProfile;
  assigned_owner?: UserProfile;
  line?: Line;
  station?: Station;
  defect_category?: DefectCategory;
}

export interface TicketEvent {
  id: string;
  ticket_id: string;
  event_type: string;
  actor_id?: string;
  notes?: string;
  old_value?: string;
  new_value?: string;
  created_at: string;
  actor?: UserProfile;
}

export interface AssignmentRule {
  id: string;
  line_id: string;
  defect_category_id?: string;
  shift?: 'A' | 'B' | 'C';
  assigned_owner_id: string;
  created_at: string;
  updated_at: string;
  line?: Line;
  defect_category?: DefectCategory;
  assigned_owner?: UserProfile;
}

export interface SlaTarget {
  id: string;
  severity: TicketSeverity;
  resolution_time_minutes: number;
  created_at: string;
  updated_at: string;
}

export interface NotificationLog {
  id: string;
  recipient_id?: string;
  ticket_id?: string;
  title: string;
  body: string;
  status: 'sent' | 'pending' | 'failed';
  channel: 'push' | 'email' | 'in_app';
  created_at: string;
}

export interface DailyReport {
  id: string;
  report_date: string;
  shift: 'A' | 'B' | 'C' | 'ALL';
  plant_id?: string;
  line_id?: string;
  author_id?: string;
  total_tickets_logged: number;
  total_tickets_resolved: number;
  sla_breached_count: number;
  critical_issues_count: number;
  mttr_minutes: number;
  top_defect_category?: string;
  executive_summary?: string;
  key_root_causes?: string;
  preventative_actions?: string;
  status: 'draft' | 'submitted' | 'approved';
  created_at: string;
  updated_at: string;
  author?: UserProfile;
  plant?: Plant;
  line?: Line;
}
