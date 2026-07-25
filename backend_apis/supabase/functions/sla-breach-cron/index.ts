import { serve } from "https://deno.land/std@0.168.0/http/server.ts"
import { createClient } from "https://esm.sh/@supabase/supabase-js@2.21.0"

serve(async (req) => {
  try {
    const supabaseUrl = Deno.env.get("SUPABASE_URL") ?? "";
    const supabaseServiceKey = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY") ?? "";
    const supabase = createClient(supabaseUrl, supabaseServiceKey);

    // 1. Fetch SLA targets
    const { data: targets } = await supabase.from("sla_targets").select("severity, target_minutes");
    const slaLimits: Record<string, number> = {
      critical: 30,
      major: 60,
      minor: 120,
    };
    if (targets) {
      for (const t of targets) {
        slaLimits[t.severity] = t.target_minutes;
      }
    }

    // 2. Fetch active non-closed tickets
    const { data: activeTickets } = await supabase
      .from("tickets")
      .select("id, severity, created_at, line_id, status, reporter_id")
      .in("status", ["open", "assigned", "in_progress"]);

    if (!activeTickets || activeTickets.length === 0) {
      return new Response(JSON.stringify({ message: "No active tickets to evaluate." }));
    }

    const breachedTickets = [];

    for (const ticket of activeTickets) {
      const limitMinutes = slaLimits[ticket.severity] ?? 120;
      const elapsedMs = Date.now() - new Date(ticket.created_at).getTime();
      const elapsedMinutes = Math.floor(elapsedMs / 60000);

      if (elapsedMinutes >= limitMinutes) {
        // Check if SLA breach has already been recorded for this ticket
        const { data: breachLogged } = await supabase
          .from("ticket_events")
          .select("id")
          .eq("ticket_id", ticket.id)
          .eq("event_type", "sla_breached")
          .maybeSingle();

        if (!breachLogged) {
          breachedTickets.push(ticket);

          // a. Insert SLA breached event
          await supabase.from("ticket_events").insert([
            {
              ticket_id: ticket.id,
              actor_id: ticket.reporter_id,
              event_type: "sla_breached",
              old_value: ticket.status,
              new_value: `Elapsed: ${elapsedMinutes} mins (Target: ${limitMinutes} mins)`,
            },
          ]);

          // b. Query line supervisors and quality managers to notify
          const { data: recipients } = await supabase
            .from("users")
            .select("id")
            .or(`and(role.eq.supervisor,line_id.eq.${ticket.line_id}),role.eq.quality_manager`);

          if (recipients && recipients.length > 0) {
            const notifs = recipients.map((r) => ({
              user_id: r.id,
              ticket_id: ticket.id,
              title: "SLA TARGET BREACHED",
              body: `Ticket ${ticket.id} on Line ${ticket.line_id} has exceeded its SLA timeline target.`,
            }));
            await supabase.from("notifications_log").insert(notifs);
          }

          // c. Call send-notifications webhook internally
          try {
            await fetch(`${supabaseUrl}/functions/v1/send-notifications`, {
              method: "POST",
              headers: {
                "Content-Type": "application/json",
                Authorization: `Bearer ${supabaseServiceKey}`,
              },
              body: JSON.stringify({
                type: "sla_breach",
                ticketId: ticket.id,
                severity: ticket.severity,
                lineId: ticket.line_id,
              }),
            });
          } catch (_) {
            // Log notify errors quietly
          }
        }
      }
    }

    return new Response(JSON.stringify({ success: true, evaluated: activeTickets.length, breached: breachedTickets.length }));
  } catch (err) {
    return new Response(JSON.stringify({ error: err.message }), { status: 500 });
  }
})
