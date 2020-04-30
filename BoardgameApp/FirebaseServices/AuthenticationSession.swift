//
//  AuthenticationSession.swift
//  BoardgameApp
//
//  Created by casandra grullon on 4/28/20.
//  Copyright © 2020 casandra grullon. All rights reserved.
//

import Foundation
import FirebaseAuth

class AuthenticationSession {
    private init() {}
    public static let shared = AuthenticationSession()
    
    public func createNewUser(email: String, password: String, completion: @escaping (Result<AuthDataResult, Error>) -> ()) {
        
        Auth.auth().createUser(withEmail: email, password: password) { (authDataResult, error) in
            if let error = error {
                completion(.failure(error))
            } else if let authDataResult = authDataResult {
                completion(.success(authDataResult))
            }
        }
    }
    
    public func signInExistingUser(email: String, password: String, completion: @escaping (Result<AuthDataResult, Error>) -> ()) {
        
        Auth.auth().signIn(withEmail: email, password: password) { (authDataResult, error) in
            if let error = error {
                completion(.failure(error))
            } else if let authDataResult = authDataResult {
                completion(.success(authDataResult))
            }
        }
    }
}
