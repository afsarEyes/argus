import { createClient } from '@supabase/supabase-js';

const supabaseUrl = process.env.NEXT_PUBLIC_SUPABASE_URL || 'https://prcgbbytixlaxuhmfurk.supabase.co';
const supabaseAnonKey = process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY || 'sb_publishable_9VXQPDYhY6rnKuuTyltApQ_bwMaphrY';

export const supabase = createClient(supabaseUrl, supabaseAnonKey);
