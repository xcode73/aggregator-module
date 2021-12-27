//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 12. 26..
//

public extension Aggregator {
    
    enum Feed: FeatherApiModel {
        public typealias Module = Aggregator
    }
}

public extension Aggregator.Feed {
    
    // MARK: -
    
    struct List: Codable {
        public var id: UUID
        public var imageKey: String?
        public var title: String
        public var url: String
        
        public init(id: UUID,
                    imageKey: String?,
                    title: String,
                    url: String) {
            self.id = id
            self.imageKey = imageKey
            self.title = title
            self.url = url
        }
    }
    
    // MARK: -
    
    struct Detail: Codable {
        public var id: UUID
        public var imageKey: String?
        public var title: String
        public var url: String
        
        public init(id: UUID,
                    imageKey: String?,
                    title: String,
                    url: String) {
            self.id = id
            self.imageKey = imageKey
            self.title = title
            self.url = url
        }
    }
    
    // MARK: -
    
    struct Create: Codable {
        public var imageKey: String?
        public var title: String
        public var url: String
        
        
        public init(imageKey: String?,
                    title: String,
                    url: String) {
            self.imageKey = imageKey
            self.title = title
            self.url = url
        }
    }
    
    // MARK: -
    
    struct Update: Codable {
        public var imageKey: String?
        public var title: String
        public var url: String
        
        public init(imageKey: String?,
                    title: String,
                    url: String) {
            self.imageKey = imageKey
            self.title = title
            self.url = url
        }
    }
    
    // MARK: -
    
    struct Patch: Codable {
        public var imageKey: String?
        public var title: String?
        public var url: String?
        
        public init(imageKey: String? = nil,
                    title: String? = nil,
                    url: String? = nil) {
            self.imageKey = imageKey
            self.title = title
            self.url = url
        }
    }
}

