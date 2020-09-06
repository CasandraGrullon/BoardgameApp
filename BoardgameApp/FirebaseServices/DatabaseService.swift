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
    
    //MARK:- Create App User
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
    //MARK:- Add Game to Collection
    public func addToCollection(userGames: Game? = nil, wishlist: Game? = nil, completion: @escaping (Result<Bool, Error>) -> ()) {
        guard let user = Auth.auth().currentUser else {return}
        
        //user owned games collection
        if let userGames = userGames {
            db.collection(DatabaseService.appUsers).document(user.uid).collection(DatabaseService.userGamesCollection).document(userGames.id).setData(["gameId": userGames.id, "gameName": userGames.name, "gameImage": userGames.imageURL, "userOwned": true]) { (error) in
                if let error = error {
                    completion(.failure(error))
                } else {
                    completion(.success(true))
                }
            }
            //user wishlist collection
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
    //MARK:- Fetch user saved games collections
    public func getCollection(userOwned: Bool, completion: @escaping (Result<[CollectedGame], Error>) -> () ) {
        guard let user = Auth.auth().currentUser else { return }
        
        //user owned games collection
        if userOwned {
            db.collection(DatabaseService.appUsers).document(user.uid).collection(DatabaseService.userGamesCollection).getDocuments { (snapshot, error) in
                if let error = error {
                    completion(.failure(error))
                } else if let snapshot = snapshot {
                    let userGames = snapshot.documents.compactMap { CollectedGame ($0.data()) }.filter {$0.userOwned == true}
                    completion(.success(userGames))
                }
            }
            //user wishlist collection
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
    //MARK:- Remove from Collection
    public func removeFromCollection(userOwned: Bool, collectedGame: CollectedGame? = nil, game: Game? = nil, completion: @escaping (Result<Bool, Error>) -> ()) {
        guard let user = Auth.auth().currentUser else {return}
        
        //MARK:- CollectedGame object method called in Profile ViewController
        if let collectedGame = collectedGame {
            //user owned collection
            if userOwned {
                db.collection(DatabaseService.appUsers).document(user.uid).collection(DatabaseService.userGamesCollection).document(collectedGame.gameId).delete() { (error) in
                    if let error = error {
                        completion(.failure(error))
                    } else {
                        completion(.success(true))
                    }
                }
                //user wishlist collection
            } else {
                db.collection(DatabaseService.appUsers).document(user.uid).collection(DatabaseService.userWishlistCollection).document(collectedGame.gameId).delete() { (error) in
                    if let error = error {
                        completion(.failure(error))
                    } else {
                        completion(.success(true))
                    }
                }
            }
            //MARK:- Game Object method called in Game Detail ViewController
        } else if let game = game {
            //userOwned
            if userOwned {
                db.collection(DatabaseService.appUsers).document(user.uid).collection(DatabaseService.userGamesCollection).document(game.id).delete() { (error) in
                    if let error = error {
                        completion(.failure(error))
                    } else {
                        completion(.success(true))
                    }
                }
                //wishlist
            } else {
                db.collection(DatabaseService.appUsers).document(user.uid).collection(DatabaseService.userWishlistCollection).document(game.id).delete() { (error) in
                    if let error = error {
                        completion(.failure(error))
                    } else {
                        completion(.success(true))
                    }
                }
            }
        }
    }
    //MARK:- Verify if a game object is in user owned collection
    public func isInUserOwnedCollection(collectedGame: Game, completion: @escaping (Result<Bool, Error>) -> ()) {
        guard let user = Auth.auth().currentUser else {return}
        
        db.collection(DatabaseService.appUsers).document(user.uid).collection(DatabaseService.userGamesCollection).whereField("gameId", isEqualTo: collectedGame.id).getDocuments { (snapshot, error) in
            if let error = error {
                completion(.failure(error))
            } else if let snapshot = snapshot {
                let count = snapshot.documents.count
                if count > 0 {
                    completion(.success(true))
                } else {
                    completion(.success(false))
                }
            }
        }
    }
    //MARK:- Verify if a game object is in user wishlist collection
    public func isInWishlistCollection(collectedGame: Game, completion: @escaping (Result<Bool, Error>) -> ()) {
        guard let user = Auth.auth().currentUser else {return}
        db.collection(DatabaseService.appUsers).document(user.uid).collection(DatabaseService.userWishlistCollection).whereField("gameId", isEqualTo: collectedGame.id).getDocuments { (snapshot, error) in
            if let error = error {
                completion(.failure(error))
            } else if let snapshot = snapshot {
                let count = snapshot.documents.count
                if count > 0 {
                    completion(.success(true))
                } else {
                    completion(.success(false))
                }
            }
        }
    }
}
