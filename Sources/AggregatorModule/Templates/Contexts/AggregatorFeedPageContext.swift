//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 12. 27..
//

struct AggregatorFeedPageContext {
 
    struct Group {
        struct Item {

            struct Feed {
                let imageKey: String?
                let title: String
            }

            let title: String
            let url: String
            let feed: Feed
        }
        
        let day: String
        let items: [Item]
    }

    let metadata: FeatherMetadata
    let groups: [Group]
}
