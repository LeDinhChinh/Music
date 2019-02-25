//
//  DataLocal.swift
//  Music
//
//  Created by Admin on 2/25/19.
//  Copyright © 2019 Admin. All rights reserved.
//

import Foundation
import UIKit
import FMDB
public let TABLE_NAME = "Favorite"
public let URL_IMAGE = "URL_IMAGE"
public let GENRE = "GENRE"
public let TITLES = "TITLES"
public let URI = "URI"
public let NAMEARTIST = "NAMEARTIST"

open class DataLocal {
    class func insertRecore(_ artWork_url: String,_ genre: String,_ titles: String,_ uri: String,_ nameArtist: String) {
        var check: Bool = false
        let database: FMDatabase = FMDatabase.init(path: AppDelegate.sharedInstance.databasePath)
        if !database.open() {
            print(check)
            return
        }
        
        let query: String = String.init(format: "INSERT OR REPLACE INTO %@ (%@,%@,%@,%@,%@) VALUES ('%@','%@','%@','%@','%@')", TABLE_NAME, URL_IMAGE, GENRE, TITLES, URI, NAMEARTIST, artWork_url, genre, titles, uri, nameArtist)
        check = database.executeStatements(query)
        database.close()
        print(check)
    }
    
    class func getDataFavoriteTrack() -> [FavoriteTracks] {
        var arrFavoriteTracks = [FavoriteTracks]()
        let database: FMDatabase = FMDatabase.init(path: AppDelegate.sharedInstance.databasePath)
        if !database.open() {
            return arrFavoriteTracks
        }
        
        do {
            let query: String = String.init(format: "SELECT * FROM %@", TABLE_NAME)
            let result: FMResultSet = try database.executeQuery(query, values: nil)
            while result.next() {
                guard let url_image = result.string(forColumn: URL_IMAGE),
                    let genre = result.string(forColumn: GENRE),
                    let titles = result.string(forColumn: TITLES),
                    let uri = result.string(forColumn: URI),
                    let nameArtist = result.string(forColumn: NAMEARTIST) else {
                    print("Error")
                    return arrFavoriteTracks
                }
                let favoriteTrack = FavoriteTracks(url_image: url_image, genre: genre, titles: titles, uri: uri, nameArtist: nameArtist)
                arrFavoriteTracks.append(favoriteTrack)
            }
        } catch {
            print("Error")
        }
        database.close()
        return arrFavoriteTracks
    }
    
    class func removeData(uri: String) {
        var check: Bool = false
        let db: FMDatabase = FMDatabase.init(path: AppDelegate.sharedInstance.databasePath)
        if db.open() {
            let query: String = String.init(format: "DELETE FROM %@ WHERE %@ = ('%@')", TABLE_NAME, URI, uri)
            check = db.executeUpdate(query, withArgumentsIn: [])
            db.close()
            return
        }
        print(check)
    }
}
