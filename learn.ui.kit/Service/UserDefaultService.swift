//
//  UserDefaultService.swift
//  learn.ui.kit
//
//  Created by ghtk on 22/07/2022.
//

import Foundation

class UserDefaultService {
    static func saveUserInfo(email: String, username: String) {
        UserDefaults.standard.set(email, forKey: "email")
        UserDefaults.standard.set(username, forKey: "username")
    }
    static func getUserInfo() -> (email: String?,username: String?) {
        let username = UserDefaults.standard.string(forKey: "username")
        let email = UserDefaults.standard.string(forKey: "email")
        return (email: email, username: username)
    }
}
