-- ============================================================================
-- ARGUS QC PLATFORM - SEED DATA SCRIPT
-- ============================================================================

BEGIN;

-- ----------------------------------------------------------------------------
-- 1. SEED PLANTS
-- ----------------------------------------------------------------------------
INSERT INTO public.plants (id, name, location, active) VALUES
  ('11111111-1111-1111-1111-111111111111', 'Signode Main Plant - Sector 4', 'Dhanbad Industrial Zone, JH', true),
  ('22222222-2222-2222-2222-222222222222', 'Signode Packaging Unit - West', 'Jamshedpur Works, JH', true)
ON CONFLICT (id) DO NOTHING;

-- ----------------------------------------------------------------------------
-- 2. SEED PRODUCTION LINES
-- ----------------------------------------------------------------------------
INSERT INTO public.lines (id, plant_id, name, active) VALUES
  ('a1111111-1111-1111-1111-111111111111', '11111111-1111-1111-1111-111111111111', 'Line 1 - Automated Assembly', true),
  ('a2222222-2222-2222-2222-222222222222', '11111111-1111-1111-1111-111111111111', 'Line 2 - Heavy Welding & Framing', true),
  ('a3333333-3333-3333-3333-333333333333', '11111111-1111-1111-1111-111111111111', 'Line 3 - Powder Coating & Finishing', true),
  ('a4444444-4444-4444-4444-444444444444', '22222222-2222-2222-2222-222222222222', 'Line A - High-Speed Strapping', true)
ON CONFLICT (id) DO NOTHING;

-- ----------------------------------------------------------------------------
-- 3. SEED WORK STATIONS
-- ----------------------------------------------------------------------------
INSERT INTO public.stations (id, line_id, name, active) VALUES
  ('c1111111-1111-1111-1111-111111111111', 'a1111111-1111-1111-1111-111111111111', 'Station 1A - Component Feed', true),
  ('c1111112-1111-1111-1111-111111111111', 'a1111111-1111-1111-1111-111111111111', 'Station 1B - Robotic Arm Solder', true),
  ('c2222221-2222-2222-2222-222222222222', 'a2222222-2222-2222-2222-222222222222', 'Station 2A - Frame Alignment', true),
  ('c2222222-2222-2222-2222-222222222222', 'a2222222-2222-2222-2222-222222222222', 'Station 2B - Structural Welding Bay', true),
  ('c3333331-3333-3333-3333-333333333333', 'a3333333-3333-3333-3333-333333333333', 'Station 3A - Surface Pre-Treatment', true),
  ('c3333332-3333-3333-3333-333333333333', 'a3333333-3333-3333-3333-333333333333', 'Station 3B - Electrostatic Paint Booth', true)
ON CONFLICT (id) DO NOTHING;

-- ----------------------------------------------------------------------------
-- 4. SEED DEFECT CATEGORIES (TAXONOMY)
-- ----------------------------------------------------------------------------
INSERT INTO public.defect_categories (id, name, description, active) VALUES
  ('d1111111-1111-1111-1111-111111111111', 'Welding Defect & Porosity', 'Incomplete weld penetration or spatter exceeding tolerance limit.', true),
  ('d2222222-2222-2222-2222-222222222222', 'Paint Peel & Surface Flaw', 'Blistering, uneven powder coat thickness, or bare spots.', true),
  ('d3333333-3333-3333-3333-333333333333', 'Electrical Short & Harness Fault', 'Faulty wiring harness connector or blown fuse.', true),
  ('d4444444-4444-4444-4444-444444444444', 'Hydraulic Leak & Pressure Drop', 'Oil seepage from cylinder seals under standard load test.', true),
  ('d5555555-5555-5555-5555-555555555555', 'Dimensional Out-of-Spec', 'Part measurements exceed drawing tolerances on key alignment points.', true)
ON CONFLICT (id) DO NOTHING;

