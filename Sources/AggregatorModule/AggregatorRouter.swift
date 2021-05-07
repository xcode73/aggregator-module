//
//  AggregatorRouter.swift
//  AggregatorModule
//
//  Created by Tibor Bodecs on 2020. 01. 18..
//

import FeatherCore

struct AggregatorRouter: FeatherRouter {

    let feedController = AggregatorFeedAdminController()
//    let itemAdmin = AggregatorFeedItemAdminController()
    
    
    func adminRoutesHook(args: HookArguments) {
        let adminRoutes = args.routes
        
        adminRoutes.get("aggregator", use: SystemAdminMenuController(key: "aggregator").moduleView)

        adminRoutes.register(feedController)
        
//        let modulePath = routes.grouped(AggregatorModule.pathComponent)
//        feedAdmin.setupRoutes(on: modulePath, as: AggregatorFeedModel.pathComponent)
//
//        let itemPath = modulePath.grouped([
//            AggregatorFeedModel.pathComponent,
//            feedAdmin.idPathComponent,
//            "items",
//        ])
//
//        itemPath.get(use: itemAdmin.listView)
//        itemPath.get(itemAdmin.idPathComponent, "toggle", use: itemAdmin.toggle)

    }
    
    func apiAdminRoutesHook(args: HookArguments) {
        let apiRoutes = args.routes

        apiRoutes.registerApi(feedController)
    }
}
