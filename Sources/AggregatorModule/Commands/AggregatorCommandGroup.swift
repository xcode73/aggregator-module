//
//  AggregatorCommandGroup.swift
//  AggregatorModule
//
//  Created by Tibor Bodecs on 2020. 01. 25..
//

import FeatherCore

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
