import SwiftUI
import SwiftData

@main
struct FetchRecipes: App {
    
    @State var recipeManager = RecipeManager(networkManager: NetworkManager())
    @State var safariSheetManager = SafariSheetManager()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(recipeManager)
                .environment(safariSheetManager)
                .modelContainer(for: SavedRecipe.self, isAutosaveEnabled: true)
        }
    }
}
