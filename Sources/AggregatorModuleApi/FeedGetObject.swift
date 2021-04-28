//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 04. 28..
//

import Foundation

public struct FeedGetObject: Codable {

    public var id: UUID
    public var imageKey: String?
    public var title: String
    public var url: String
    
    
    public init(id: UUID,
                imageKey: String?,
                title: String,
                url: String)
    {
        self.id = id
        self.imageKey = imageKey
        self.title = title
        self.url = url
    }

}
