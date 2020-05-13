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
    static let userGamesCollection = "userGamesCollection"
    static let userWishlistCollection = "userWishlistCollection"
    
    
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
    public func addToCollection(userGames: Game? = nil, wishlist: Game? = nil, completion: @escaping (Result<Bool, Error>) -> ()) {
        guard let user = Auth.auth().currentUser else {return}
        
        if let userGames = userGames {
            db.collection(DatabaseService.appUsers).document(user.uid).collection(DatabaseService.userGamesCollection).document(userGames.id).setData(["gameId": userGames.id, "gameName": userGames.name, "gameImage": userGames.imageURL, "userOwned": true]) { (error) in
                if let error = error {
                    completion(.failure(error))
                } else {
                    completion(.success(true))
                }
            }
            
        } else if let wishlist = wishlist {
            db.collection(DatabaseService.appUsers).document(user.uid).collection(DatabaseService.userWishlistCollection).document(wishlist.id).setData(["gameId": wishlist.id, "gameName": wishlist.name, "gameImage": wishlist.imageURL, "userOwned": false]) { (error) in
                if let error = error {
                    completion(.failure(error))
                } else {
                    completion(.success(true))
                }
            }
        }
    }
    public func getCollection(userOwned: Bool, completion: @escaping (Result<[CollectedGame], Error>) -> () ) {
        guard let user = Auth.auth().currentUser else { return }
        if userOwned == true {
            db.collection(DatabaseService.appUsers).document(user.uid).collection(DatabaseService.userGamesCollection).getDocuments { (snapshot, error) in
                if let error = error {
                    completion(.failure(error))
                } else if let snapshot = snapshot {
                    let userGames = snapshot.documents.compactMap { CollectedGame ($0.data()) }.filter {$0.userOwned == true}
                    completion(.success(userGames))
                }
            }
        } else {
            db.collection(DatabaseService.appUsers).document(user.uid).collection(DatabaseService.userWishlistCollection).getDocuments { (snapshot, error) in
                if let error = error {
                    completion(.failure(error))
                } else if let snapshot = snapshot {
                    let wishlist = snapshot.documents.compactMap { CollectedGame ($0.data())}.filter {$0.userOwned == false}
                    completion(.success(wishlist))
                }
            }

        }
        
    }
    public func removeFromCollection() {
        
    }
    public func isInCollection() {
        
    }
    
    
}
