//
//  PinkViewController.swift
//  learn.ui.kit
//
//  Created by ghtk on 24/06/2022.
//

import UIKit

protocol PinkViewDelegate: AnyObject {
    func onLoginTapped(username: String?, email: String?) -> Void
}


class PinkViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var usernameTextFiled: UITextField!
    @IBOutlet weak var passwordTextFiled: UITextField!
    weak var delegate: PinkViewDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let username = UserDefaults.standard.string(forKey: "username")
        if let username = username {
            usernameTextFiled.text = username
        }
        title = "Login"
        let oldPassword = retrivePassword(for: username)
        if let oldPassword = oldPassword {
            passwordTextFiled.text = oldPassword
        }
    }

    @IBAction func onEditingEnd(_ sender: Any) {
//        print(emailTextField.text ?? "fasdfd")
    }
    @IBAction func onLoginTapped(_ sender: Any) {
        guard let username = usernameTextFiled.text,
              let email = emailTextField.text,
              let password = passwordTextFiled.text else {
            return
        }
        UserDefaults.standard.set(email, forKey: "email")
        UserDefaults.standard.set(username, forKey: "username")
        save(password, for: username)
//        UserDefaults.standard.set(["email" : emailTextField?.text,"username": usernameTextFiled?.text], forKey: "userData")
//        UserDefaults.standard.set(["a","b","c","d"], forKey: "alphabet")
        //get
//        let userName = UserDefaults.standard.string(forKey: "name")!
//        let alphabet = UserDefaults.standard.array(forKey: "alphabet") as! [String]
//        let strArrAlphabet = UserDefaults.standard.stringArray(forKey: "alphabet")!
//        print(userName)
//        print(userData)
//        print(alphabet)
//        print(strArrAlphabet)
        
        delegate?.onLoginTapped(username: usernameTextFiled.text, email: emailTextField.text)
        navigationController?.popViewController(animated: true)
    }
    
    func save(_ password: String, for account: String) {
        let password = password.data(using: String.Encoding.utf8)!
        let query: [String: Any] = [kSecClass as String: kSecClassGenericPassword,
                                    kSecAttrAccount as String: account,
                                    kSecValueData as String: password]
        let status = SecItemAdd(query as CFDictionary, nil)
        guard status == errSecSuccess else { return print("save error")
        }
        
    }
    
    //keychain
    func save1(_ password: String, for account: String) {
        let password = password.data(using: String.Encoding.utf8)!
        let query: [String: Any] = [kSecClass as String: kSecClassGenericPassword,
                                    kSecAttrAccount as String: account,
                                    kSecValueData as String: password]
        let status = SecItemAdd(query as CFDictionary, nil)
        guard status == errSecSuccess else { return print("save error")}
        
    }
    
    func retrivePassword(for account: String?) -> String? {
        guard let account = account else {
            return nil
        }

        let query: [String: Any] = [kSecClass as String: kSecClassGenericPassword,
                                    kSecAttrAccount as String: account,
                                    kSecReturnData as String: kCFBooleanTrue!]
        
        
        var retrivedData: AnyObject? = nil
        let _ = SecItemCopyMatching(query as CFDictionary, &retrivedData)
        
        
        guard let data = retrivedData as? Data else {return nil}
        return String(data: data, encoding: String.Encoding.utf8)
    }

}
