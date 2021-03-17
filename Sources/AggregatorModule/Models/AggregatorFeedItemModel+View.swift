//
//  AggregatorFeedItemModel+View.swift
//  AggregatorModule
//
//  Created by Tibor Bodecs on 2020. 06. 03..
//

import FeatherCore

extension AggregatorFeedItemModel: TemplateDataRepresentable {

    var templateData: TemplateData {
        .dictionary([
            "id": id,
            "title": title,
            "url": url,
            "date": date.timeIntervalSinceReferenceDate,
            "visibility": visibility.rawValue,
            "feed": $feed.value != nil ? feed : nil,
        ])
    }
}
