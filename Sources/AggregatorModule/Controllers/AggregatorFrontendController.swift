//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 04. 28..
//

import FeatherCore

struct AggregatorFrontendController {
    
    /// renders the [aggregator-feed-page] content
    func aggregatorFeedPageHook(args: HookArguments) -> EventLoopFuture<Response?> {
        let req = args.req
        let metadata = args.metadata

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
            /// transform groups into template data
            .map { groups -> [TemplateData] in
                groups.keys.sorted().reversed().map { key -> TemplateData in
                    let group = groups[key]!
                    return .dictionary([
                        "day": .double(formatter.date(from: key)?.timeIntervalSinceReferenceDate),
                        "items": .array(group.map { $0.encodeToTemplateData() })
                    ])
                }
            }
            /// render list
            .flatMap { groups in
                req.tau.render(template: "Aggregator/Feed", context: [
                    "groups": .array(groups),
                    "metadata": metadata.encodeToTemplateData()
                ])
            }
            .encodeOptionalResponse(for: req)
    }
    
}
