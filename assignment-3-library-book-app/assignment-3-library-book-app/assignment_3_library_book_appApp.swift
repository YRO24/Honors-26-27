import SwiftUI

@main
struct assignment_3_library_book_appApp: App {
    @StateObject private var library = LibraryModel()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(library)
        }
    }
}
