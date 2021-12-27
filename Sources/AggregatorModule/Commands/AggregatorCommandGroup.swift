//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 12. 27..
//

struct AggregatorCommandGroup: CommandGroup {

    let commands: [String: AnyCommand]
    let help: String
    
    var defaultCommand: AnyCommand? {
        self.commands[AggregatorFetchCommand.name]
    }
    
    init() {
        self.help = "Aggregator command group help"

        self.commands = [
            AggregatorFetchCommand.name: AggregatorFetchCommand(),
        ]
    }
}
