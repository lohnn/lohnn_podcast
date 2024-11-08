import { SupabaseClient } from "npm:@supabase/supabase-js";

export async function fetchUser(options: {
    supabase: SupabaseClient;
    req: Request;
}) {
    // Check if the request is authenticated by a valid user
    const { data: { user } } = await options.supabase.auth.getUser(
        options.req.headers.get("Authorization")!.replace("Bearer ", ""),
    );
    if (user === null) {
        return new Response("Unauthorized", { status: 401 });
    }
    return user;
}
