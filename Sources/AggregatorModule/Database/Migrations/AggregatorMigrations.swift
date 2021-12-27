//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 12. 26..
//

struct AggregatorMigrations {

    struct v1: AsyncMigration {

        func prepare(on db: Database) async throws {
            try await db.schema(AggregatorFeedModel.schema)
                .id()
                .field(AggregatorFeedModel.FieldKeys.v1.title, .string, .required)
                .field(AggregatorFeedModel.FieldKeys.v1.imageKey, .string)
                .field(AggregatorFeedModel.FieldKeys.v1.url, .string, .required)
                .unique(on: AggregatorFeedModel.FieldKeys.v1.url)
                .create()

            try await db.schema(AggregatorFeedItemModel.schema)
                .id()
                .field(AggregatorFeedItemModel.FieldKeys.v1.title, .string, .required)
                .field(AggregatorFeedItemModel.FieldKeys.v1.url, .string, .required)
                .field(AggregatorFeedItemModel.FieldKeys.v1.date, .date, .required)
                .field(AggregatorFeedItemModel.FieldKeys.v1.visibility, .string, .required)
                .field(AggregatorFeedItemModel.FieldKeys.v1.feedId, .uuid, .required)
                .foreignKey(AggregatorFeedItemModel.FieldKeys.v1.feedId, references: AggregatorFeedModel.schema, .id, onDelete: .cascade)
                .unique(on: AggregatorFeedItemModel.FieldKeys.v1.url, .id)
                .create()
        }
        
        func revert(on db: Database) async throws {
            try await db.schema(AggregatorFeedModel.schema).delete()
            try await db.schema(AggregatorFeedItemModel.schema).delete()
        }
    }
}
