//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2020. 12. 14..
//

import FeatherCore

extension AggregatorModule {

    func installModelsHook(args: HookArguments) -> EventLoopFuture<Void> {
        let req = args.req

        return [
            AggregatorFeedModel(imageKey: "aggregator/feeds/swift-logo.jpg",
                                title: "swift.org",
                                url: "https://swift.org/atom.xml")
        ].create(on: req.db)
    }

    func installMainMenuItemsHook(args: HookArguments) -> [MenuItemCreateObject] {
        let menuId = args["menuId"] as! UUID
        return [
            .init(label: "Aggregator", url: "/aggregator/", priority: 900, menuId: menuId),
        ]
    }
    
    func installPagesHook(args: HookArguments) -> [PageCreateObject] {
        [
            .init(title: "Aggregator", content: "[aggregator-feed-page]"),
        ]
    }
            
    func installVariablesHook(args: HookArguments) -> [VariableCreateObject] {
        [
            .init(key: "aggregatorFeedPageTitle",
                  name: "Aggregator feed page title",
                  value: "Aggregated news",
                  notes: "Title of the aggregator page"),
            
            .init(key: "aggregatorFeedPageExcerpt",
                  name: "Aggregator feed page description",
                  value: "The latest items of various feeds",
                  notes: "Description of the aggregator page"),
        ]
    }
    
    func installPermissionsHook(args: HookArguments) -> [PermissionCreateObject] {
        var permissions: [PermissionCreateObject] = [
            Self.hookInstallPermission(for: .custom("admin"))
        ]
        permissions += AggregatorFeedModel.hookInstallPermissions()
        return permissions
    }
}
