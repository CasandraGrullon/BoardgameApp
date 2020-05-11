//
//  DatabaseService.swift
//  BoardgameApp
//
//  Created by casandra grullon on 4/28/20.
//  Copyright © 2020 casandra grullon. All rights reserved.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

private let db = Firestore.firestore()

class DatabaseService {
    static let appUsers = "appUsers"
    static let genres = "genres"
    
    private init() {}
    
    public static let shared = DatabaseService()
    
    public func createAppUser(authDataResult: AuthDataResult, completion: @escaping (Result<Bool, Error>) -> ()) {
        
        guard let email = authDataResult.user.email else { return }
        db.collection(DatabaseService.appUsers).document(authDataResult.user.uid).setData(["userId": authDataResult.user.uid, "userEmail": email]) { (error) in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(true))
            }
            
        }
    }
    
    public func getGenres(completion: @escaping(Result<[Genre], Error>) -> ()) {
        db.collection(DatabaseService.genres).getDocuments { (snapshot, error) in
            if let error = error {
                completion(.failure(error))
            } else if let snapshot = snapshot {
                let genres = snapshot.documents.compactMap {Genre ($0.data())}
                completion(.success(genres))
            }
        }
    }
    
}
