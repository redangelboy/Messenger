//
//  ViewController.swift
//  Messanger
//
//  Created by Cesar on 12/1/22.
//

import UIKit
//import FirebaseCore
//import FirebaseAuth
import Firebase


class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!

    
    @IBAction func buttPressed(_ sender: UIButton) {

        if let email = emailTextField.text?.lowercased(), let password = passwordTextField.text?.lowercased() {
            Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
                if let e = error {
                    print("error signing in")
                } else {
                    print("success signing in")
                    self.performSegue(withIdentifier: "chatWindow", sender: self)
                }
            }
        }
    }
    
    
    
}
