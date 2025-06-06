//
//  Recipe.swift
//  FetchTakeHome
//
//  Created by Franco Miguel Guevarra on 6/2/25.
//

struct Recipe: Codable, Identifiable, Equatable {
    let cuisine: String
    let name: String
    let photoURLLarge: String?
    let photoURLSmall: String?
    let id: String
    let sourceURL: String?
    let youtubeURL: String?
    
    enum CodingKeys: String, CodingKey {
        case cuisine
        case name
        case photoURLLarge = "photo_url_large"
        case photoURLSmall = "photo_url_small"
        case id = "uuid"
        case sourceURL = "source_url"
        case youtubeURL =  "youtube_url"
    }
    
    static func == (lhs: Recipe, rhs: Recipe) -> Bool {
        return lhs.id == rhs.id
    }
}

struct RecipeResponse: Codable {
    let recipes: [Recipe]
}

