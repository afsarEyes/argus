-- ----------------------------------------------------------------------------
-- MIGRATION: 20260725180000_create_daily_reports.sql
-- Create daily_reports table for Daily Quality & Shift Reports
-- ----------------------------------------------------------------------------

CREATE TABLE IF NOT EXISTS public.daily_reports (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  report_date DATE NOT NULL DEFAULT CURRENT_DATE,
  shift VARCHAR(10) NOT NULL DEFAULT 'ALL', -- 'A', 'B', 'C', 'ALL'
  plant_id UUID REFERENCES public.plants(id) ON DELETE SET NULL,
  line_id UUID REFERENCES public.lines(id) ON DELETE SET NULL,
  author_id UUID REFERENCES public.users(id) ON DELETE SET NULL,
  
  -- Auto-Aggregated Metrics
  total_tickets_logged INT NOT NULL DEFAULT 0,
  total_tickets_resolved INT NOT NULL DEFAULT 0,
  sla_breached_count INT NOT NULL DEFAULT 0,
  critical_issues_count INT NOT NULL DEFAULT 0,
  mttr_minutes INT NOT NULL DEFAULT 0,
  top_defect_category VARCHAR(100),

  -- Qualitative Executive Input
  executive_summary TEXT,
  key_root_causes TEXT,
  preventative_actions TEXT,
  
  status VARCHAR(20) NOT NULL DEFAULT 'draft', -- 'draft', 'submitted', 'approved'
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Enable RLS
ALTER TABLE public.daily_reports ENABLE ROW LEVEL SECURITY;

-- Allow authenticated users to view all reports
CREATE POLICY "Allow authenticated read daily_reports"
ON public.daily_reports FOR SELECT
TO authenticated
USING (true);

-- Allow authenticated users to create or update daily_reports
CREATE POLICY "Allow authenticated manage daily_reports"
ON public.daily_reports FOR ALL
TO authenticated
USING (true)
WITH CHECK (true);
