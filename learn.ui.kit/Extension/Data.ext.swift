//
//  Data.ext.swift
//  learn.ui.kit
//
//  Created by ghtk on 24/06/2022.
//

import Foundation

typealias JSON = [String: Any]

extension Data {
    func toJSON() -> JSON {
        var json: [String: Any] = [:]
        do {
            if let jsonObj = try JSONSerialization.jsonObject(with: self, options: []) as? JSON {
                json = jsonObj
            }
        } catch let error as NSError {
            print("Failed to load: \(error.localizedDescription)")
        }
        return json
    }
}
