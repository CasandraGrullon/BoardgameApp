//
//  NetworkServices.swift
//  BoardgameApp
//
//  Created by casandra grullon on 4/28/20.
//  Copyright © 2020 casandra grullon. All rights reserved.
//

import Foundation

enum AppError: Error {
    case badURL(String)
    case networkError(Error)
    case decodingError(Error)
}

//MARK:- Utilized the BoardGame Atlas API https://www.boardgameatlas.com/api/docs
struct APIClient {
    //MARK:- Fetch Games with search query
    public func fetchGames(for query: String, completion: @escaping (Result<[Game], AppError>) -> ()){
        let searchQuery = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? ""
        let endpoint = "https://api.boardgameatlas.com/api/search?name=\(searchQuery)&client_id=\(Secrets.clientId)"
        guard let url = URL(string: endpoint) else {
           return completion(.failure(.badURL(endpoint)))
        }
        let request = URLRequest(url: url)
        
        let dataTask = URLSession.shared.dataTask(with: request) { (data, response, error ) in
            if let error = error {
                completion(.failure(.networkError(error)))
            } else if let data = data {
                do {
                    let results = try JSONDecoder().decode(GameResults.self, from: data)
                    completion(.success(results.games))
                } catch {
                    completion(.failure(.decodingError(error)))
                }
            }
        }
        dataTask.resume()
    }
    //MARK:- Fetch Game Reviews
    public func fetchGameReviews(gameId: String, completion: @escaping (Result<[GameReview], AppError>) -> ()) {
        let endpoint = "https://api.boardgameatlas.com/api/reviews?client_id=\(Secrets.clientId)&game_id=\(gameId)"
        guard let url = URL(string: endpoint) else {
            return completion(.failure(.badURL(endpoint)))
        }
        let request = URLRequest(url: url)
        
        let dataTask = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                completion(.failure(.networkError(error)))
            } else if let data = data {
                do {
                    let results = try JSONDecoder().decode(Reviews.self, from: data)
                    completion(.success(results.reviews))
                } catch {
                    completion(.failure(.decodingError(error)))
                }
            }
        }
        dataTask.resume()
    }
}
