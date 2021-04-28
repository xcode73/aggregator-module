//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 04. 28..
//

import Foundation

public struct FeedPatchObject: Codable {

    public var imageKey: String?
    public var title: String?
    public var url: String?
    
    
    public init(imageKey: String? = nil,
                title: String? = nil,
                url: String? = nil)
    {
        self.imageKey = imageKey
        self.title = title
        self.url = url
    }

}