-- ----------------------------------------------------------------------------
-- 5. SEED USERS & CREDENTIALS
-- ----------------------------------------------------------------------------
INSERT INTO auth.users (
  id, instance_id, email, encrypted_password, email_confirmed_at,
  raw_app_meta_data, raw_user_meta_data, created_at, updated_at, role, aud
) VALUES
  ('f1111111-1111-1111-1111-111111111111', '00000000-0000-0000-0000-000000000000', 'operator1@signode.com', '$2b$10$1vgh1OBsyzei3lQhROlRHOYQoHi36de.ilpbtKrGYXCEq5VWSJ/KO', now(), '{"provider":"email","providers":["email"]}', '{"name":"Raju Sharma"}', now(), now(), 'authenticated', 'authenticated'),
  ('f2222222-2222-2222-2222-222222222222', '00000000-0000-0000-0000-000000000000', 'welding.lead@signode.com', '$2b$10$1vgh1OBsyzei3lQhROlRHODs3TrYjeuyTBGZvg0ifu/pG.2RMHft2', now(), '{"provider":"email","providers":["email"]}', '{"name":"Amit Verma"}', now(), now(), 'authenticated', 'authenticated'),
  ('f3333333-3333-3333-3333-333333333333', '00000000-0000-0000-0000-000000000000', 'finish.lead@signode.com', '$2b$10$1vgh1OBsyzei3lQhROlRHOHbwww.Oez.72jsDCrohswpVoRv0iZsq', now(), '{"provider":"email","providers":["email"]}', '{"name":"Priya Singh"}', now(), now(), 'authenticated', 'authenticated'),
  ('f4444444-4444-4444-4444-444444444444', '00000000-0000-0000-0000-000000000000', 'supervisor@signode.com', '$2b$10$1vgh1OBsyzei3lQhROlRHOfzhv0IS5sIeAW4qFyB6hfqyMaCeIy2C', now(), '{"provider":"email","providers":["email"]}', '{"name":"Vikram Malhotra"}', now(), now(), 'authenticated', 'authenticated'),
  ('f5555555-5555-5555-5555-555555555555', '00000000-0000-0000-0000-000000000000', 'qm@signode.com', '$2b$10$1vgh1OBsyzei3lQhROlRHOhQf/NivwG4t5xWaNUi78jXjvDSlxxyC', now(), '{"provider":"email","providers":["email"]}', '{"name":"Dr. Sunita Rao"}', now(), now(), 'authenticated', 'authenticated'),
  ('f6666666-6666-6666-6666-666666666666', '00000000-0000-0000-0000-000000000000', 'admin@signode.com', '$2b$10$1vgh1OBsyzei3lQhROlRHOO7YqxdUmIOVViIzRFpl9wc6nfwztv46', now(), '{"provider":"email","providers":["email"]}', '{"name":"System Admin"}', now(), now(), 'authenticated', 'authenticated')
ON CONFLICT (id) DO NOTHING;

-- Clean up and normalize auth.users (excluding unique constraints fields like phone) to resolve GoTrue DB scan-to-string issues
UPDATE auth.users SET
  confirmation_token = COALESCE(confirmation_token, ''),
  recovery_token = COALESCE(recovery_token, ''),
  email_change_token_new = COALESCE(email_change_token_new, ''),
  email_change = COALESCE(email_change, ''),
  phone_change = COALESCE(phone_change, ''),
  phone_change_token = COALESCE(phone_change_token, ''),
  email_change_token_current = COALESCE(email_change_token_current, ''),
  reauthentication_token = COALESCE(reauthentication_token, '');

-- Synchronize Public User Profiles
INSERT INTO public.users (id, email, name, role, plant_id, line_id, shift, is_active) VALUES
  ('f1111111-1111-1111-1111-111111111111', 'operator1@signode.com', 'Raju Sharma', 'staff', '11111111-1111-1111-1111-111111111111', 'a2222222-2222-2222-2222-222222222222', 'A', true),
  ('f2222222-2222-2222-2222-222222222222', 'welding.lead@signode.com', 'Amit Verma (Welding Lead)', 'line_owner', '11111111-1111-1111-1111-111111111111', 'a2222222-2222-2222-2222-222222222222', 'A', true),
  ('f3333333-3333-3333-3333-333333333333', 'finish.lead@signode.com', 'Priya Singh (Finishing Lead)', 'line_owner', '11111111-1111-1111-1111-111111111111', 'a3333333-3333-3333-3333-333333333333', 'A', true),
  ('f4444444-4444-4444-4444-444444444444', 'supervisor@signode.com', 'Vikram Malhotra', 'supervisor', '11111111-1111-1111-1111-111111111111', NULL, 'A', true),
  ('f5555555-5555-5555-5555-555555555555', 'qm@signode.com', 'Dr. Sunita Rao', 'quality_manager', '11111111-1111-1111-1111-111111111111', NULL, NULL, true),
  ('f6666666-6666-6666-6666-666666666666', 'admin@signode.com', 'System Admin', 'admin', '11111111-1111-1111-1111-111111111111', NULL, NULL, true)
