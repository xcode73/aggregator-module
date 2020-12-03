//
//  AggregatorFeedItemAdminController.swift
//  AggregatorModule
//
//  Created by Tibor Bodecs on 2020. 03. 27..
//

import FeatherCore
import Fluent

struct AggregatorFeedItemAdminController: ListViewController {
    
    typealias Module = AggregatorModule
    typealias Model = AggregatorFeedItemModel

    var listView: String = "Aggregator/Admin/Items/List"

    var idParamKey: String { "itemId" }
    var idPathComponent: PathComponent { .init(stringLiteral: ":" + idParamKey) }
    
    func searchList(using qb: QueryBuilder<Model>, for searchTerm: String) {
        qb.filter(\.$title ~~ searchTerm)
    }
    
    func beforeList(req: Request, queryBuilder: QueryBuilder<Model>) throws -> QueryBuilder<Model> {
        guard let feedId = req.parameters.get("id"), let uuid = UUID(uuidString: feedId) else {
            throw Abort(.badRequest)
        }
        return queryBuilder
            .filter(\.$feed.$id == uuid)
            .sort(\.$date, .descending)
    }

    ///NOTE: form validation with csrf token?
    func toggle(req: Request) throws -> EventLoopFuture<Response> {
        guard let id = req.parameters.get(idParamKey), let uuid = UUID(uuidString: id) else {
            throw Abort(.badRequest)
        }
        return AggregatorFeedItemModel
            .find(uuid, on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap { item -> EventLoopFuture<Void> in
                item.visibility.toggle()
                return item.save(on: req.db)
            }
            .map { req.redirect(to: req.url.path.trimmingLastPathComponents(2)) }
    }
}
