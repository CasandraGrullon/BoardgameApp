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
    
    @IBOutlet weak var topAnchor: NSLayoutConstraint!
    
    private var accountState: AccountState = .existingUser
    //MARK:- Keyboard Handeling
    private var isKeyboardThere = false
    private var originalState: NSLayoutConstraint!
    
    private lazy var tapGesture: UITapGestureRecognizer = {
        let gesture = UITapGestureRecognizer()
        gesture.addTarget(self, action: #selector(didTap(_:)))
        return gesture
    }()
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        registerForKeyBoardNotifications()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTextfield.delegate = self
        passwordTextfield.delegate = self
        view.addGestureRecognizer(tapGesture)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        unregisterForKeyBoardNotifications()
    }

    private func registerForKeyBoardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    private func unregisterForKeyBoardNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    @objc
    private func keyboardWillShow(notification: NSNotification) {
        guard let keyboardFrame = notification.userInfo?["UIKeyboardFrameBeginUserInfoKey"] as? CGRect else {
            return
        }
        moveKeyboardUp(height: keyboardFrame.size.height / 2)
    }
    @objc
    private func keyboardWillHide(notification: NSNotification) {
        resetUI()
    }
    private func resetUI() {
        //topAnchor.constant = 200
        isKeyboardThere = false
        topAnchor.constant = 200
        UIView.animate(withDuration: 1.0) {
            self.view.layoutIfNeeded()
        }
    }
    private func moveKeyboardUp(height: CGFloat) {
        if isKeyboardThere {return}
        originalState = topAnchor
        topAnchor.constant -= height
        UIView.animate(withDuration: 1.0) {
            self.view.layoutIfNeeded()
        }
        isKeyboardThere = true
    }
    @objc private func didTap(_ gesture: UITapGestureRecognizer ) {
        emailTextfield.resignFirstResponder()
        passwordTextfield.resignFirstResponder()
    }
    //MARK:- Login / Sign Up button functions
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
