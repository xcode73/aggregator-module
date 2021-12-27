//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 12. 27..
//

@_cdecl("createAggregatorModule")
public func createAggregatorModule() -> UnsafeMutableRawPointer {
    return Unmanaged.passRetained(AggregatorBuilder()).toOpaque()
}

public final class AggregatorBuilder: FeatherModuleBuilder {

    public override func build() -> FeatherModule {
        AggregatorModule()
    }
}
