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
    
    
}
