//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2020. 12. 14..
//

import FeatherCore

extension AggregatorModule {

    func modelInstallHook(args: HookArguments) -> EventLoopFuture<Void> {
        let req = args["req"] as! Request
        
        return [
            AggregatorFeedModel(imageKey: "aggregator/feeds/swift-logo.jpg",
                                title: "swift.org",
                                url: "https://swift.org/atom.xml")
        ].create(on: req.db)
    }

    func frontendMainMenuInstallHook(args: HookArguments) -> [[String:Any]] {
        [
            [
                "label": "Aggregator",
                "url": "/aggregator/",
            ],
        ]
    }

    func frontendPageInstallHook(args: HookArguments) -> [[String:Any]] {
        [
            [
                "title": "Aggregator",
                "content": "[aggregator-page]",
            ],
        ]
    }
        
    func systemVariablesInstallHook(args: HookArguments) -> [[String: Any]] {
        [
            [
                "key": "aggregator.page.title",
                "name": "Aggregator page title",
                "value": "Aggregator page title",
                "note": "Title of the aggregator page",
            ],
            [
                "key": "aggregator.page.description",
                "name": "Aggregator page description",
                "value": "Aggregator page description",
                "note": "Description of the aggregator page",
            ],
        ]
    }
    
    func userPermissionInstallHook(args: HookArguments) -> [[String: Any]] {
        AggregatorModule.permissions + 
        AggregatorFeedModel.permissions +
        [
            [
                "module": Self.name.lowercased(),
                "context": "feed.items",
                "action": "list",
                "name": "List feed items",
            ],
            [
                "module": Self.name.lowercased(),
                "context": "feed.items",
                "action": "update",
                "name": "Update feed items",
            ],
        ]
    }
}
