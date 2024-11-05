export class Episode {
    id!: string;
    url!: URL;
    title!: string;
    pub_date?: string;
    description?: string;
    image_url!: URL;
    duration?: number;
    podcast_id!: string;
    constructor(
        options: {
            id: string;
            url: URL;
            title: string;
            pubDate: string;
            description: string;
            imageUrl: URL;
            duration: string;
            podcast_id: string;
        },
    ) {
        this.id = options.podcast_id + ":" + options.id;
        this.url = options.url;
        this.title = options.title;
        this.pub_date = options.pubDate;
        this.description = options.description;
        this.image_url = options.imageUrl;
        this.duration = parseDuration(options.duration);
        this.podcast_id = options.podcast_id;
    }
}

function parseDuration(duration: string): number | undefined {
    if (duration === undefined) {
        return undefined;
    }
    const [hours, minutes, seconds] = duration.split(":").map(Number);
    return (hours * 60 * 60 + minutes * 60 + seconds) * 1000;
}
