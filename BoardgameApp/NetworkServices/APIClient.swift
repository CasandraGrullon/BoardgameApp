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
struct APIClient<T: Codable> {
    //MARK:- Fetch Requests
    public func fetchResults(searchQuery: String? = nil, gameID: String? = nil, completion: @escaping (Result<T, AppError>) -> ()) {
        var endpoint = String()
        
        if let searchQuery = searchQuery {
            let query = searchQuery.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? ""
            endpoint = "https://api.boardgameatlas.com/api/search?name=\(query)&client_id=\(Secrets.clientId)"
        } else if let gameID = gameID {
            endpoint = "https://api.boardgameatlas.com/api/reviews?client_id=\(Secrets.clientId)&game_id=\(gameID)"
        }
        
        guard let url = URL(string: endpoint) else {
            return completion(.failure(.badURL(endpoint)))
        }
        let request = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                return completion(.failure(.networkError(error)))
            }
            if let data = data {
                do {
                    let result = try JSONDecoder().decode(T.self, from: data)
                    return completion(.success(result))
                } catch {
                    completion(.failure(.decodingError(error)))
                }
            }
        }
        task.resume()
    }
}
