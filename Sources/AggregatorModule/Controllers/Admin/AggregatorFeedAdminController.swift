//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 12. 26..
//

struct AggregatorFeedAdminController: AdminController {
    typealias ApiModel = Aggregator.Feed
    typealias DatabaseModel = AggregatorFeedModel
    
    typealias CreateModelEditor = AggregatorFeedEditor
    typealias UpdateModelEditor = AggregatorFeedEditor
    
    
    var listConfig: ListConfiguration {
        .init(allowedOrders: [
            "title",
            "url",
        ])
    }
    
    func listSearch(_ term: String) -> [ModelValueFilter<DatabaseModel>] {
        [
            \.$title ~~ term,
            \.$url ~~ term,
        ]
    }
    
    func listColumns() -> [ColumnContext] {
        [
            .init("title"),
            .init("url"),
        ]
    }
    
    func listCells(for model: DatabaseModel) -> [CellContext] {
        [
            .init(model.title, link: LinkContext(label: model.title, permission: ApiModel.permission(for: .detail).key)),
            .init(model.url, link: LinkContext(label: model.url, permission: ApiModel.permission(for: .detail).key)),
        ]
    }
    
    func detailFields(for model: DatabaseModel) -> [FieldContext] {
        [
            .init("id", model.uuid.string),
            .init("title", model.title),
            .init("url", model.url),
        ]
    }
    
    func beforeDelete(_ req: Request, _ model: DatabaseModel) async throws {
        try await model.$items.query(on: req.db).delete()
    }
    
    func afterDelete(_ req: Request, _ model: DatabaseModel) async throws {
        if let key = model.imageKey {
            try await req.fs.delete(key: key)
        }
    }
    
    func deleteInfo(_ model: DatabaseModel) -> String {
        model.title
    }
    
    
//    func detailNavigation(_ req: Request, _ model: DatabaseModel) -> [LinkContext] {
//        [
//            LinkContext(label: "Update",
//                        path: "update",
//                        permission: Blog.Author.permission(for: .update).key),
//            LinkContext(label: BlogAuthorLinkAdminController.modelName.plural,
//                        path: Blog.Author.pathKey,
//                        permission: Blog.Author.permission(for: .list).key),
//        ]
//    }
//
//    func updateNavigation(_ req: Request, _ model: DatabaseModel) -> [LinkContext] {
//        [
//            LinkContext(label: "Details",
//                        dropLast: 1,
//                        permission: Blog.Author.permission(for: .detail).key),
//
//            LinkContext(label: BlogAuthorLinkAdminController.modelName.plural,
//                        path: Blog.AuthorLink.pathKey,
//                        dropLast: 1,
//                        permission: Blog.AuthorLink.permission(for: .list).key),
//        ]
//    }
}
