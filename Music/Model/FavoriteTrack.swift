//
//  FavoriteTrack.swift
//  Music
//
//  Created by Admin on 2/25/19.
//  Copyright © 2019 Admin. All rights reserved.
//

import Foundation
struct FavoriteTracks {
    var url_image = ""
    var genre = ""
    var titles = ""
    var uri = ""
    var nameArtist = ""
    
    init(url_image: String, genre: String, titles: String, uri: String, nameArtist: String) {
        self.url_image = url_image
        self.genre = genre
        self.titles = titles
        self.uri = uri
        self.nameArtist = nameArtist
    }
}
