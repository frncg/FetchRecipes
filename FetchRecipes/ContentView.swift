import SwiftUI

struct ContentView: View {
    
    @Environment(RecipeManager.self) var recipeManager
    @Environment(SafariSheetManager.self) var safariSheetManager
    
    var body: some View {
        NavigationStack {
            RecipeListView()
                .fullScreenCover(
                    item: Binding(get: {
                        safariSheetManager.safariSheetURL
                    }, set: { value in
                        if value == nil {
                            safariSheetManager.dismiss()
                        }
                    })
                ){ item in
                    SFSafariView(url: item.url)
                        .ignoresSafeArea()
                }
                .task {
                    await recipeManager.fetchRecipes()
                }
                .refreshable {
                    await recipeManager.fetchRecipes()
                }
        }
    }
}
