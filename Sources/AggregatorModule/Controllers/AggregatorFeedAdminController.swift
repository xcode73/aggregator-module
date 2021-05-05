//
//  AggregatorFeedAdminController.swift
//  AggregatorModule
//
//  Created by Tibor Bodecs on 2020. 03. 27..
//

import FeatherCore

struct AggregatorFeedAdminController: FeatherController {

    typealias Module = AggregatorModule
    typealias Model = AggregatorFeedModel

    typealias CreateForm = AggregatorFeedEditForm
    typealias UpdateForm = AggregatorFeedEditForm
    
    typealias GetApi = AggregatorFeedApi
    typealias ListApi = AggregatorFeedApi
    typealias CreateApi = AggregatorFeedApi
    typealias UpdateApi = AggregatorFeedApi
    typealias PatchApi = AggregatorFeedApi
    typealias DeleteApi = AggregatorFeedApi

    func listTable(_ models: [Model]) -> Table {
        Table(columns: ["title", "url"], rows: models.map { model in
            TableRow(id: model.identifier, cells: [TableCell(model.title), TableCell(model.url)])
        })
    }
    
    func listContext(req: Request, table: Table, pages: Pagination) -> ListContext {
        .init(info: Model.info(req), table: table, pages: pages)
    }
    
    func detailFields(req: Request, model: Model) -> [DetailContext.Field] {
        [
            .init(label: "Id", value: model.identifier),
            .init(type: .image, label: "Image", value: model.imageKey),
            .init(label: "Title", value: model.title),
            .init(label: "Url", value: model.url),
        ]
    }

    func deleteContext(req: Request, model: Model) -> String {
        model.title
    }
    
    func beforeDelete(req: Request, model: Model) -> EventLoopFuture<Model> {
        req.fs.delete(key: model.imageKey).map { model }
    }
}
