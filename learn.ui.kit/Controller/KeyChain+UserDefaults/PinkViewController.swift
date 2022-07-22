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
        let userInfo = UserDefaultService.getUserInfo()
        if let username = userInfo.username {
            usernameTextFiled.text = username
        }
        title = "Login"
        let oldPassword = KeyChainPasswordService.retrive(for: userInfo.username)
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
        KeyChainPasswordService.save(password, for: username)
        UserDefaultService.saveUserInfo(email: email, username: username)
        delegate?.onLoginTapped(username: usernameTextFiled.text, email: emailTextField.text)
        navigationController?.popViewController(animated: true)
    }
    
    
    
    //keychain
    

}
