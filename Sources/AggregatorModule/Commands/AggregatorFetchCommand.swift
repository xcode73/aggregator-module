//
//  AggregatorFetchCommand.swift
//  AggregatorModule
//
//  Created by Tibor Bodecs on 2020. 01. 24..
//

import FeatherCore
import Kanna

#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

struct FeedItem {
    var title: String
    var url: String
    var date: Date
}

class FeedDateFormatter: DateFormatter {
    
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

struct Parser {

    static func atom(xml input: String) -> [FeedItem] {
        let ns = ["a": "http://www.w3.org/2005/Atom"]

        guard let xml = try? Kanna.XML(xml: input, encoding: .utf8) else {
            return []
        }
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


final class AggregatorFetchCommand: Command {
    
    static let name = "fetch"

    struct Signature: CommandSignature { }
        
    let help = "Aggregator fetch command help"

    func run(using context: CommandContext, signature: Signature) throws {
        let app = context.application
        app.logger.notice("Loading feeds...")

//        app.client.configuration = HTTPClient.Configuration(certificateVerification: .none,
//                                                            ignoreUncleanSSLShutdown: true)

        app.http.client.configuration.timeout = .init(connect: .seconds(90), read: .seconds(90))
        app.http.client.configuration.ignoreUncleanSSLShutdown = true
        

        let items = try AggregatorFeedModel
            .query(on: app.db)
            //.range(..<1)
            .sort(\.$title, .descending)
            .with(\.$items)
            .all()
        .mapEach { feed -> EventLoopFuture<[AggregatorFeedItemModel]>  in
            return app.client.get(URI(string: feed.url), headers: [
            //"Host": "...",
                "User-Agent": "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_2) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/13.0.4 Safari/605.1.15",
                //"Accept": "text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8",
                //"Accept-Language": "en-GB,en;q=0.5",
                //"Accept-Encoding": "gzip, deflate, br",
                "Connection": "keep-alive",
                //"Cache-Control": "max-age=0",
                "Keep-Alive": "timeout=5, max=1000",
            ])
            .map { response -> String in
                guard
                    let body = response.body,
                    let xmlString = body.getString(at: 0, length: body.readableBytes)
                else {
                    return ""
                }
                return xmlString
            }
            .flatMapError { error -> EventLoopFuture<String> in
                app.logger.warning("\(feed.url) -> \(error.localizedDescription) \(error) \(type(of: error))")
                do {
                    let xmlString = try String(contentsOf: URL(string: feed.url)!)
                    return app.eventLoopGroup.future(xmlString)
                }
                catch {
                    app.logger.warning("\t\(feed.url) --> \(error.localizedDescription) \(error) \(type(of: error))")
                    return app.eventLoopGroup.future("")
                }
            }
            .map { xmlString -> [AggregatorFeedItemModel] in
                var feedItems = Parser.rss(xml: xmlString)
                if feedItems.isEmpty {
                    feedItems = Parser.atom(xml: xmlString)
                }
                // there can be duplicate urls...
                var unique: [String: FeedItem] = [:]
                for item in feedItems {
                    unique[item.url] = item
                }
                // ...or invalid dates
                let now = Date()
                return unique.values
                    .filter { $0.date < now }
                    .map { .init(title: $0.title, url: $0.url, date: $0.date, feedId: try! feed.requireID())}
            }
            .map { items in
                return items.filter { item in
                    return !feed.items.map { $0.url }.contains(item.url)
                }
            }
        }
        .flatMap { app.eventLoopGroup.next().flatten($0) }
        .map { $0.flatMap { $0} }
        .wait()
                        
        try items.create(on: app.db).wait()

        app.logger.notice("Feeds are loaded.")
    }
}
