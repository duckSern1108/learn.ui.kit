//
//  ApiResponse.swift
//  learn.ui.kit
//
//  Created by ghtk on 22/07/2022.
//

import Foundation
import ObjectMapper

struct HotMusicReponse: Mappable {
    var musics : [Music] = []
    var title = ""
    init?(map: Map) {
    musics = []
    }
    mutating func mapping(map: Map) {
        musics <- map["feed.results"]
        title <- map["feed.title"]
    }
}
