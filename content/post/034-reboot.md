---
title: Reboot
slug: "034"
author: Bilal und Kilian
date: 2020-04-20
audio: https://media.hallo-swift.de/file/halloswift/034.mp3
length: 38900581
duration: 00:46:13
blurb: Willkommen zurück zu Hallo Swift! Begleitet uns in Zukunft bei einem Blick auf aktuelle Geschehnisse rund um Swift, Gespräche mit tollen Gästen und vielem mehr.
---

## Was bisher geschah
- letzte Folge war am 17. März 2019 (zu Swift 4.2 Zeiten)
- https://www.whatsnewinswift.com/?from=4.2&to=5.2
    - 5.0
        - `Result`
        - Dynamic callable
    - 5.1
        - Implicit return
        - Opaque return types
    - 5.2
        - Key Path Expressions as Functions
        - `callAsFunction`
        - QoL improvements
            - Improved diagnostics!
            - SwiftPM Dependency Resolver
    - bald in 5.3
        - SwiftPM Resources 🥳
- SwiftUI
- SwiftPM Support in Xcode \o/

Kilians Nutzen von dynamic member lookup für Wrapper-Typen:
```swift
struct A {
    var foo: Int
}

@dynamicMemberLookup
struct B {
    private let a: A
    init() {
        self.a = A(foo: 1)
    }
    subscript<T>(dynamicMember keyPath: KeyPath<A, T>) -> T {
        a[keyPath: keyPath]
    }
}

B().foo
```

## Aktuelles

- [apple/swift-standard-library-preview](https://github.com/apple/swift-standard-library-preview)
- Tooling
    - [SwiftDocOrg/swift-doc](https://github.com/SwiftDocOrg/swift-doc)
    - [SwiftDocOrg/DocTest](https://github.com/SwiftDocOrg/DocTest)

## Picks

- [twostraws/ControlRoom](https://github.com/twostraws/ControlRoom)
- [apple/swift-argument-parser](https://github.com/apple/swift-argument-parser)

## Weitere Links

- [SwiftPM Slack](https://swiftpm.slack.com)
- [SwiftDE Slack](https://swiftde.slack.com)
