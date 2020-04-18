import Foundation

struct Feed {
    let title: String
    let atomFeedURL: URL
    let link: URL
    let pubDate: String
    let lastBuildDate: String
    let language: String
    let copyright: String
    let description: String
    let itunes: iTunes
    let imageHref: URL

    static let dateFormat = "E, d MMM yyyy HH:mm:ss Z"
}

extension Feed {
    struct iTunes {
        let subtitle: String
        let owner: Owner
        let author: String
        let explicit: String
        let category: String
        let keywords: String
        let type: String
        let summary: String
    }

    struct Owner {
        let name: String
        let email: String
    }
}
