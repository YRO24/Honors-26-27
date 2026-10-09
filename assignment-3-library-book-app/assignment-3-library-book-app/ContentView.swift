import SwiftUI

struct ContentView: View {
    @EnvironmentObject var library: LibraryModel
    
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }
            
            BookListView()
                .tabItem {
                    Label("Catalogue", systemImage: "book.fill")
                }
            
            MyLibraryView()
                .tabItem {
                    Label("My Library", systemImage: "bookmark.fill")
                }
            
            ProfileView()
                .tabItem {
                    Label("Profile", systemImage: "person.fill")
                }
            
            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gearshape.fill")
                }
        }
        .preferredColorScheme(library.preferences.isDarkModeEnabled ? .dark : .light)
    }
}

#Preview {
    ContentView()
        .environmentObject(LibraryModel())
}
