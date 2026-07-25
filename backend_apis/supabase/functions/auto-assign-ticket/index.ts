import { serve } from "https://deno.land/std@0.168.0/http/server.ts"
import { createClient } from "https://esm.sh/@supabase/supabase-js@2.21.0"

serve(async (req) => {
  try {
    const supabaseUrl = Deno.env.get("SUPABASE_URL") ?? "";
    const supabaseServiceKey = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY") ?? "";
    const supabase = createClient(supabaseUrl, supabaseServiceKey);

    const payload = await req.json();
    const ticket = payload.record;

    if (!ticket) {
      return new Response(JSON.stringify({ error: "Missing ticket record." }), { status: 400 });
    }

    const { id: ticketId, line_id, defect_category_id, created_at, reporter_id } = ticket;

    // 1. Calculate Shift based on UTC timestamp of created_at
    // Shift A: 06:00 to 14:00 | Shift B: 14:00 to 22:00 | Shift C: 22:00 to 06:00
    const createdDate = new Date(created_at);
    const hour = createdDate.getUTCHours();
    let shift = "C";
    if (hour >= 6 && hour < 14) {
      shift = "A";
    } else if (hour >= 14 && hour < 22) {
      shift = "B";
    }

    let assignedOwnerId: string | null = null;
    let assignmentMethod = "exact_rule";

    // 2. Query exact matching rule: (line_id, defect_category_id, shift)
    const { data: exactRule } = await supabase
      .from("assignment_rules")
      .select("assigned_owner_id")
      .eq("line_id", line_id)
      .eq("defect_category_id", defect_category_id)
      .eq("shift", shift)
      .maybeSingle();

    if (exactRule) {
      assignedOwnerId = exactRule.assigned_owner_id;
    } else {
      // 3. Fallback level 1: matching rule for the line & shift (any category)
      const { data: shiftFallbackRule } = await supabase
        .from("assignment_rules")
        .select("assigned_owner_id")
        .eq("line_id", line_id)
        .eq("shift", shift)
        .limit(1)
        .maybeSingle();

      if (shiftFallbackRule) {
        assignedOwnerId = shiftFallbackRule.assigned_owner_id;
        assignmentMethod = "shift_fallback";
      } else {
        // 4. Fallback level 2: any matching rule for the line
        const { data: lineFallbackRule } = await supabase
          .from("assignment_rules")
          .select("assigned_owner_id")
          .eq("line_id", line_id)
          .limit(1)
          .maybeSingle();

        if (lineFallbackRule) {
          assignedOwnerId = lineFallbackRule.assigned_owner_id;
          assignmentMethod = "line_fallback";
        }
      }
    }

    if (assignedOwnerId) {
      // Rule matched: Update status to 'assigned' and assign to owner
      await supabase
        .from("tickets")
        .update({
          assigned_owner_id: assignedOwnerId,
          status: "assigned",
          acknowledged_at: new Date().toISOString(),
        })
        .eq("id", ticketId);

      // Log status/assignment changes in ticket_events
      await supabase.from("ticket_events").insert([
        {
          ticket_id: ticketId,
          actor_id: assignedOwnerId,
          event_type: "auto_assigned",
          new_value: `Assigned via ${assignmentMethod}`,
        },
      ]);

      // Create notification log item
      await supabase.from("notifications_log").insert([
        {
          user_id: assignedOwnerId,
          ticket_id: ticketId,
          title: "New Ticket Auto-Assigned",
          body: `Ticket ${ticketId} has been auto-assigned to you based on plant routing rules.`,
        },
      ]);

      return new Response(JSON.stringify({ success: true, assigned_to: assignedOwnerId, method: assignmentMethod }));
    } else {
      // No rules match: Keep status as open, log audit notes
      await supabase.from("ticket_events").insert([
        {
          ticket_id: ticketId,
          actor_id: reporter_id,
          event_type: "assignment_failed",
          new_value: "Ticket remains open (unassigned)",
        },
      ]);

      return new Response(JSON.stringify({ success: true, assigned_to: null, message: "No matching rules. Kept open." }));
    }
  } catch (err) {
    return new Response(JSON.stringify({ error: err.message }), { status: 500 });
  }
})
