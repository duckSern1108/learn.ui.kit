//
//  Router.swift
//  learn.ui.kit
//
//  Created by ghtk on 27/06/2022.
//

import Foundation
import Alamofire
import ObjectMapper

typealias RequestParam = [String:String]

enum Router: URLRequestConvertible {
    case get(String,RequestParam?), post(String,RequestParam?)
    
    var baseURL: URL {
        return URL(string: "https://rss.applemarketingtools.com/api/v2/us")!
    }
    
    var method: HTTPMethod {
        switch self {
        case .get: return .get
        case .post: return .post
        }
    }
    
    func generateURLRequest(p: String) -> URLRequest {
        let url = baseURL.appendingPathComponent(p)
        var request = URLRequest(url: url)
        request.method = method
        return request
    }
    
    
    func asURLRequest() throws -> URLRequest {
        
        var request: URLRequest
        switch self {
        case let .get(path,parameters):
            request = self.generateURLRequest(p: path)
            request = try URLEncodedFormParameterEncoder().encode(parameters, into: request)
            
        case let .post(path,parameters):
            request = self.generateURLRequest(p: path)
            request = try JSONParameterEncoder().encode(parameters, into: request)
        }
        
        return request
    }
}

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


class ApiMain {
    static func get(path: String = "", completion:@escaping (AFDataResponse<String>) -> Void) {
        AF.request(Router.get(path,nil)).responseString(completionHandler: completion)
    }
}

class APIMusic:ApiMain {
    static var path = "/music"
    static var hotMusicPath = "/most-played"
    static func getHotMusic(limit: Int,completion: @escaping APICompletion<HotMusicReponse>) {
        get(path: APIMusic.path + APIMusic.hotMusicPath + "/\(limit)/albums.json") {
            switch $0.result {
            case .success(let data):
                let result = Mapper<HotMusicReponse>().map(JSONString: data)!
                completion(.success(result))
            case .failure(let error):                
                completion(.failure(error))
            }
        }
    }
}

