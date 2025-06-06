//
//  RecipeCardView.swift
//  FetchTakeHome
//
//  Created by Franco Miguel Guevarra on 6/6/25.
//

import SwiftUI
import SwiftData

struct RecipeCardView: View {
    
    @Environment(SafariSheetManager.self) var safariSheetManager
    @Environment(\.modelContext) private var modelContext
    @Query var savedRecipes: [SavedRecipe]
    
    let recipe: Recipe
    
    init(_ recipe: Recipe) {
        self.recipe = recipe
    }
    
    var body: some View {
        Menu {
            ControlGroup {
                if let youtubeURL = recipe.youtubeURL, let url = URL(string: youtubeURL) {
                    Link(destination: url) {
                        Label("Watch", systemImage: "play.rectangle")
                            .font(.headline)
                            .padding()
                    }
                }
                
                if let sourceURL = recipe.sourceURL, let url = URL(string: sourceURL) {
                    Button {
                        safariSheetManager.present(url)
                    } label: {
                        Label("View", systemImage: "book")
                            .font(.headline)
                            .padding()
                    }
                }
                
                Button {
                    if let savedRecipe = savedRecipes.first(where: { $0.id == recipe.id }) {
                        modelContext.delete(savedRecipe)
                    } else {
                        let savedRecipe = SavedRecipe(with: recipe)
                        modelContext.insert(savedRecipe)
                    }
                } label: {
                    if savedRecipes.contains(where: { $0.id == recipe.id }) {
                        Label("Saved", systemImage: "bookmark.fill")
                    } else {
                        Label("Save", systemImage: "bookmark")
                    }
                }

            }
        } label: {
            VStack(alignment: .center, spacing: 0) {
                if let imageURLString = recipe.photoURLLarge  {
                    CachedAsyncImage(url: URL(string: imageURLString))
                        .scaledToFill()
                        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                        .aspectRatio(4/3, contentMode: .fill)
                        .clipped()
                }
                
                HStack(spacing: 10) {
                    VStack(alignment: .leading) {
                        Text(recipe.cuisine)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                        
                        Text(recipe.name)
                            .font(.headline)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                    
                    Image(systemName: "chevron.right")
                        .foregroundStyle(.tertiary)
                        .font(.subheadline)
                        .fontWeight(.semibold)
                }
                .padding(15)
            }
            .background(Color(uiColor: .systemBackground))
            .multilineTextAlignment(.leading)
            .clipShape(.rect(cornerRadius: 10))
            .contentShape(.rect)
        }
        .buttonStyle(.plain)
    }
}
