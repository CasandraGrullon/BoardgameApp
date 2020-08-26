//
//  NetworkServices.swift
//  BoardgameApp
//
//  Created by casandra grullon on 4/28/20.
//  Copyright © 2020 casandra grullon. All rights reserved.
//

import Foundation
import NetworkHelper

struct APIClient {
    public func fetchGames(for query: String, completion: @escaping (Result<[Game], AppError>) -> ()){
        let searchQuery = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? ""
        let endpoint = "https://api.boardgameatlas.com/api/search?name=\(searchQuery)&client_id=\(Secrets.clientId)"
        guard let url = URL(string: endpoint) else {
           return completion(.failure(.badURL(endpoint)))
        }
        let request = URLRequest(url: url)
        
        NetworkHelper.shared.performDataTask(with: request) { (result) in
            switch result {
            case .failure(let error):
                completion(.failure(.networkClientError(error)))
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
    public func fetchGameReviews(gameId: String, completion: @escaping (Result<[GameReview], AppError>) -> ()) {
        let endpoint = "https://api.boardgameatlas.com/api/reviews?client_id=\(Secrets.clientId)&game_id=\(gameId)"
        guard let url = URL(string: endpoint) else {
            return completion(.failure(.badURL(endpoint)))
        }
        let request = URLRequest(url: url)
        
        NetworkHelper.shared.performDataTask(with: request) { (result) in
            switch result {
            case .failure(let error):
                completion(.failure(.networkClientError(error)))
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
}
