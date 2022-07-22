//
//  Music.swift
//  learn.ui.kit
//
//  Created by ghtk on 24/06/2022.
//

import Foundation
import ObjectMapper

final class Music: Mappable {
    var id: String
    var artistName: String
    var releaseDate: String
    var name: String
    var artworkUrl100: String
    var genres: [MusicGenre] = []
    
    required init?(map: Map) {
        self.id = map.JSON["id"] as! String
        self.artistName = map.JSON["artistName"] as! String
        self.releaseDate = map.JSON["releaseDate"] as! String
        self.name = map.JSON["name"] as! String
        self.artworkUrl100 = map.JSON["artworkUrl100"] as! String
       }
    
    func mapping(map: Map) {
        id <- map["id"]
        artistName <- map["artistName"]
        name <-  map["name"]
        artworkUrl100 <- map["artworkUrl100"]
        releaseDate <- map["releaseDate"]
        genres <- map["genres"]
    }
    
    var genresLabel:String {
        genres.map { $0.name }.joined(separator: ", ")
    }
}

class MusicGenre: Mappable {
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        id <- map["genreId"]
        name <- map["name"]
    }
    
    var name:String = ""
    var id:String = ""
}

class MusicDecodable: Codable {
    var id: String
    var artistName: String
    var releaseDate: String
    var name: String
    var artworkUrl100: String
    
    init(id:String,artistName:String,releaseDate:String,name:String,artworkUrl100:String) {
        self.id = id
        self.artistName = artistName
        self.releaseDate = releaseDate
        self.name = name
        self.artworkUrl100 = artworkUrl100
    }
}
