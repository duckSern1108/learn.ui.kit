//
//  PromiseRouter.swift
//  learn.ui.kit
//
//  Created by ghtk on 04/07/2022.
//

import Foundation
import PromiseKit
import ObjectMapper

class PromiseRouter {
    static func promiseGetHotMusic() -> Promise<HotMusicReponse> {
        return Promise<HotMusicReponse> { seal in
            ApiMain.get(path: APIMusic.path + APIMusic.hotMusicPath + "/\(4)/albums.json") {
                switch $0.result {
                case .success(let data):
                    let result = Mapper<HotMusicReponse>().map(JSONString: data)!
                    seal.fulfill(result)
                case .failure(let error):
                    seal.reject(error)
                }
            }
            
        }
    }
}
