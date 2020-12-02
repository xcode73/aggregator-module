//
//  AggregatorFeedAdminController.swift
//  AggregatorModule
//
//  Created by Tibor Bodecs on 2020. 03. 27..
//

import FeatherCore

struct AggregatorFeedAdminController: ViperAdminViewController {

    typealias Module = AggregatorModule
    typealias Model = AggregatorFeedModel
    typealias EditForm = AggregatorFeedEditForm
    
    var listAllowedOrders: [FieldKey] = [
        Model.FieldKeys.title,
    ]
    
    private func path(_ model: Model) -> String {
        Model.path + model.id!.uuidString + ".jpg"
    }
    
    func beforeCreate(req: Request, model: Model, form: EditForm) -> EventLoopFuture<Model> {
        model.id = UUID()
        guard let data = form.image.data else {
            return req.eventLoop.future(model)
        }
        let key = path(model)
        return req.fs.upload(key: key, data: data).map { url in
            model.imageKey = key
            return model
        }
    }

    func beforeUpdate(req: Request, model: Model, form: EditForm) -> EventLoopFuture<Model> {
        guard let data = form.image.data else {
            return req.eventLoop.future(model)
        }
        let key = path(model)
        return req.fs.delete(key: key).flatMap { _ in
            return req.fs.upload(key: key, data: data).map { url in
                model.imageKey = key
                return model
            }
        }
    }

    func beforeDelete(req: Request, model: Model) -> EventLoopFuture<Model> {
        req.fs.delete(key: model.imageKey).map { model }
    }
}