ON CONFLICT (id) DO UPDATE SET
  name = EXCLUDED.name,
  role = EXCLUDED.role,
  plant_id = EXCLUDED.plant_id,
  line_id = EXCLUDED.line_id,
  shift = EXCLUDED.shift;

-- ----------------------------------------------------------------------------
-- 6. SEED ASSIGNMENT ROUTING RULES
-- ----------------------------------------------------------------------------
INSERT INTO public.assignment_rules (id, line_id, defect_category_id, shift, assigned_owner_id) VALUES
  ('e1111111-1111-1111-1111-111111111111', 'a2222222-2222-2222-2222-222222222222', 'd1111111-1111-1111-1111-111111111111', 'A', 'f2222222-2222-2222-2222-222222222222'),
  ('e2222222-2222-2222-2222-222222222222', 'a3333333-3333-3333-3333-333333333333', 'd2222222-2222-2222-2222-222222222222', 'A', 'f3333333-3333-3333-3333-333333333333'),
  ('e3333333-3333-3333-3333-333333333333', 'a2222222-2222-2222-2222-222222222222', 'd3333333-3333-3333-3333-333333333333', NULL, 'f2222222-2222-2222-2222-222222222222')
ON CONFLICT (id) DO NOTHING;

-- ----------------------------------------------------------------------------
-- 7. SEED SAMPLE TICKETS
-- ----------------------------------------------------------------------------
INSERT INTO public.tickets (
  id, offline_id, reporter_id, assigned_owner_id, line_id, station_id, 
  defect_category_id, severity, description, status, created_at
) VALUES 
  ('ARG-2026-00001', 'e1111111-1111-1111-1111-111111111111', 'f1111111-1111-1111-1111-111111111111', NULL, 'a1111111-1111-1111-1111-111111111111', 'c1111112-1111-1111-1111-111111111111', 'd3333333-3333-3333-3333-333333333333', 'major', 'Robotic soldering arm throwing interlinked connection errors.', 'open', now() - interval '15 minutes'),
  ('ARG-2026-00002', 'e2222222-2222-2222-2222-222222222222', 'f1111111-1111-1111-1111-111111111111', 'f2222222-2222-2222-2222-222222222222', 'a2222222-2222-2222-2222-222222222222', 'c2222222-2222-2222-2222-222222222222', 'd1111111-1111-1111-1111-111111111111', 'critical', 'Severe weld gap observed on structural frame bracket #B-42.', 'assigned', now() - interval '20 minutes'),
  ('ARG-2026-00003', 'e3333333-3333-3333-3333-333333333333', 'f1111111-1111-1111-1111-111111111111', 'f3333333-3333-3333-3333-333333333333', 'a3333333-3333-3333-3333-333333333333', 'c3333332-3333-3333-3333-333333333333', 'd2222222-2222-2222-2222-222222222222', 'minor', 'Minor paint drip runs along lower edge of enclosure panel.', 'in_progress', now() - interval '45 minutes')
ON CONFLICT (id) DO NOTHING;

-- ----------------------------------------------------------------------------
-- 8. SEED TICKET AUDIT EVENTS
-- ----------------------------------------------------------------------------
INSERT INTO public.ticket_events (ticket_id, event_type, actor_id, old_value, new_value, created_at) VALUES
  ('ARG-2026-00001', 'created', 'f1111111-1111-1111-1111-111111111111', NULL, 'open', now() - interval '15 minutes'),
  ('ARG-2026-00002', 'created', 'f1111111-1111-1111-1111-111111111111', NULL, 'open', now() - interval '20 minutes'),
  ('ARG-2026-00002', 'assigned', 'f4444444-4444-4444-4444-444444444444', 'open', 'assigned', now() - interval '19 minutes'),
  ('ARG-2026-00003', 'created', 'f1111111-1111-1111-1111-111111111111', NULL, 'open', now() - interval '45 minutes'),
  ('ARG-2026-00003', 'acknowledged', 'f3333333-3333-3333-3333-333333333333', 'assigned', 'in_progress', now() - interval '30 minutes')
ON CONFLICT (id) DO NOTHING;

COMMIT;
