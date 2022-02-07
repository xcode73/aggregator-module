//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 12. 26..
//

import SwiftHtml
import FeatherIcons

struct AggregatorAdminWidgetTemplate: TemplateRepresentable {
    
    @TagBuilder
    func render(_ req: Request) -> Tag {
        Svg.rss
        H2("Aggregator")
        Ul {
            if req.checkPermission(Aggregator.Feed.permission(for: .list)) {
                Li {
                    A("Feeds")
                        .href("aggregator/feeds/")
                }
            }
        }
    }
}
