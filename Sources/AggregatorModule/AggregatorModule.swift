//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 12. 26..
//

@_exported import FeatherCore
@_exported import AggregatorApi

struct AggregatorModule: FeatherModule {
    
    let router = AggregatorRouter()

    func boot(_ app: Application) throws {
        app.migrations.add(AggregatorMigrations.v1())
        
        app.commands.use(AggregatorCommandGroup(), as: Self.featherIdentifier)

        app.hooks.register(.adminRoutes, use: router.adminRoutesHook)
        app.hooks.register(.apiRoutes, use: router.apiRoutesHook)
        app.hooks.register(.adminWidgets, use: adminWidgetsHook)
        
        app.hooks.register(.installWebMenuItems, use: installWebMenuItemsHook)
        app.hooks.register(.installWebPages, use: installWebPagesHook)
        
        app.hooks.registerAsync("aggregator-feed-page", use: aggregatorFeedPageHook)
    }
    
    func adminWidgetsHook(args: HookArguments) -> [OrderedHookResult<TemplateRepresentable>] {
        if args.req.checkPermission(Aggregator.permission(for: .detail)) {
            return [
                .init(AggregatorAdminWidgetTemplate(), order: 300),
            ]
        }
        return []
    }

    func aggregatorFeedPageHook(args: HookArguments) async throws -> Response? {
        let req = args.req
        let metadata = args.metadata

        let items = try await AggregatorFeedItemModel
            .query(on: req.db)
            .filter(\.$visibility == .visible)
            .sort(\.$date, .descending)
            .range(..<100)
            .with(\.$feed)
            .all()
            
        let formatter = Feather.dateFormatter(timeStyle: .none)
        var groups: [String: [AggregatorFeedItemModel]] = [:]
        for item in items {
            let date = formatter.string(from: item.date)
            if groups[date] == nil {
                groups[date] = [item]
            }
            else {
                groups[date]!.append(item)
            }
        }
        
        let c = groups.keys.sorted().reversed().map { key -> AggregatorFeedPageContext.Group in
            let values = groups[key]!
            let v = values.map { item -> AggregatorFeedPageContext.Group.Item in
                .init(title: item.title, url: item.url, feed: .init(imageKey: item.feed.imageKey, title: item.feed.title))
            }
            return .init(day: key, items: v)
        }
                
        return req.templates.renderHtml(AggregatorFeedPageTemplate(.init(metadata: metadata, groups: c)))
    }
    
    func installWebMenuItemsHook(args: HookArguments) -> [Web.MenuItem.Create] {
        let menuId = args["menuId"] as! UUID
        return [
            .init(label: "Feeds", url: "/feeds/", priority: 500, menuId: menuId),
        ]
    }
    
    func installWebPagesHook(args: HookArguments) -> [Web.Page.Create] {
        [
            .init(title: "Feeds", content: "[aggregator-feed-page]"),
        ]
    }
}



