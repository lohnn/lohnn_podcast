export class Episode {
    id!: string;
    url!: URL;
    title!: string;
    pub_date?: Date;
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
        this.id = (options.podcast_id + ":" + options.id)!;
        this.url = options.url!;
        this.title = options.title!;
        this.pub_date = new Date(options.pubDate);
        this.description = options.description;
        this.image_url = options.imageUrl!;
        this.duration = parseDuration(options.duration);
        this.podcast_id = options.podcast_id!;

        // Fail if required fields are missing
        if (this.id === undefined) {
            throw new Error("Episode ID is required");
        } else if (this.url === undefined) {
            throw new Error("Episode URL is required");
        } else if (this.title === undefined) {
            throw new Error("Episode title is required");
        } else if (this.image_url === undefined) {
            throw new Error("Episode image URL is required");
        } else if (this.podcast_id === undefined) {
            throw new Error("Episode podcast ID is required");
        }
    }
}

function parseDuration(durationString: string): number | undefined {
    if (durationString === undefined) {
        return undefined;
    }

    // Try converting to number
    if (!isNaN(Number(durationString))) {
        return Number(durationString);
    }

    const parts = durationString.split(":").map(Number);

    let hours: number, minutes: number, seconds: number;
    switch (parts.length) {
        case 3:
            [hours, minutes, seconds] = parts;
            return (hours * 3600 + minutes * 60 + seconds);
        case 2:
            [minutes, seconds] = parts;
            return (minutes * 60 + seconds);
        case 1:
            [seconds] = parts;
            return seconds;
        default:
            return undefined; // Invalid format
    }
}
