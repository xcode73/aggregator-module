//
//  AggregatorFeedEditForm.swift
//  AggregatorModule
//
//  Created by Tibor Bodecs on 2020. 02. 16..
//

import FeatherCore

final class AggregatorFeedEditForm: ModelForm {

    typealias Model = AggregatorFeedModel

    var modelId: UUID?
    var title = FormField<String>(key: "title").required().length(max: 250)
    var url = FormField<String>(key: "url").required().length(max: 250)
    var image = FileFormField(key: "image").required()
    var notification: String?
    
    var fields: [FormFieldRepresentable] {
        [title, url, image]
    }

    init() { }

    func processAfterFields(req: Request) -> EventLoopFuture<Void> {
        image.uploadTemporaryFile(req: req)
    }

    func read(from input: Model)  {
        modelId = input.id
        title.value = input.title
        url.value = input.url
        image.value.originalKey = input.imageKey
    }

    func write(to output: Model) {
        output.title = title.value!
        output.url = url.value!
    }
    
    func willSave(req: Request, model: Model) -> EventLoopFuture<Void> {
        image.save(to: Model.path, req: req).map {
            if let key = $0 {
                model.imageKey = key
            }
        }
    }

}
