// Follow this setup guide to integrate the Deno language server with your editor:
// https://deno.land/manual/getting_started/setup_your_environment
// This enables autocomplete, go to definition, etc.

// Setup type definitions for built-in Supabase Runtime APIs
import "jsr:@supabase/functions-js/edge-runtime.d.ts";
import { XMLParser } from "npm:fast-xml-parser";
import { createClient } from "npm:@supabase/supabase-js";
import { Podcast } from "../_shared/Podcast.ts";
import { Episode } from "../_shared/Episode.ts";

const supabase = createClient(
    Deno.env.get("SUPABASE_URL")!,
    Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!,
);

Deno.serve(async (req) => {
    // Check if the request is authenticated by a valid user
    const { data: { user } } = await supabase.auth.getUser(
        req.headers.get("Authorization")!.replace("Bearer ", ""),
    );
    if (user === null) {
        return new Response("Unauthorized", { status: 401 });
    }

    const rssUrl = await req.text();
    console.log("Upserting podcast:", rssUrl);

    const xmlPage = await fetch(rssUrl);
    const xmlPageContent = await xmlPage.text();

    const parser = new XMLParser({ ignoreAttributes: false });
    const rssJson = parser.parse(xmlPageContent);

    const channel = rssJson.rss.channel;

    const podcast = new Podcast(
        {
            rssUrl: rssUrl,
            name: channel.title,
            link: channel.link,
            description: channel.description,
            imageUrl: channel.image?.url ?? channel["itunes:image"]["@_href"],
            language: channel.language,
            lastBuildDate: channel.lastBuildDate,
            copyright: channel.copyright,
            generator: channel.generator,
        },
    );

    await supabase.from("podcasts").upsert(podcast);

    const episodes = channel.item.map((item: any) =>
        new Episode({
            id: item.guid["#text"],
            url: item.enclosure["@_url"],
            title: item.title,
            pubDate: item.pubDate,
            description: item.description,
            imageUrl: item["itunes:image"]["@_href"],
            duration: item["itunes:duration"],
            podcast_id: rssUrl,
        })
    );

    // TODO: Remove episodes not existing?
    // TODO: Alternatively mark removed
    await supabase.from("episodes").upsert(episodes);

    return new Response();
});
