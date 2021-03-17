//
//  AggregatorFeedModel+View.swift
//  AggregatorModule
//
//  Created by Tibor Bodecs on 2020. 06. 03..
//

import FeatherCore

extension AggregatorFeedModel: TemplateDataRepresentable {

    var templateData: TemplateData {
        .dictionary([
            "id": id,
            "title": title,
            "imageKey": imageKey,
            "url": url,
        ])
    }
}
