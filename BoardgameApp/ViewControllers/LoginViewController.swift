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
        emailTextfield.delegate = self
        passwordTextfield.delegate = self
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
    
    
    @IBAction func signUpHereButtonPressed(_ sender: UIButton) {
        accountState = accountState == .existingUser ? .newUser : .existingUser
        if accountState == .existingUser {
            loginButton.setTitle("Login", for: .normal)
            promptLabel.text = "Don't have an account?"
            signUpHereButton.setTitle("Sign up here", for: .normal)
        } else {
            loginButton.setTitle("Create Account", for: .normal)
            promptLabel.text = "Already have an account?"
            signUpHereButton.setTitle("Login here", for: .normal)
        }
        
    }
    
}

extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension LoginViewController { //login and sign up functions
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
                case .success(let authDataResult):
                    DispatchQueue.main.async {
                        self?.createUser(authDataResult: authDataResult)
                    }
                }
            }
        }
    }
    private func navigateToMainApp() {
        UIViewController.showViewController(storyboardName: "MainAppStoryboard", viewcontrollerID: "MainAppTabBarViewController")
    }
    private func createUser(authDataResult: AuthDataResult) {
        DatabaseService.shared.createAppUser(authDataResult: authDataResult) { [weak self] (result) in
            switch result {
            case .failure(let error):
                print("unable to create user on database error: \(error.localizedDescription)")
            case .success:
                DispatchQueue.main.async {
                    self?.navigateToMainApp()
                }
            }
        }
    }
}
