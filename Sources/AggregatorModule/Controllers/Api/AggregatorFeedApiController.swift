//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 12. 26..
//


extension Aggregator.Feed.List: Content {}
extension Aggregator.Feed.Detail: Content {}

struct AggregatorFeedApiController: ApiController {
    typealias ApiModel = Aggregator.Feed
    typealias DatabaseModel = AggregatorFeedModel

    func listOutput(_ req: Request, _ models: [DatabaseModel]) async throws -> [Aggregator.Feed.List] {
        models.map { model in
            .init(id: model.uuid,
                  imageKey: model.imageKey,
                  title: model.title,
                  url: model.url)
        }
    }
    
    func detailOutput(_ req: Request, _ model: DatabaseModel) async throws -> Aggregator.Feed.Detail {
        .init(id: model.uuid,
              imageKey: model.imageKey,
              title: model.title,
              url: model.url)
    }
    
    func createInput(_ req: Request, _ model: DatabaseModel, _ input: Aggregator.Feed.Create) async throws {
        model.imageKey = input.imageKey
        model.title = input.title
        model.url = input.url
    }
    
    func updateInput(_ req: Request, _ model: DatabaseModel, _ input: Aggregator.Feed.Update) async throws {
        model.imageKey = input.imageKey
        model.title = input.title
        model.url = input.url
    }
    
    func patchInput(_ req: Request, _ model: DatabaseModel, _ input: Aggregator.Feed.Patch) async throws {
        model.imageKey = input.imageKey ?? model.imageKey
        model.title = input.title ?? model.title
        model.url = input.url ?? model.url
    }
    
    func validators(optional: Bool) -> [AsyncValidator] {
        [
            KeyedContentValidator<String>.required("title", optional: optional),
            KeyedContentValidator<String>.required("url", optional: optional),
            KeyedContentValidator<String>("url", "Url must be unique", optional: optional) { req, value in
                try await DatabaseModel.isUnique(req, \.$url == value, Aggregator.Feed.getIdParameter(req))
            }
        ]
    }
    
}
