// Follow this setup guide to integrate the Deno language server with your editor:
// https://deno.land/manual/getting_started/setup_your_environment
// This enables autocomplete, go to definition, etc.

// Setup type definitions for built-in Supabase Runtime APIs
import "jsr:@supabase/functions-js/edge-runtime.d.ts";
import { fetchUser } from "../_shared/functionality/fetch_user.ts";
import { createClient } from "npm:@supabase/supabase-js";

const supabase = createClient(
    Deno.env.get("SUPABASE_URL")!,
    Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!,
);

Deno.serve(async (req) => {
    const userResponse = await fetchUser({ supabase, req });
    if (userResponse instanceof Response) {
        return userResponse;
    }

    const { data, error } = await supabase.from("podcasts").select();

    return new Response(
        JSON.stringify(data),
        { headers: { "Content-Type": "application/json" } },
    );
});
