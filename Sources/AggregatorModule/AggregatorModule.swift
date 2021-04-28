//
//  AggregatorModule.swift
//  AggregatorModule
//
//  Created by Tibor Bodecs on 2020. 01. 25..
//

import FeatherCore

final class AggregatorModule: FeatherModule {

    static let moduleKey = "aggregator"
    
    var bundleUrl: URL? {
        Bundle.module.resourceURL?.appendingPathComponent("Bundle")
    }

    func boot(_ app: Application) throws {
        app.commands.use(AggregatorCommandGroup(), as: Self.moduleKey)
        
        app.migrations.add(AggregatorMigration_v1_0_0())
        /// install
        app.hooks.register(.installPermissions, use: installPermissionsHook)
        app.hooks.register(.installVariables, use: installVariablesHook)
        app.hooks.register(.installModels, use: installModelsHook)
        app.hooks.register(.installMainMenuItems, use: installMainMenuItemsHook)
        app.hooks.register(.installPages, use: installPagesHook)

        /// admin
        let router = AggregatorRouter()
        app.hooks.register(.adminRoutes, use: router.adminRoutesHook)
        app.hooks.register(.adminMenu, use: adminMenuHook)
        
        /// frontend
        let webController = AggregatorWebController()
        app.hooks.register("aggregator-feed-page", use: webController.aggregatorFeedPageHook)
    }
    
    // MARK: - hooks
    
    func adminMenuHook(args: HookArguments) -> HookObjects.AdminMenu {
        .init(key: "aggregator",
              item: .init(icon: "aggregator", link: Self.adminLink, permission: Self.permission(for: .custom("admin")).identifier),
              children: [
                .init(link: AggregatorFeedModel.adminLink, permission: AggregatorFeedModel.permission(for: .list).identifier),
              ])
    }

}
