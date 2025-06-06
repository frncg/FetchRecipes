//
//  SavedRecipe.swift
//  FetchTakeHome
//
//  Created by Franco Miguel Guevarra on 6/4/25.
//

import SwiftData

@Model
final class SavedRecipe {
    var id: String
    var name: String
    var cuisine: String
    var photoURLLarge: String?
    var photoURLSmall: String?
    var sourceURL: String?
    var youtubeURL: String?
    
    init(with recipe: Recipe) {
        self.id = recipe.id
        self.name = recipe.name
        self.cuisine = recipe.cuisine
        self.photoURLLarge = recipe.photoURLLarge
        self.photoURLSmall = recipe.photoURLSmall
        self.sourceURL = recipe.sourceURL
        self.youtubeURL = recipe.youtubeURL
    }
}
