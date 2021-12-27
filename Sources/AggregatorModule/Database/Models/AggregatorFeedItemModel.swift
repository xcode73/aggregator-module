//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 12. 26..
//

final class AggregatorFeedItemModel: FeatherDatabaseModel {
    typealias Module = AggregatorModule

    static var featherIdentifier: String = "feed_items"

    struct FieldKeys {
        struct v1 {
            static var title: FieldKey { "title" }
            static var url: FieldKey { "url" }
            static var date: FieldKey { "date" }
            static var visibility: FieldKey { "visibility" }
            static var feedId: FieldKey { "feed_id" }
        }
    }
    
    // MARK: - properties

    enum Visibility: String, Codable {
        case visible
        case hidden
        
        var localized: String {
            self.rawValue.capitalized
        }

        mutating func toggle() {
            switch self {
            case .visible:
                self = .hidden
            case .hidden:
                self = .visible
            }
        }
    }

    @ID() var id: UUID?
    @Field(key: FieldKeys.v1.title) var title: String
    @Field(key: FieldKeys.v1.url) var url: String
    @Field(key: FieldKeys.v1.date) var date: Date
    @Parent(key: FieldKeys.v1.feedId) var feed: AggregatorFeedModel
    @Field(key: FieldKeys.v1.visibility) var visibility: Visibility
    
    init() { }
    
    init(id: IDValue? = nil,
         title: String,
         url: String,
         date: Date,
         visibility: Visibility = .visible,
         feedId: AggregatorFeedModel.IDValue) {
        self.id = id
        self.title = title
        self.url = url
        self.date = date
        self.visibility = visibility
        self.$feed.id = feedId
    }
}
