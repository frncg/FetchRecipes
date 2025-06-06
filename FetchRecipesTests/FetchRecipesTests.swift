//
//  FetchRecipesTests.swift
//  FetchRecipesTests
//
//  Created by Franco Miguel Guevarra on 6/6/25.
//

import Foundation
import Testing
@testable import FetchRecipes

struct Test {
    
    @Test
    func testFetchValidRecipes() async throws {
        let recipeManager = await RecipeManager(networkManager: NetworkManager())
        
        await recipeManager.fetchRecipes()
        
        await #expect(recipeManager.recipes.count > 1)
        await #expect(recipeManager.error == nil)
        await #expect(recipeManager.isLoading == false)
    }
    
    @Test
    func testFetchMalformedRecipes() async throws {
        let malformedNetworkManager = await MalformedNetworkManager()
        let recipeManager = await RecipeManager(networkManager: malformedNetworkManager)
        
        await recipeManager.fetchRecipes()
        
        await #expect(recipeManager.recipes.isEmpty)
        await #expect(recipeManager.error != nil)
        await #expect(recipeManager.isLoading == false)
    }
    
    @Test
    func testFetchEmptyRecipes() async throws {
        let emptyNetworkManager = await EmptyNetworkManager()
        let recipeManager = await RecipeManager(networkManager: emptyNetworkManager)
        
        await recipeManager.fetchRecipes()
        
        await #expect(recipeManager.recipes.isEmpty)
        await #expect(recipeManager.error == nil)
        await #expect(recipeManager.isLoading == false)
    }
}

class MalformedNetworkManager: NetworkManager {
    
    override func fetchRecipes() async throws -> [Recipe] {
        guard let url = URL(string: URLVariations.malformed.rawValue) else {
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

class EmptyNetworkManager: NetworkManager {
    
    override func fetchRecipes() async throws -> [Recipe] {
        guard let url = URL(string: URLVariations.empty.rawValue) else {
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
