//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 04. 28..
//

import FeatherCore
import AggregatorModuleApi

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
        .init(id: model.id!, imageKey: model.imageKey, title: model.title, url: model.url)
    }
    
    func mapGet(model: Model) -> GetObject {
        .init(id: model.id!, imageKey: model.imageKey, title: model.title, url: model.url)
    }
    
    func mapCreate(_ req: Request, model: Model, input: CreateObject) -> EventLoopFuture<Void> {
        return req.eventLoop.future()
    }

    func mapUpdate(_ req: Request, model: Model, input: UpdateObject) -> EventLoopFuture<Void> {
        return req.eventLoop.future()
    }

    func mapPatch(_ req: Request, model: Model, input: PatchObject) -> EventLoopFuture<Void> {
        return req.eventLoop.future()
    }
    
    func validateCreate(_ req: Request) -> EventLoopFuture<Bool> {
        req.eventLoop.future(true)
    }
    
    func validateUpdate(_ req: Request) -> EventLoopFuture<Bool> {
        req.eventLoop.future(true)
    }
    
    func validatePatch(_ req: Request) -> EventLoopFuture<Bool> {
        req.eventLoop.future(true)
    }
}
