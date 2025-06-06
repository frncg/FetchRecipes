//
//  RecipeListView.swift
//  FetchTakeHome
//
//  Created by Franco Miguel Guevarra on 6/4/25.
//

import SwiftUI
import SwiftData

struct RecipeListView: View {
    
    @Environment(RecipeManager.self) var recipeManager
    @Query var savedRecipes: [SavedRecipe]
    
    @State var searchText: String = ""
    @State var showSavedRecipes: Bool = false
    
    var shownRecipes: [Recipe] {
        let recipes = if searchText.isEmpty {
            recipeManager.recipes
        } else {
            recipeManager.recipes.filter { recipe in
                recipe.cuisine.localizedCaseInsensitiveContains(searchText) ||
                recipe.name.localizedCaseInsensitiveContains(searchText)
            }
        }
        
        if showSavedRecipes {
            return recipes.filter { recipe in
                savedRecipes.contains(where: { $0.id == recipe.id })
            }
        } else {
            return recipes
        }
    }
    
    var body: some View {
            ScrollView(.vertical) {
                gridView
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .safeAreaPadding()
            .background {
                Color(uiColor: .secondarySystemBackground)
                    .ignoresSafeArea()
            }
            .overlay {
                if shownRecipes.isEmpty {
                    
                    if let error = recipeManager.error {
                        ContentUnavailableView(
                            "An Error Occurred",
                            systemImage: "exclamationmark.triangle.fill",
                            description: Text(error.localizedDescription + "Swipe down to refresh.")
                        )
                    } else {
                        ContentUnavailableView("No Recipes Available", systemImage: "book.fill")
                    }
                    
                }
            }
            .overlay {
                if recipeManager.isLoading {
                    ProgressView("Loading")
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .ignoresSafeArea()
                        .background(Color(uiColor: .secondarySystemBackground))
                }
            }
            .navigationTitle("FetchRecipes")
            .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always), prompt: "Search by cuisine or name")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showSavedRecipes.toggle()
                    } label: {
                        Image(systemName: "bookmark")
                            .symbolVariant(showSavedRecipes ? .fill : .none)
                    }
                }
                
                ToolbarItem(placement: .principal) {
                    if showSavedRecipes {
                        Text("Showing Saved Recipes")
                            .font(.subheadline)
                    }
                }
            }
            .animation(.smooth, value: shownRecipes)
            .animation(.smooth, value: recipeManager.isLoading)
            .animation(.smooth, value: showSavedRecipes)
    }
    
    @ViewBuilder
    var gridView: some View {
        let columns = if UIDevice.current.userInterfaceIdiom == .pad {
            [GridItem(.adaptive(minimum: 250, maximum: 350))]
        } else {
            [GridItem()]
        }
        
        LazyVGrid(columns: columns, alignment: .leading, spacing: 10) {
            ForEach(shownRecipes) { recipe in
                RecipeCardView(recipe)
            }
        }
        .id("\(searchText)+\(showSavedRecipes.description)")
        .transition(.opacity)
    }

}
