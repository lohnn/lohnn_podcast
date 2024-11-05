export class Podcast {
    rss_url!: string;
    name!: string;
    link!: string;
    description!: string;
    image_url!: URL;
    language?: string;
    last_build_date?: string;
    copyright?: string;
    generator?: string;

    constructor(
        options: {
            rssUrl: string;
            name: string;
            link: string;
            description: string;
            imageUrl: URL;
            language: string;
            lastBuildDate: string;
            copyright: string;
            generator: string;
        },
    ) {
        this.rss_url = options.rssUrl;
        this.name = options.name;
        this.link = options.link;
        this.description = options.description;
        this.image_url = options.imageUrl;
        this.language = options.language;
        this.last_build_date = options.lastBuildDate;
        this.copyright = options.copyright;
        this.generator = options.generator;
    }
}
