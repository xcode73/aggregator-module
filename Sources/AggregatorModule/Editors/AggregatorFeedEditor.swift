//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 12. 26..
//

struct AggregatorFeedEditor: FeatherModelEditor {
    let model: AggregatorFeedModel
    let form: AbstractForm

    init(model: AggregatorFeedModel, form: AbstractForm) {
        self.model = model
        self.form = form
    }

    @FormFieldBuilder
    func createFields(_ req: Request) -> [FormField] {
        // @TODO: use path variable
        ImageField("image", path: "aggregator/feed")
            .read {
                if let key = model.imageKey {
                    $1.output.context.previewUrl = $0.fs.resolve(key: key)
                }
                ($1 as! ImageField).imageKey = model.imageKey
            }
            .write { model.imageKey = ($1 as! ImageField).imageKey }
        
        InputField("title")
            .read { $1.output.context.value = model.title }
            .write { model.title = $1.input }
        
        InputField("url")
            .config {
                $0.output.context.label.required = true
            }
            .validators {
                FormFieldValidator.required($1)
            }
            .read { $1.output.context.value = model.url }
            .write { model.url = $1.input }   
    }
}

