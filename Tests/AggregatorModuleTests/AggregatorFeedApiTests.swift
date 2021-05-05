//
//  AggregatorModuleTests.swift
//  AggregatorModule
//
//  Created by Tibor Bodecs on 2020. 08. 23..
//

import FeatherTest
import AggregatorApi
@testable import AggregatorModule

extension FeedGetObject: UUIDContent {}

final class AggregatorFeedApiTests: FeatherApiTestCase {
    
    override class func testModules() -> [FeatherModule] {
        [AggregatorModule()]
    }

    override func modelName() -> String {
        "Feed"
    }
    
    override func endpoint() -> String {
        "aggregator/feeds"
    }
    
    func testListFeeds() throws {
        try list(FeedListObject.self)
    }
    
    func testCreateFeed() throws {
        let uuid = UUID().uuidString
        let input = FeedCreateObject(imageKey: "lorem", title: "ipsum", url: "dolor" + uuid)
        try create(input, FeedGetObject.self) { item in
            XCTAssertEqual(item.url, "dolor" + uuid)
        }
    }
    
    func testCreateInvalidFeed() throws {
        let input = FeedCreateObject(imageKey: "", title: "", url: "")
        try createInvalid(input) { error in
            XCTAssertEqual(error.details.count, 3)
        }
    }
    
    func testUpdateFeed() throws {
        let uuid = UUID().uuidString
        let input = FeedCreateObject(imageKey: "lorem", title: "ipsum", url: "dolor" + uuid)
        let uuid2 = UUID().uuidString
        let up = FeedCreateObject(imageKey: "lorem", title: "ipsum", url: "dolor" + uuid2)
        try update(input, up, FeedGetObject.self) { item in
            XCTAssertEqual(item.url, "dolor" + uuid2)
        }
    }
    
    func testPatchFeed() throws {
        let uuid = UUID().uuidString
        let input = FeedCreateObject(imageKey: "lorem", title: "ipsum", url: "dolor" + uuid)
        let uuid2 = UUID().uuidString
        let up = FeedPatchObject(url: "dolor" + uuid2)

        try patch(input, up, FeedGetObject.self) { item in
            XCTAssertEqual(item.url, "dolor" + uuid2)
        }
    }
    
    func testUniqueKeyFailure() throws {
        let uuid = UUID().uuidString
        let input = FeedCreateObject(imageKey: "lorem", title: "ipsum", url: "dolor" + uuid)
        try create(input, FeedGetObject.self) { item in
            /// ok
        }

        try createInvalid(input) { error in
            XCTAssertEqual(error.details.count, 1)
            XCTAssertEqual(error.details[0].key, "url")
            XCTAssertEqual(error.details[0].message, "Url must be unique")
        }
    }

    func testDeleteFeed() throws {
        let uuid = UUID().uuidString
        let input = FeedCreateObject(imageKey: "lorem", title: "ipsum", url: "dolor" + uuid)
        try delete(input, FeedGetObject.self)
    }
    
    func testMissingDeleteFeed() throws {
        try deleteMissing()
    }
}

