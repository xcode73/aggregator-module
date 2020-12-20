//
//  AggregatorRouter.swift
//  AggregatorModule
//
//  Created by Tibor Bodecs on 2020. 01. 18..
//

import Vapor
import ViperKit

struct AggregatorRouter: ViperRouter {

    let feedAdmin = AggregatorFeedAdminController()
    let itemAdmin = AggregatorFeedItemAdminController()

    func adminRoutesHook(args: HookArguments) {
        let routes = args["routes"] as! RoutesBuilder
        
        let modulePath = routes.grouped(AggregatorModule.pathComponent)
        feedAdmin.setupRoutes(on: modulePath, as: AggregatorFeedModel.pathComponent)

        let itemPath = modulePath.grouped([
            AggregatorFeedModel.pathComponent,
            feedAdmin.idPathComponent,
            "items",
        ])

        itemPath.get(use: itemAdmin.listView)
        itemPath.get(itemAdmin.idPathComponent, "toggle", use: itemAdmin.toggle)
    }
}
