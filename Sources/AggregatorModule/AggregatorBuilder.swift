//
//  AggregatorBuilder.swift
//  AggregatorModule
//
//  Created by Tibor Bodecs on 2020. 08. 23..
//
import FeatherCore

@_cdecl("createAggregatorModule")
public func createAggregatorModule() -> UnsafeMutableRawPointer {
    return Unmanaged.passRetained(AggregatorBuilder()).toOpaque()
}

public final class AggregatorBuilder: FeatherModuleBuilder {

    public override func build() -> FeatherModule {
        AggregatorModule()
    }
}
