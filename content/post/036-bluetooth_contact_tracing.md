---
title: Bluetooth & Contact Tracing
slug: "036"
author: Vincent, Bilal und Kilian
date: 2020-05-06
audio: https://media.hallo-swift.de/file/halloswift/036.mp3
length: 73518855
duration: 01:27:28
blurb: Zusammen mit Vincent werfen wir einen Blick auf Bluetooth mit Bezug auf die dank Corona sehr aktuelle Thematik des Contact-Tracings.
---

## Bücher
- [Getting Started with Bluetooth Low Energy](https://www.amazon.de/dp/1491949511/)
- [Bluetooth Low Energy The Developer's Handbook](https://www.amazon.de/dp/013288836X)

## Links
- [Contact Tracing Apple](https://www.apple.com/covid19/contacttracing)
- [Exposure Notification Doku](https://developer.apple.com/documentation/exposurenotification)
- [NSHipster: Contact Tracing](https://nshipster.com/contact-tracing/)
- [Covid-19 Tracker Apps](https://github.com/fs0c131y/covid19-tracker-apps)
- [Gernot's Wie eine Corona-App funktioniert](https://medium.com/@gernot/wie-eine-corona-app-funktioniert-c83fc94f0609)

## Picks
- Vincent: [mattt](https://github.com/mattt)
- Vincent: [kiliankoe/swift-outdated](https://github.com/kiliankoe/swift-outdated)
- Bilal: [Polidea/RxBluetoothKit](https://github.com/Polidea/RxBluetoothKit)
    ```swift
    manager.scanForPeripherals(withServices: [serviceId])
      .take(1)
      .flatMap { $0.peripheral.establishConnection() }
      .flatMap { $0.discoverServices([serviceId]) }
      .flatMap { Observable.from($0) }
      .flatMap { $0.discoverCharacteristics([characteristicId]) }
      .flatMap { Observable.from($0) }
      .flatMap { $0.readValue() }
      .subscribe(onNext: { print("Value: \($0.value)") })
    ```
- Kilian: [CrunchyBagel/TracePrivately](https://github.com/CrunchyBagel/TracePrivately)
- Vincent: [How To F#€k Up An Airport](http://www.radiospaetkauf.com/2017/12/how-to-f-up-an-airport-part-1/) (Podcast)

## Social

- [Slack](https://join.slack.com/t/swiftde/shared_invite/zt-7r4hfpmv-m2CLTofoNTWhRE4v8vyMhg)
- [Matrix](https://matrix.to/#/#hallo-swift:matrix.org)
- [Twitter](https://twitter.com/hallo_swift)
