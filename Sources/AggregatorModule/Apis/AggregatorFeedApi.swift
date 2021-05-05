//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 04. 28..
//

import FeatherCore
import AggregatorApi

extension FeedListObject: Content {}
extension FeedGetObject: Content {}
extension FeedCreateObject: Content {}
extension FeedUpdateObject: Content {}
extension FeedPatchObject: Content {}

struct AggregatorFeedApi: FeatherApiRepresentable {
    typealias Model = AggregatorFeedModel
    
    typealias ListObject = FeedListObject
    typealias GetObject = FeedGetObject
    typealias CreateObject = FeedCreateObject
    typealias UpdateObject = FeedUpdateObject
    typealias PatchObject = FeedPatchObject
    
    func mapList(model: Model) -> ListObject {
        .init(id: model.id!,
              imageKey: model.imageKey,
              title: model.title,
              url: model.url)
    }
    
    func mapGet(model: Model) -> GetObject {
        .init(id: model.id!,
              imageKey: model.imageKey,
              title: model.title,
              url: model.url)
    }
    
    func mapCreate(_ req: Request, model: Model, input: CreateObject) -> EventLoopFuture<Void> {
        model.imageKey = input.imageKey
        model.title = input.title
        model.url = input.url
        return req.eventLoop.future()
    }

    func mapUpdate(_ req: Request, model: Model, input: UpdateObject) -> EventLoopFuture<Void> {
        model.imageKey = input.imageKey
        model.title = input.title
        model.url = input.url
        return req.eventLoop.future()
    }

    func mapPatch(_ req: Request, model: Model, input: PatchObject) -> EventLoopFuture<Void> {
        model.imageKey = input.imageKey ?? model.imageKey
        model.title = input.title ?? model.title
        model.url = input.url ?? model.url
        return req.eventLoop.future()
    }
    
    func validators(optional: Bool) -> [AsyncValidator] {
        [
            KeyedContentValidator<String>.required("imageKey", optional: optional),
            KeyedContentValidator<String>.required("title", optional: optional),
            KeyedContentValidator<String>.required("url", optional: optional),
            KeyedContentValidator<String>("url", "Url must be unique", optional: optional, nil) { value, req in
                Model.isUniqueBy(\.$url == value, req: req)
            }
        ]
    }
}
