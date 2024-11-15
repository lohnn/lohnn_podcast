// Follow this setup guide to integrate the Deno language server with your editor:
// https://deno.land/manual/getting_started/setup_your_environment
// This enables autocomplete, go to definition, etc.

// Setup type definitions for built-in Supabase Runtime APIs
import "jsr:@supabase/functions-js/edge-runtime.d.ts";
import { createClient } from "npm:@supabase/supabase-js";
import { upsertPodcastAndEpisodes } from "../_shared/functionality/upsert_podcast_and_episodes.ts";
import { fetchUser } from "../_shared/functionality/fetch_user.ts";

const supabase = createClient(
    Deno.env.get("SUPABASE_URL")!,
    Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!,
);

const anonKey = Deno.env.get("SUPABASE_ANON_KEY");

Deno.serve(async (req) => {
    const token = req.headers.get("Authorization")!.replace("Bearer ", "");
    if (token !== anonKey) return new Response("Unauthorized", { status: 401 });

    console.log("Refreshing podcast list data");
    // Get all podcasts in the system
    const rssUrls = (await supabase.from("podcasts").select("rss_url")).data!
        .map((
            podcast,
        ) => podcast.rss_url);

    // Loop through all podcasts and upsert them

    await Promise.all(rssUrls.map((rssUrl: string) => {
        return upsertPodcastAndEpisodes({ rssUrl, supabase });
    }));

    return new Response();
});

/*
select cron.schedule(
  'refresh all podcast data every hour',
  '0 * * * *',
  $$
  select
    net.http_post(
      url:='https://backend.podcast.lohnn.se/functions/v1/refresh_podcast_list_data',
      headers:=jsonb_build_object('Content-Type','application/json', 'Authorization', 'Bearer ' || 'INSERT_ANON_KEY_HERE'),
      timeout_milliseconds:=20000
    ) as request_id;
  $$
);

select * from cron.job
select * from cron.job_run_details

select * from net._http_response;
 */

/* To invoke locally:

  1. Run `supabase start` (see: https://supabase.com/docs/reference/cli/supabase-start)
  2. Make an HTTP request:

  curl -i --location --request POST 'http://127.0.0.1:54321/functions/v1/refresh_podcast_list_data' \
    --header 'Authorization: Bearer ANON_KEY' \
    --header 'Content-Type: application/json'

*/
