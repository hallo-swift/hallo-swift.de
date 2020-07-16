---
title: GraphQL
slug: "039"
author: Mathías, Bilal und Kilian
date: 2020-07-16
audio: https://media.hallo-swift.de/file/halloswift/039.mp3
length: 62001263
duration: 01:13:45
blurb: Zusammen mit Mathías schauen wir uns heute GraphQL genauer an.
---

# WWDC Highlights
- Kilian: SwiftUI Updates und [SwiftPM Resource Support](https://developer.apple.com/wwdc20/10169)
- Bilal: [Car Keys](https://9to5mac.com/2020/07/02/how-apple-new-car-key-feature-works/)
- Mathías: `View.isPlaceholder(true)` und [Metal Shaders Graph](https://developer.apple.com/videos/play/wwdc2020/10677/)

# GraphQL
- Experiment: GraphQL vs. REST
    | Scenario | Δ Bytes | Δ RTT |
    | -------- | -------- | -------- |
    | Worst-Case | +80% | +18% |
    | Average-Case | -16% | -42% |
        - Mattias Cederlund. Performance of frameworks for declarative data fetching : An evaluation of falcor and relay+graphql, 2016.
- [graphile/postgraphile](https://github.com/graphile/postgraphile)
- [nerdsupremacist/Graphaello](https://github.com/nerdsupremacist/Graphaello)

```swift
// Define a Cell
struct CharacterCell: View {
    // Use the GraphQL Property Wrapper
    @GraphQL(StarWars.Person.name)
    var name: String?

    @GraphQL(StarWars.Person.homeworld.name)
    var home: String?

    var body: some View {
        HStack {
            name.map { Text($0).bold() }
            Spacer()
            home.map { Text($0) }
        }
    }
}
```

- [dbsystel/1BahnQL](https://github.com/dbsystel/1BahnQL)
- [nerdsupremacist/GraphZahl](https://github.com/nerdsupremacist/GraphZahl)
- [simonw/datasette](https://github.com/simonw/datasette)

# Picks
- Mathías: [a2/swift-shortcuts](https://github.com/a2/swift-shortcuts)
    - Lösung zu TupleView problem: [AssociatedTypeRequirementsKit](https://github.com/nerdsupremacist/AssociatedTypeRequirementsKit)
- Bilal: [nerdsupremacist/Graphaello](https://github.com/nerdsupremacist/Graphaello)
- Kilian: [krzysztofzablocki/Difference](https://github.com/krzysztofzablocki/Difference)

## Social

- [Moritz auf Twitter](https://twitter.com/slashmodev)
- [Kilian auf Twitter](https://twitter.com/kiliankoe)
- [Bilal auf Twitter](https://twitter.com/Reffas_Bilal)

- [SwiftDE Slack](https://join.slack.com/t/swiftde/shared_invite/zt-7r4hfpmv-m2CLTofoNTWhRE4v8vyMhg)
- [Hallo Swift Matrix](https://matrix.to/#/#hallo-swift:matrix.org)
