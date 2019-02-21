//
//  InformationTracks.swift
//  Music
//
//  Created by Admin on 2/19/19.
//  Copyright © 2019 Admin. All rights reserved.
//

import Foundation
import ObjectMapper

struct TracksResponse: Mappable {
    var collection = [InfoTrack]()
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        collection <- map["collection"]
    }
}

struct InfoTrack: Mappable {
    var track: Track?
    var score = 0
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        track <- map["track"]
        score <- map["score"]
    }
}

struct Track: Mappable {
    var artwork_url = ""
    var genre = ""
    var title = ""
    var uri = ""
    var user: User?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        artwork_url <- map["artwork_url"]
        genre <- map["genre"]
        title <- map["title"]
        user <- map["user"]
        uri <- map["uri"]
    }
}

struct User: Mappable {
    var full_name = ""
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        full_name <- map["full_name"]
    }
}

struct Errors: Mappable {
    var errors = [Error_message]()
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        errors <- map["errors"]
    }
}

struct Error_message: Mappable {
    var error_message = ""
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        error_message <- map["error_message"]
    }
}
