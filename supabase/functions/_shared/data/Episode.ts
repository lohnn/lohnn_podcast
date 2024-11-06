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

function parseDuration(durationString: string): number | undefined {
    if (durationString === undefined) {
        return undefined;
    }

    // Try converting to number
    if (!isNaN(Number(durationString))) {
        return Number(durationString) * 1000;
    }

    const parts = durationString.split(":").map(Number);

    let hours: number, minutes: number, seconds: number;
    switch (parts.length) {
        case 3:
            [hours, minutes, seconds] = parts;
            return (hours * 3600 + minutes * 60 + seconds) * 1000;
        case 2:
            [minutes, seconds] = parts;
            return (minutes * 60 + seconds) * 1000;
        case 1:
            [seconds] = parts;
            return seconds * 1000;
        default:
            return undefined; // Invalid format
    }
}
