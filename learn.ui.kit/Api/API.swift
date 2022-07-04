//
//  API.swift
//  learn.ui.kit
//
//  Created by ghtk on 24/06/2022.
//

import Foundation
import Alamofire


//MARK: - Defines
enum APIError: Error {
    case error(String)
    case errorURL
    
    var localizedDescription: String {
        switch self {
        case .error(let string):
            return string
        case .errorURL:
            return "URL String is error."
        }
    }
}

typealias APICompletion<T> = (Result<T,AFError>) -> Void

enum APIResult {
    case success(Data?)
    case failure(APIError)
}


struct API {
    //singleton
    private static var shareAPI: API = {
        let shareAPI = API()
        return shareAPI
    }()
    
    static func shared() -> API {
        return shareAPI
    }
    
    //init
    private init() {
        print("Singletion init")
    }
}
