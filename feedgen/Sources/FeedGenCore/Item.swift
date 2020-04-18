import Foundation
import Regex
import Ink
import HTMLString

struct Item {
    let guid: String
    let title: String
    let pubDate: Date
    let author: String
    let link: URL
    let enclosure: Enclosure
    let description: String
    let itunes: iTunes

    static let dateFormat = "y-MM-dd"
}

extension Item {
    struct Enclosure {
        let type: String
        let url: URL
        let length: String
    }

    struct iTunes {
        let title: String
        let duration: String
        let author: String
        let explicit: String
        let imageHref: URL
        let subtitle: String
        let summary: String
        let episodeType: String
        let episode: Int
    }
}

private extension Regex {
    // Metadata
    static let title = Regex(#"\+\+\+(?:\n|.)+title = "(.+)"(?:\n|.)+\+\+\+"#)
    static let slug = Regex(#"\+\+\+(?:\n|.)+slug = "(.+)"(?:\n|.)+\+\+\+"#)
    static let author = Regex(#"\+\+\+(?:\n|.)+author = "(.+)"(?:\n|.)+\+\+\+"#)
    static let date = Regex(#"\+\+\+(?:\n|.)+date = "(.+)"(?:\n|.)+\+\+\+"#)

    // Content
    static let blurb = Regex(#"(?:\n|.)+<\/audio>(?:\n)+(.+)(?:\n)+#"#)
    static let content = Regex(#"(?:\n|.)+<\/audio>(?:\n)+((?:\n|.)+)"#)

    // Podcast specific stuff
    static let length = Regex(#"\+\+\+(?:\n|.)+length = "(.+)"(?:\n|.)+\+\+\+"#)
    static let duration = Regex(#"\+\+\+(?:\n|.)+duration = "(.+)"(?:\n|.)+\+\+\+"#)

    // Validation
    static let audioName = Regex(#"https:\/\/media\.hallo-swift\.de\/file\/halloswift\/(.+)\.mp3"#)
    static let durationFormat = Regex(#"\d\d:\d\d:\d\d"#)
}

extension Item {
    enum Error: Swift.Error {
        case unableToReadFile
        case slugAudioMismatch(String)
        case invalidFilename(String)
        case nonUniqueSlug(String)
        case missingRegexMatch(String, file: String)
        case invalidDurationFormat(String)
    }

    static func read(fromContentsDirPath path: String,
                     baseURL: String,
                     coverArt: String) throws -> [Item] {

        let parser = MarkdownParser()
        let dateFormatter = DateFormatter.with(format: Self.dateFormat)

        var knownSlugs: Set<String> = []
        var episodeCounter = 0

        return try FileManager.default.contentsOfDirectory(atPath: path)
            .sorted()
            .map { fileName in
                defer { episodeCounter += 1 }

                guard let fileContent = FileManager.default.contents(atPath: path + fileName),
                    let content = String(data: fileContent, encoding: .utf8)
                else {
                    throw Error.unableToReadFile
                }

                let title = try content.extractValue(for: .title, identifier: "title", in: fileName)
                let slug = try content.extractValue(for: .slug, identifier: "slug", in: fileName)
                let author = try content.extractValue(for: .author, identifier: "author", in: fileName)
                let date = try content.extractValue(for: .date, identifier: "date", in: fileName)
                let blurb = try content.extractValue(for: .blurb, identifier: "blurb", in: fileName)
                let mdContent = try content.extractValue(for: .content, identifier: "content", in: fileName)
                let length = try content.extractValue(for: .length, identifier: "length", in: fileName)
                let duration = try content.extractValue(for: .duration, identifier: "duration", in: fileName)
                let audioName = try content.extractValue(for: .audioName, identifier: "audioName", in: fileName)

                guard slug == audioName else {
                    throw Error.slugAudioMismatch(fileName)
                }

                guard fileName.starts(with: slug),
                    fileName.lowercased() == fileName
                else {
                    throw Error.invalidFilename(fileName)
                }

                guard !knownSlugs.contains(slug) else {
                    throw Error.nonUniqueSlug(fileName)
                }
                knownSlugs.insert(slug)

                guard Regex.durationFormat.matches(duration) else {
                    throw Error.invalidDurationFormat(fileName)
                }

                return Item(
                    guid: slug,
                    title: title,
                    pubDate: dateFormatter.date(from: date)!,
                    author: "hallo@hallo-swift.de (Hallo Swift)",
                    link: URL(string: "\(baseURL)post/\(slug)")!,
                    enclosure: .init(
                        type: "audio/mpeg",
                        url: URL(string: "https://media.hallo-swift.de/file/halloswift/\(slug).mp3")!,
                        length: length),
                    description: parser.html(from: mdContent),
                    itunes: .init(
                        title: title,
                        duration: duration,
                        author: author.addingUnicodeEntities,
                        explicit: "no",
                        imageHref: URL(string: "\(baseURL)\(coverArt)")!,
                        subtitle: blurb.prefix(250).map(String.init).joined().addingUnicodeEntities,
                        summary: blurb.addingUnicodeEntities,
                        episodeType: "full",
                        episode: episodeCounter))
            }
            .sorted { $0.pubDate < $1.pubDate }
    }
}

private extension String {
    func extractValue(for regex: Regex, identifier: String, in file: String) throws -> String {
        guard let optMatch = regex.firstMatch(in: self)?.captures.first, let match = optMatch else {
            throw Item.Error.missingRegexMatch(identifier, file: file)
        }
        guard !match.isEmpty else {
            throw Item.Error.missingRegexMatch(identifier, file: file)
        }
        return match
    }
}
