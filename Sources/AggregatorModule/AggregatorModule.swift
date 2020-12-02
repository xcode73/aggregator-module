//
//  AggregatorModule.swift
//  AggregatorModule
//
//  Created by Tibor Bodecs on 2020. 01. 25..
//

import FeatherCore

final class AggregatorModule: ViperModule {

    static let name = "aggregator"

    var router: ViperRouter? = AggregatorRouter()
    var commandGroup: CommandGroup? = AggregatorCommandGroup()

    var migrations: [Migration] {
        [
            AggregatorMigration_v1_0_0(),
        ]
    }
    
    static var bundleUrl: URL? {
        Bundle.module.resourceURL?.appendingPathComponent("Bundle")
    }

    func boot(_ app: Application) throws {
        /// install
        app.hooks.register("installer", use: installerHook)
        app.hooks.register("main-menu-install", use: mainMenuInstallHook)
        app.hooks.register("static-page-install", use: staticPageInstallHook)

        /// admin
        app.hooks.register("admin", use: (router as! AggregatorRouter).adminRoutesHook)
        app.hooks.register("leaf-admin-menu", use: leafAdminMenuHook)
        
        /// frontend
        app.hooks.register("aggregator-page", use: aggregatorPageHook)        
    }
    
    // MARK: - hooks
    
    func installerHook(args: HookArguments) -> ViperInstaller {
        AggregatorInstaller()
    }
    
    func mainMenuInstallHook(args: HookArguments) -> [[String:Any]] {
        [
            [
                "label": "Aggregator",
                "url": "/aggregator/",
            ],
        ]
    }

    func staticPageInstallHook(args: HookArguments) -> [[String:Any]] {
        [
            [
                "title": "Aggregator",
                "content": "[aggregator-page]",
            ],
        ]
    }
    
    func leafAdminMenuHook(args: HookArguments) -> LeafDataRepresentable {
        [
            "name": "Aggregator",
            "icon": "rss",
            "items": LeafData.array([
                [
                    "url": "/admin/aggregator/feeds/",
                    "label": "Feeds",
                ],
            ])
        ]
    }

    /// renders the [aggregator-page] content
    func aggregatorPageHook(args: HookArguments) -> EventLoopFuture<Response?> {
        let req = args["req"] as! Request
        let metadata = args["page-metadata"] as! FrontendMetadata
        let formatter = DateFormatter()
        formatter.dateFormat = "y/MM/dd"

        return AggregatorFeedItemModel
            .query(on: req.db)
            .filter(\.$visibility == .visible)
            .sort(\.$date, .descending)
            .range(..<100)
            .with(\.$feed)
            .all()
            /// create groups by days
            .map { items -> [String: [AggregatorFeedItemModel]] in
                var groups: [String: [AggregatorFeedItemModel]] = [:]
                for item in items {
                    let date = formatter.string(from: item.date)
                    if groups[date] == nil {
                        groups[date] = [item]
                    }
                    else {
                        groups[date]?.append(item)
                    }
                }
                return groups
            }
            /// transform groups into leaf data
            .map { groups -> [LeafData] in
                groups.keys.sorted().reversed().map { key -> LeafData in
                    let group = groups[key]!
                    return .dictionary([
                        "day": .double(formatter.date(from: key)?.timeIntervalSinceReferenceDate),
                        "items": .array(group.map(\.leafData))
                    ])
                }
            }
            /// render list
            .flatMap { groups in
                req.leaf.render(template: "Aggregator/Frontend/List", context: [
                    "groups": .array(groups),
                    "metadata": metadata.leafData
                ])
            }
            .encodeOptionalResponse(for: req)
    }

}
