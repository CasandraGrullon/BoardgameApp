//
//  NetworkServices.swift
//  BoardgameApp
//
//  Created by casandra grullon on 4/28/20.
//  Copyright © 2020 casandra grullon. All rights reserved.
//

import Foundation
import NetworkHelper

struct BoardGameAPIClient {
    static func getGames(searchQuery: String, completion: @escaping (Result<[Game], AppError>) -> ()) {
        
        guard let search = searchQuery.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else { return }
        let endpointURL = "https://www.boardgameatlas.com/api/search?name=\(search)&client_id=\(Secrets.clientId)"
        guard let url = URL(string: endpointURL) else {
            completion(.failure(.badURL(endpointURL)))
            return
        }
        
        let request = URLRequest(url: url)
        NetworkHelper.shared.performDataTask(with: request) { (result) in
            switch result {
            case .failure(let getGamesError):
                completion(.failure(.networkClientError(getGamesError)))
            case .success(let data):
                do {
                    let results = try JSONDecoder().decode(GameResults.self, from: data)
                    completion(.success(results.games))
                    
                } catch {
                    completion(.failure(.decodingError(error)))
                }
            }
        }
        
    }
    
    static func getReviews(gameId: String, completion: @escaping (Result<[GameReview], AppError>) -> ()) {
        let endpointURL = "https://www.boardgameatlas.com/api/reviews?pretty=true&client_id=\(Secrets.clientId)&game_id=\(gameId)"
        guard let url = URL(string: endpointURL) else {
            completion(.failure(.badURL(endpointURL)))
            return
        }
        let request = URLRequest(url: url)
        NetworkHelper.shared.performDataTask(with: request) { (result) in
            switch result {
            case .failure(let getReviewsError):
                completion(.failure(.networkClientError(getReviewsError)))
            case .success(let data):
                do {
                    let results = try JSONDecoder().decode(Reviews.self, from: data)
                    completion(.success(results.reviews))
                } catch {
                    completion(.failure(.decodingError(error)))
                }
            }
        }
    }
    
    static func getGameCategories(completion: @escaping (Result<[Category], AppError>) -> ()) {
        let endpointURL = "https://www.boardgameatlas.com/api/game/categories?client_id=\(Secrets.clientId)"
        guard let url = URL(string: endpointURL) else {
            completion(.failure(.badURL(endpointURL)))
            return
        }
        let request = URLRequest(url: url)
        
        NetworkHelper.shared.performDataTask(with: request) { (result) in
            switch result {
            case .failure(let getCategoriesError):
                completion(.failure(.networkClientError(getCategoriesError)))
            case .success(let data):
                do {
                    let results = try JSONDecoder().decode(Categories.self, from: data)
                    completion(.success(results.categories))
                } catch {
                    completion(.failure(.decodingError(error)))
                }
            }
        }
    }
    
}
