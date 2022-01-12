//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 12. 26..
//

struct AggregatorRouter: FeatherRouter {
    
    let feedAdminController = AggregatorFeedAdminController()
    let feedApiController = AggregatorFeedApiController()
    
    
    func adminRoutesHook(args: HookArguments) {
        feedAdminController.setUpRoutes(args.routes)

        args.routes.get("aggregator") { req -> Response in
            let template = AdminModulePageTemplate(.init(title: "Aggregator",
                                                         message: "module information",
                                                         navigation: [
                                                            .init(label: "Feeds", path: "/admin/aggregator/feeds/"),
                                                         ]))
            return req.templates.renderHtml(template)
        }
    }
    
    func apiRoutesHook(args: HookArguments) {
        feedApiController.setUpRoutes(args.routes)
    }
}
