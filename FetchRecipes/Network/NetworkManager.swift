//
//  NetworkManager.swift
//  FetchTakeHome
//
//  Created by Franco Miguel Guevarra on 6/2/25.
//

import Foundation

@MainActor
@Observable
class NetworkManager {
    
    let session: URLSession
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    func fetchRecipes() async throws -> [Recipe] {
        
        guard let url = URL(string: URLVariations.valid.rawValue) else {
            throw URLError(.badURL)
        }
        
        let (data, response) = try await session.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
        
        let decoder = JSONDecoder()
        
        let decoded =  try decoder.decode(RecipeResponse.self, from: data)
        return decoded.recipes
        
    }
}

enum URLVariations: String {
    case valid = "https://d3jbb8n5wk0qxi.cloudfront.net/recipes.json"
    case malformed = "https://d3jbb8n5wk0qxi.cloudfront.net/recipes-malformed.json"
    case empty = "https://d3jbb8n5wk0qxi.cloudfront.net/recipes-empty.json"
}
