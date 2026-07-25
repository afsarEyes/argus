import { serve } from "https://deno.land/std@0.168.0/http/server.ts"
import { createClient } from "https://esm.sh/@supabase/supabase-js@2.21.0"

serve(async (req) => {
  try {
    const supabaseUrl = Deno.env.get("SUPABASE_URL") ?? "";
    const supabaseServiceKey = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY") ?? "";
    const supabase = createClient(supabaseUrl, supabaseServiceKey);

    const payload = await req.json();
    const { type, ticketId, severity, lineId } = payload;

    if (!ticketId) {
      return new Response(JSON.stringify({ error: "Missing ticketId." }), { status: 400 });
    }

    // Fetch line name for branding payload copy
    const { data: line } = await supabase
      .from("lines")
      .select("name")
      .eq("id", lineId)
      .maybeSingle();
    const lineName = line?.name ?? `Line ${lineId}`;

    let title = "";
    let body = "";

    if (type === "sla_breach") {
      title = `Argus SLA Alert: Ticket [${ticketId}]`;
      body = `SLA TARGET BREACHED: Ticket ${ticketId} [Severity: ${severity.toUpperCase()}] on Line ${lineName} is taking too long to resolve. Check dashboard immediately.`;
    } else {
      // Default: new issue flagged
      title = `Argus: Issue Flagged on Line [${lineName}]`;
      body = `NEW QC ISSUE: Ticket ${ticketId} [Severity: ${severity.toUpperCase()}] has been flagged on Line ${lineName}.`;
    }

    // In a real production setup, we initialize Firebase Admin SDK or Resend client here:
    // E.g.:
    // const resend = new Resend(Deno.env.get("RESEND_API_KEY"));
    // await resend.emails.send({ ... });
    
    // Simulate push alert / email sending activity
    console.log(`[NOTIFY DISPATCH]`);
    console.log(`TITLE: ${title}`);
    console.log(`BODY: ${body}`);
    console.log(`TO CHANNEL: Push Notifications & Resend SMTP Digest`);

    return new Response(
      JSON.stringify({
        success: true,
        dispatched: {
          title,
          body,
          target_ticket: ticketId,
          channel: "fcm_push_and_email_resend",
        },
      })
    );
  } catch (err) {
    return new Response(JSON.stringify({ error: err.message }), { status: 500 });
  }
})
