//
//  AggregatorFeedModel+View.swift
//  AggregatorModule
//
//  Created by Tibor Bodecs on 2020. 06. 03..
//

import FeatherCore

extension AggregatorFeedModel: LeafDataRepresentable {

    var leafData: LeafData {
        .dictionary([
            "id": id,
            "title": title,
            "imageKey": imageKey,
            "url": url,
        ])
    }
}
