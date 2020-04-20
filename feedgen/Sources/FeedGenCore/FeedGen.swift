import Foundation
import ArgumentParser
import Stencil
import PathKit

public struct FeedGenCommand: ParsableCommand {
    public static let configuration = CommandConfiguration(
        commandName: "feedgen",
        abstract: "Generate a podcast feed for a hugo page.",
        version: "0.1.0")

    public init() {}

    @Option(name: .shortAndLong, help: "Path to config.toml of hugo project, defaults to './config.toml'.")
    var configPath: String?

    @Option(name: .shortAndLong, help: "Path to directory containing feed stencil template , defaults to './resources/'.")
    var templatePath: String?

    @Option(name: .shortAndLong, help: "Path to content markdown files, defaults to './content/post/'.")
    var itemsPath: String?

    @Option(name: .shortAndLong, help: "Path to write generated feed to, defaults to './docs/index.xml'.")
    var outputPath: String?

    public func run() throws {
        // Read config
        let config = try Config.read(fromPath: configPath ?? "./config.toml")

        // Read items
        let items = try Item.read(fromContentsDirPath: itemsPath ?? "./content/post/",
                                  baseURL: config.baseurl,
                                  coverFilename: config.feed.imageHref)

        let dateFormatter = DateFormatter.with(format: .rfc822)
        let pubDate = dateFormatter.string(from: Date())

        // Create stencil context
        let context: [String: Any] = [
            "feed": Feed(title: config.title,
                         atomFeedURL: URL(string: "\(config.baseurl)\(config.feed.atomFeedURL)")!,
                         link: URL(string: config.baseurl)!,
                         pubDate: pubDate,
                         lastBuildDate: pubDate,
                         language: config.languageCode,
                         copyright: config.params.copyright.addingUnicodeEntities,
                         description: config.params.description.addingUnicodeEntities,
                         itunes: .init(
                            subtitle: config.params.bio.addingUnicodeEntities,
                            owner: .init(
                                name: config.title,
                                email: config.feed.itunes.ownerEmail),
                            author: config.feed.itunes.author.addingUnicodeEntities,
                            explicit: config.feed.itunes.explicit ? "yes" : "no",
                            category: config.feed.itunes.category,
                            keywords: config.feed.itunes.keywords,
                            type: "episodic",
                            summary: config.params.description),
                         imageHref: URL(string: "\(config.baseurl)\(config.feed.imageHref)")!),
            "items": items
        ]

        let environment = Environment(loader: FileSystemLoader(paths: [Path(templatePath ?? "./resources/")]))
        let renderedFeed = try environment.renderTemplate(name: "feed.stencil", context: context)

        // Overwrite existing feed
        try renderedFeed.write(toFile: outputPath ?? "./docs/index.xml", atomically: true, encoding: .utf8)
    }
}
