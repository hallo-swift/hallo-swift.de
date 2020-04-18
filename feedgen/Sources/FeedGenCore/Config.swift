import Foundation
import TOMLDecoder

struct Config: Decodable {
    let title: String
    let baseurl: String
    let languageCode: String

    let params: Params
    let feed: Feed
}

extension Config {
    struct Params: Decodable {
        let description: String
        let bio: String
        let copyright: String
    }

    struct Feed: Decodable {
        let atomFeedURL: String
        let imageHref: String
        let itunes: iTunes

        struct iTunes: Decodable {
            let ownerEmail: String
            let author: String
            let explicit: Bool
            let category: String
            let keywords: String
        }
    }
}

extension Config {
    enum Error: Swift.Error {
        case fileNotFound
        case baseURLRequiresTrailingSlash
    }

    static func read(fromPath path: String) throws -> Config {
        guard let fileContents = FileManager.default.contents(atPath: path) else { throw Error.fileNotFound }
        let config = try TOMLDecoder().decode(Config.self, from: fileContents)

        guard config.baseurl.last == "/" else {
            throw Error.baseURLRequiresTrailingSlash
        }

        return config
    }
}
