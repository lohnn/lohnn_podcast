import { Podcast } from "../data/Podcast.ts";
import { Episode } from "../data/Episode.ts";
import { XMLParser } from "npm:fast-xml-parser";
import { SupabaseClient } from "npm:@supabase/supabase-js";

export async function upsertPodcastAndEpisodes(options: {
    rssUrl: string;
    supabase: SupabaseClient;
}) {
    console.log("Upserting podcast:", options.rssUrl);

    const xmlPage = await fetch(options.rssUrl);
    const xmlPageContent = await xmlPage.text();

    const parser = new XMLParser({
        ignoreAttributes: false,
        htmlEntities: true,
    });
    const rssJson = parser.parse(xmlPageContent);

    const channel = rssJson.rss.channel;

    const podcast = new Podcast(
        {
            rssUrl: options.rssUrl,
            name: channel.title,
            link: channel.link["@_href"] ?? channel.link,
            description: channel.description,
            imageUrl: channel.image?.url ?? channel["itunes:image"]["@_href"],
            language: channel.language,
            lastBuildDate: channel.lastBuildDate,
            copyright: channel.copyright,
            generator: channel.generator,
        },
    );

    console.log("Upserting podcast:", podcast);

    await options.supabase.from("podcasts").upsert(podcast);

    // Map if episodes that does not throw exception
    const episodes = channel.item.map((item: any) => {
        try {
            return new Episode({
                id: item.guid["#text"] ?? item.guid,
                url: item.enclosure["@_url"],
                title: item.title!,
                pubDate: item.pubDate,
                description: item.description,
                imageUrl: item["itunes:image"]?.["@_href"] ?? podcast.image_url,
                duration: item["itunes:duration"],
                podcast_id: options.rssUrl,
            });
        } catch (e) {
            console.error("Error parsing episode:", e);
            return null;
        }
    }).filter((episode: Episode | null) => episode !== null);
    console.log(
        "Upserting episodes:",
        episodes.map((episode: any) => episode.id),
    );

    // TODO: Remove episodes not existing?
    // TODO: Alternatively mark removed
    const { error } = await options.supabase.from("episodes").upsert(episodes);
    if (error !== null) {
        console.error("Error upserting episodes:", error);
    }
}
