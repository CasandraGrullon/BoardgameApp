//
//  ViewController.swift
//  BoardgameApp
//
//  Created by casandra grullon on 4/27/20.
//  Copyright © 2020 casandra grullon. All rights reserved.
//

import UIKit
import FirebaseAuth

enum AccountState {
    case existingUser
    case newUser
}

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signUpHereButton: UIButton!
    @IBOutlet weak var promptLabel: UILabel!
    
    private var accountState: AccountState = .existingUser
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func loginButtonPressed(_ sender: UIButton) {
        guard let email = emailTextfield.text, !email.isEmpty,
            let password = passwordTextfield.text, !password.isEmpty else {
                DispatchQueue.main.async {
                    self.showAlert(title: "Missing Fields", message: "Email and Password are required")
                }
                return
        }
        continueLoginFlow(email: email, password: password)
    }
    private func continueLoginFlow(email: String, password: String) {
        if accountState == .existingUser {
            AuthenticationSession.shared.signInExistingUser(email: email, password: password) { [weak self] (result) in
                switch result {
                case .failure(let error):
                    DispatchQueue.main.async {
                        self?.showAlert(title: "Login Error", message: "Unable to login at this time error: \(error.localizedDescription)")
                    }
                case .success:
                    DispatchQueue.main.async {
                        self?.navigateToMainApp()
                    }
                }
            }
        } else {
            AuthenticationSession.shared.createNewUser(email: email, password: password) { [weak self] (result) in
                switch result {
                case .failure(let error):
                    DispatchQueue.main.async {
                        self?.showAlert(title: "Sign Up Error", message: "Unable to sign up at this time error: \(error.localizedDescription)")
                    }
                case .success:
                    DispatchQueue.main.async {
                        self?.navigateToMainApp()
                    }
                }
            }
        }
    }
    private func navigateToMainApp() {
        UIViewController.showViewController(storyboardName: "MainAppStoryboard", viewcontrollerID: "MainAppTabBarViewController")
    }
    private func createUser(authDataResult: AuthDataResult) {
        //database service
    }
    
    @IBAction func signUpHereButtonPressed(_ sender: UIButton) {
        accountState = accountState == .existingUser ? .newUser : .existingUser
        if accountState == .existingUser {
            loginButton.titleLabel?.text = "Login"
            promptLabel.text = "Don't have an account?"
            signUpHereButton.titleLabel?.text = "Sign Up Here"
        } else {
            loginButton.titleLabel?.text = "Sign Up"
            promptLabel.text = "Already have an account?"
            signUpHereButton.titleLabel?.text = "Login Here"
        }
        
    }
    
}

