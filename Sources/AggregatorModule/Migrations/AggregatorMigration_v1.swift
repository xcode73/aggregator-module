//
//  AggregatorMigration_v1_0_0.swift
//  AggregatorModule
//
//  Created by Tibor Bodecs on 2020. 01. 26..
//

import FeatherCore

struct AggregatorMigration_v1: Migration {
    
    func prepare(on db: Database) -> EventLoopFuture<Void> {
        db.eventLoop.flatten([
            db.schema(AggregatorFeedModel.schema)
                .id()
                .field(AggregatorFeedModel.FieldKeys.title, .string, .required)
                .field(AggregatorFeedModel.FieldKeys.imageKey, .string, .required)
                .field(AggregatorFeedModel.FieldKeys.url, .string, .required)
                .unique(on: AggregatorFeedModel.FieldKeys.url)
                .create(),

            db.schema(AggregatorFeedItemModel.schema)
                .id()
                .field(AggregatorFeedItemModel.FieldKeys.title, .string, .required)
                .field(AggregatorFeedItemModel.FieldKeys.url, .string, .required)
                .field(AggregatorFeedItemModel.FieldKeys.date, .date, .required)
                .field(AggregatorFeedItemModel.FieldKeys.visibility, .string, .required)
                .field(AggregatorFeedItemModel.FieldKeys.feedId, .uuid, .required)
                .foreignKey(AggregatorFeedItemModel.FieldKeys.feedId, references: AggregatorFeedModel.schema, .id, onDelete: .cascade)
                .unique(on: AggregatorFeedItemModel.FieldKeys.url, .id)
                .create(),
        ])
    }
    
    func revert(on db: Database) -> EventLoopFuture<Void> {
        db.eventLoop.flatten([
            db.schema(AggregatorFeedModel.schema).delete(),
            db.schema(AggregatorFeedItemModel.schema).delete(),
        ])
    }
}

