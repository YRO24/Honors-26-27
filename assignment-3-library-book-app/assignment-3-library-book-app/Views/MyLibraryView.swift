import SwiftUI

struct MyLibraryView: View {
    @EnvironmentObject var library: LibraryModel
    @State private var selectedTab = 0
    
    var body: some View {
        NavigationView {
            VStack {
                Picker("List Type", selection: $selectedTab) {
                    Text("Reading List").tag(0)
                    Text("Favorites").tag(1)
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()
                
                List {
                    let booksToShow = selectedTab == 0 ? Array(library.readingList) : Array(library.favoriteBooks)
                    
                    if booksToShow.isEmpty {
                        Text("No books found.")
                            .foregroundColor(.secondary)
                            .padding()
                    } else {
                        ForEach(booksToShow) { book in
                            NavigationLink(destination: BookDetailView(book: book)) {
                                BookRow(book: book)
                            }
                        }
                    }
                }
                .listStyle(PlainListStyle())
            }
            .navigationTitle("My Library")
        }
    }
}
