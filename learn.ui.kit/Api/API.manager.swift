//
//  API.manager.swift
//  learn.ui.kit
//
//  Created by ghtk on 24/06/2022.
//

import Foundation
import Alamofire
import ObjectMapper

struct APIManager {
    //MARK: Config
    struct Path {
        
    }
    
    //MARK: - Domain
    struct Music {}
    
    struct Downloader {}
}

extension APIManager.Path {
    
            static let base_domain = "https://rss.applemarketingtools.com"
            static let base_path = "/api/v2/us"
            
            static let music_path = "/music"
            static let music_hot = "/most-played"
    
}


extension APIManager.Music {
    struct QueryString {
        func hotMusic(limit: Int) -> String {
            let url = APIManager.Path.base_domain +
            APIManager.Path.base_path +
            APIManager.Path.music_path +
            APIManager.Path.music_hot +
            "/\(limit)/albums.json"
            return url
        }
    }
    
    struct QueryParam {
    }
    
//    struct MusicResult {
//        var musics: [Music]
//        var copyright: String
//        var updated: String
//    }
    
    static func getHotMusic(limit: Int = 10, completion: @escaping APICompletion<HotMusicReponse>) {
        let urlString = QueryString().hotMusic(limit: limit)
                AF.request(urlString).responseString { response in
                    switch response.result {
                    case .success(let data):                        
                        let result = Mapper<HotMusicReponse>().map(JSONString: data)                        
                        completion(.success(result!))
                    case .failure(let error):
                        print("error",error.destinationURL)
                    default:
                        break
                    }
                    
                }

               
//               API.shared().request(urlString: urlString) { (result) in
//                   switch result {
//                   case .failure(let error):
//                       //call back
//                       completion(.failure(error))
//
//                   case .success(let data):
//                       if let data = data {
//                           //parse data
//                           // code sau
//                           //call back
//                           //code sau
//                           let json = data.toJSON()
//                           let feed = json["feed"] as! JSON
//                           let results = feed["results"] as! [JSON]
//
//                          // musics
//                          var musics: [Music] = []
//                          for item in results {
//                              let music = Music(json: item)
//                              musics.append(music)
//                          }
//
//                          //informations
//                          let copyright = "....."
//                          let updated = "....."
//
//                          // result
//                          let musicResult = MusicResult(musics: musics, copyright: copyright, updated: updated)
//
//                          //call back
//                          completion(.success(musicResult))
//
//                       } else {
//                           //call back
//                           completion(.failure(.error("Data is not format.")))
//                       }
//                   }
//               }
    }
}
