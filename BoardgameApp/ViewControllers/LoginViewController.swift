//
//  ViewController.swift
//  BoardgameApp
//
//  Created by casandra grullon on 4/27/20.
//  Copyright © 2020 casandra grullon. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signUpHereButton: UIButton!
    @IBOutlet weak var promptLabel: UILabel!
    private var newUser = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func loginButtonPressed(_ sender: UIButton) {
    }
    
    @IBAction func signUpHereButtonPressed(_ sender: UIButton) {
        newUser.toggle()
        if newUser {
            loginButton.titleLabel?.text = "Sign Up"
            promptLabel.text = "Already have an account?"
            signUpHereButton.titleLabel?.text = "Login Here"
        } else {
            loginButton.titleLabel?.text = "Login"
            promptLabel.text = "Don't have an account?"
            signUpHereButton.titleLabel?.text = "Sign Up Here"
        }
        
    }
    
}

