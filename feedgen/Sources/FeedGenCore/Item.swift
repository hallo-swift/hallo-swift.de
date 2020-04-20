import Foundation
import Regex
import Ink
import HTMLString

struct Item {
    let guid: String
    let title: String
    let pubDate: String
    let author: String
    let link: String
    let enclosure: Enclosure
    let description: String
    let itunes: iTunes
}

extension Item {
    struct Enclosure {
        let type: String
        let url: String
        let length: String
    }

    struct iTunes {
        let title: String
        let duration: String
        let author: String
        let explicit: String
        let imageHref: String
        let subtitle: String
        let summary: String
        let episodeType: String
        let episode: Int
    }
}

extension Item {
    struct Error: Swift.Error, LocalizedError {
        let reason: Reason
        let value: String?
        let file: String

        init(_ reason: Reason, value: String? = nil, in file: String) {
            self.reason = reason
            self.value = value
            self.file = file
        }

        enum Reason {
            case unableToReadFile
            case blurbTooLong
            case slugAudioMismatch
            case invalidFilename
            case nonUniqueSlug
            case nonUniqueGUID
            case missingFrontmatter
            case invalidDurationFormat
            case invalidDateFormat
            case invalidExplicitValue
            case invalidItemURL
            case invalidAudioURL
            case invalidCoverURL
        }

        var errorDescription: String? {
            if let value = self.value {
                return "\(reason) \(value) in \(file)"
            }
            return "\(reason) in \(file)"
        }
    }

    static func read(fromContentsDirPath path: String,
                     baseURL: String,
                     coverFilename: String) throws -> [Item] {

        let parser = MarkdownParser()

        let yMMddFormatter = DateFormatter.with(format: .yMMdd)
        let rfc822Formatter = DateFormatter.with(format: .rfc822)

        let durationFormat = Regex(#"\d\d:\d\d:\d\d"#)

        var knownSlugs: Set<String> = []
        var knownGuids: Set<String> = []
        var episodeCounter = 0

        return try FileManager.default.contentsOfDirectory(atPath: path)
            .filter { $0 != ".DS_Store" }
            .sorted()
            .map { file in
                defer { episodeCounter += 1 }

                guard let fileContent = FileManager.default.contents(atPath: path + file),
                    let content = String(data: fileContent, encoding: .utf8)
                else {
                    throw Error(.unableToReadFile, in: file)
                }

                let markdown = parser.parse(content)

                let title = try markdown.frontmatter(for: "title", in: file)
                let slug = try markdown.frontmatter(for: "slug", in: file)
                let author = try markdown.frontmatter(for: "author", in: file)
                let dateString = try markdown.frontmatter(for: "date", in: file)
                guard let date = yMMddFormatter.date(from: dateString) else {
                    throw Error(.invalidDateFormat, in: file)
                }
                let audio = try markdown.frontmatter(for: "audio", in: file)
                let length = try markdown.frontmatter(for: "length", in: file)
                let duration = try markdown.frontmatter(for: "duration", in: file)
                let guid = markdown.frontmatter(for: "guid") ?? slug
                let blurb = try markdown.frontmatter(for: "blurb", in: file)
                let explicit = markdown.frontmatter(for: "explicit") ?? "no"

                guard blurb.count <= 255 else {
                    throw Error(.blurbTooLong, value: "\(blurb.count) of 255", in: file)
                }

                guard audio.contains("\(slug).mp3") else {
                    throw Error(.slugAudioMismatch, in: file)
                }

                guard file.starts(with: slug),
                    file.lowercased() == file
                else {
                    throw Error(.invalidFilename, in: file)
                }

                guard !knownSlugs.contains(slug) else {
                    throw Error(.nonUniqueSlug, in: file)
                }
                knownSlugs.insert(slug)

                guard !knownGuids.contains(guid) else {
                    throw Error(.nonUniqueGUID, in: file)
                }
                knownGuids.insert(guid)

                guard durationFormat.matches(duration) else {
                    throw Error(.invalidDurationFormat, in: file)
                }

                guard ["no", "yes"].contains(explicit) else { 
                    throw Error(.invalidExplicitValue, in: file)
                }

                guard let itemURL = URL(string: "\(baseURL)post/\(slug)") else {
                    throw Error(.invalidItemURL, in: file)
                }

                guard let audioURL = URL(string: audio) else {
                    throw Error(.invalidAudioURL, in: file)
                }

                guard let coverURL = URL(string: "\(baseURL)\(coverFilename)") else {
                    throw Error(.invalidCoverURL, in: file)
                }

                return Item(
                    guid: guid,
                    title: title.addingUnicodeEntities,
                    pubDate: rfc822Formatter.string(from: date),
                    author: "hallo@hallo-swift.de (Hallo Swift)",
                    link: itemURL.absoluteString,
                    enclosure: .init(
                        type: "audio/mpeg",
                        url: audioURL.absoluteString,
                        length: length),
                    description: markdown.html,
                    itunes: .init(
                        title: title.addingUnicodeEntities,
                        duration: duration,
                        author: author.addingUnicodeEntities,
                        explicit: explicit,
                        imageHref: coverURL.absoluteString,
                        subtitle: blurb.addingUnicodeEntities,
                        summary: blurb.addingUnicodeEntities,
                        episodeType: "full",
                        episode: episodeCounter))
            }
            .reversed()
    }
}

private extension Markdown {
    func frontmatter(for key: String, in file: String) throws -> String {
        guard let value = metadata[key], !value.isEmpty else {
            throw Item.Error(.missingFrontmatter, value: key, in: file)
        }
        return value.replacingOccurrences(of: "\"", with: "")
    }

    func frontmatter(for key: String) -> String? {
        metadata[key]
    }
}
