//
//  AggregatorFeedEditForm.swift
//  AggregatorModule
//
//  Created by Tibor Bodecs on 2020. 02. 16..
//

import FeatherCore

final class AggregatorFeedEditForm: ModelForm {

    typealias Model = AggregatorFeedModel

    struct Input: Decodable {
        var modelId: String
        var title: String
        var url: String
        var image: File?
    }

    var modelId: String? = nil
    var title = StringFormField()
    var url = StringFormField()
    var image = FileFormField()
    var notification: String?

    var leafData: LeafData {
        .dictionary([
            "modelId": modelId,
            "title": title,
            "url": url,
            "image": image,
            "notification": notification,
        ])
    }

    init() { }

    init(req: Request) throws {
        let context = try req.content.decode(Input.self)
        modelId = context.modelId.emptyToNil
        title.value = context.title
        url.value = context.url
        if let img = context.image, let data = img.data.getData(at: 0, length: img.data.readableBytes), !data.isEmpty {
            image.data = data
        }
    }
    
    func validate(req: Request) -> EventLoopFuture<Bool> {
        var valid = true

        if title.value.isEmpty {
            title.error = "Title is required"
            valid = false
        }
        if url.value.isEmpty {
            url.error = "URL is required"
            valid = false
        }
        if modelId == nil && image.data == nil {
            image.error = "Image is required"
            valid = false
        }

        return req.eventLoop.future(valid)
    }
    
    func read(from input: Model)  {
        modelId = input.id!.uuidString
        title.value = input.title
        url.value = input.url
        image.value = input.imageKey
    }

    func write(to output: Model) {
        output.title = title.value
        output.url = url.value
        if !image.value.isEmpty {
            output.imageKey = image.value
        }
    }

}
