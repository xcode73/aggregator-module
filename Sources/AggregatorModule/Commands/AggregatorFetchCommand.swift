//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 12. 27..
//

import Kanna

fileprivate struct FeedItem {
    var title: String
    var url: String
    var date: Date
}

fileprivate final class FeedDateFormatter: DateFormatter {
    
    let dateFormats = [
        "EEE, d MMM yyyy HH:mm zzz",
        "EEE, d MMM yyyy HH:mm:ss zzz",
        
        "EEE, dd MMM yyyy",
        "EEE, dd MMMM yyyy HH:mm:ss Z",
        "EEE, dd MMM yyyy HH:mm zzz",
        "EEE, dd MMM yyyy HH:mm:ss zzz",
        
        "yyyy-MM-dd'T'hh:mm",
        "yyyy-MM-dd'T'HH:mmSSZZZZZ",
        "yyyy-MM-dd'T'HH:mm:ssZZZZZ",
        "yyyy-MM-dd'T'HH:mm:ssZZ",
        "yyyy-MM-dd'T'HH:mm:ss-SS:ZZ",
        "yyyy-MM-dd'T'HH:mm:ss.SSZZZZZ",
    ]
    
    let locales = [
        Locale(identifier: "en_US_POSIX"),
        Locale(identifier: "en_US"),
        Locale.current,
    ]
    
    override func date(from string: String) -> Date? {
        for locale in self.locales {
            self.locale = locale
            for dateFormat in self.dateFormats {
                self.dateFormat = dateFormat
                if let date = super.date(from: string) {
                    return date
                }
            }
        }
        return nil
    }
}

fileprivate struct Parser {
    
    static func atom(xml input: String) -> [FeedItem] {
        let ns = ["a": "http://www.w3.org/2005/Atom"]
        do {
            let xml = try Kanna.XML(xml: input, encoding: .utf8)
            let formatter = FeedDateFormatter()
            let items = xml.xpath("/a:feed/a:entry", namespaces: ns)
            return items.compactMap { item in
                guard
                    let title = item.at_xpath("a:title", namespaces: ns)?.text, !title.isEmpty,
                    let link = item.at_xpath("a:link/@href", namespaces: ns)?.text, !link.isEmpty,
                    let update = item.at_xpath("a:updated", namespaces: ns)?.text, !update.isEmpty,
                    let date = formatter.date(from: update)
                else {
                    return nil
                }
                return FeedItem(title: title, url: link, date: date)
            }
        }
        catch {
//            print("Error: \(error)")
            return []
        }
    }
    
    static func rss(xml input: String) -> [FeedItem] {
        guard let xml = try? Kanna.XML(xml: input, encoding: .utf8) else {
            return []
        }
        
        let formatter = FeedDateFormatter()
        let items = xml.xpath("/rss/channel/item")
        return items.compactMap { item in
            guard
                let title = item.at_xpath("title")?.text, !title.isEmpty,
                let link = item.at_xpath("link")?.text, !link.isEmpty,
                let update = item.at_xpath("pubDate")?.text, !update.isEmpty,
                let date = formatter.date(from: update)
            else {
                return nil
            }
            return FeedItem(title: title, url: link, date: date)
        }
    }
}

struct AggregatorFetchCommand: Command {
    
    static let name = "fetch"
    
    struct Signature: CommandSignature { }
    
    let help = "Aggregator fetch command help"
    
    func run(using context: CommandContext, signature: Signature) throws {
        try context.application.eventLoopGroup.next().performWithTask {
            let count = try await performTask(context.application)
            
            context.application.logger.notice("A total of \(count) feed items were created.")
        }.wait()
    }
    
    private func performTask(_ app: Application) async throws -> Int {
        let feeds = try await AggregatorFeedModel
            .query(on: app.db)
//            .range(..<1)
//            .sort(\.$title, .descending)
            .with(\.$items)
            .all()
        
        app.http.client.configuration.decompression = .enabled(limit: .ratio(50))
        
        let feedItems = try await feeds.mapAsyncParallel { feed -> [AggregatorFeedItemModel] in
            let response = try await app.client.get(URI(string: feed.url), headers: [
                "User-Agent": "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_2) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/13.0.4 Safari/605.1.15",
                "Connection": "keep-alive",
                "Keep-Alive": "timeout=5, max=1000",
                "Content-Type": "application/xml;charset=utf-8",
                "Accept": "application/xml;charset=utf-8",
                "Accept-Charset": "utf-8",
                "Accept-Encoding": "identity",
            ])

            guard
                let body = response.body,
                let xmlString = body.getString(at: 0, length: body.readableBytes)
            else {
                return []
            }

            var feedItems = Parser.rss(xml: xmlString)
            if feedItems.isEmpty {
                feedItems = Parser.atom(xml: xmlString)
            }

            var unique: [String: FeedItem] = [:]
            for item in feedItems {
                unique[item.url] = item
            }
            // ...or invalid dates
            let now = Date()
            return unique.values
                .filter { $0.date < now }
                .filter { !feed.items.map(\.url).contains($0.url) }
                .map { AggregatorFeedItemModel(title: $0.title, url: $0.url, date: $0.date, feedId: feed.uuid)}
        }
        .flatMap { $0 }

        try await feedItems.create(on: app.db)
        return feedItems.count
    }
}
