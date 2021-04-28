//
//  AggregatorFeedEditForm.swift
//  AggregatorModule
//
//  Created by Tibor Bodecs on 2020. 02. 16..
//

import FeatherCore

struct AggregatorFeedEditForm: FeatherForm {

    var context: FeatherFormContext<AggregatorFeedModel>
    
    init() {
        context = .init()
        context.form.fields = createFormFields()
    }

    private func createFormFields() -> [FormComponent] {
        [
            ImageField(key: "image", path: Model.assetPath)
                .read { ($1 as! ImageField).imageKey = context.model?.imageKey }
                .write { context.model?.imageKey = ($1 as! ImageField).imageKey ?? "" },
            
            TextField(key: "title")
                .config { $0.output.required = true }
                .validators { [
                    FormFieldValidator($1, "Title is required") { !$0.input.isEmpty },
                ] }
                .read { $1.output.value = context.model?.title }
                .write { context.model?.title = $1.input },
            
            TextField(key: "url")
                .config { $0.output.required = true }
                .validators { [
                    FormFieldValidator($1, "URL is required") { !$0.input.isEmpty },
                ] }
                .read { $1.output.value = context.model?.url }
                .write { context.model?.url = $1.input },
        ]
    }
}
