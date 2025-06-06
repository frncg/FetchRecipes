//
//  RecipeManager.swift
//  FetchTakeHome
//
//  Created by Franco Miguel Guevarra on 6/2/25.
//

import Foundation

@MainActor
@Observable
class RecipeManager {
    
    private let networkManager: NetworkManager
    
    var recipes: [Recipe] = []
    var error: Error?
    var isLoading: Bool = false
    
    init(networkManager: NetworkManager) {
        self.networkManager = networkManager
    }
    
    func fetchRecipes() async {
        isLoading = true
        defer {
            isLoading = false
        }
        
        self.error = nil
        do {
            recipes = try await networkManager.fetchRecipes()
        } catch {
            self.error = error
            self.recipes = []
            print("Failed to fetch recipes: \(error.localizedDescription)")
        }
    }
    
}
