//
//  AggregatorInstaller.swift
//  AggregatorModule
//
//  Created by Tibor Bodecs on 2020. 12. 01..
//

import FeatherCore

struct AggregatorInstaller: ViperInstaller {

    /// returns the blog related dictionary of variables
    func variables() -> [[String: Any]] {
        [
            [
                "key": "aggregator.page.title",
                "value": "Aggregator page title",
                "note": "Title of the aggregator page",
            ],
            [
                "key": "aggregator.page.description",
                "value": "Aggregator page description",
                "note": "Description of the aggregator page",
            ],
        ]
    }

    func createModels(_ req: Request) -> EventLoopFuture<Void>? {
        [
            AggregatorFeedModel(imageKey: "aggregator/feeds/4beb6fb5-8da4-497b-86bd-7706d233d200.jpg",
                                title: "swift.org",
                                url: "https://swift.org/atom.xml")
        ].create(on: req.db)
    }
}
