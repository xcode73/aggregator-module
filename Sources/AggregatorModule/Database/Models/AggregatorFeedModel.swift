//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 12. 26..
//

final class AggregatorFeedModel: FeatherDatabaseModel {
    typealias Module = AggregatorModule

    struct FieldKeys {
        struct v1 {
            static var imageKey: FieldKey { "image_key" }
            static var title: FieldKey { "title" }
            static var url: FieldKey { "url" }
        }
    }
    
    // MARK: - fields

    @ID() var id: UUID?
    @Field(key: FieldKeys.v1.imageKey) var imageKey: String?
    @Field(key: FieldKeys.v1.title) var title: String
    @Field(key: FieldKeys.v1.url) var url: String
    @Children(for: \.$feed) var items: [AggregatorFeedItemModel]
    
    init() { }

    init(id: UUID? = nil,
         imageKey: String?,
         title: String,
         url: String) {
        self.id = id
        self.imageKey = imageKey
        self.title = title
        self.url = url
    }
}
