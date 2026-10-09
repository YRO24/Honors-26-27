import SwiftUI

struct HomeView: View {
    @EnvironmentObject var library: LibraryModel
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    Text("Welcome back, \(library.userName)!")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .padding(.horizontal)
                    
                    VStack(spacing: 15) {
                        StatCard(title: "Completed Books", count: library.completedBooks.count, icon: "checkmark.seal.fill", color: .green)
                        StatCard(title: "Reading List", count: library.readingList.count, icon: "books.vertical.fill", color: .blue)
                        StatCard(title: "Favorites", count: library.favoriteBooks.count, icon: "star.fill", color: .orange)
                    }
                    .padding(.horizontal)
                    
                    Text("Featured Book")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .padding(.horizontal)
                        .padding(.top)
                    
                    if let featured = library.availableBooks.first {
                        NavigationLink(destination: BookDetailView(book: featured)) {
                            BookRow(book: featured)
                                .padding()
                                .background(Color(UIColor.secondarySystemBackground))
                                .cornerRadius(12)
                                .padding(.horizontal)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                .padding(.vertical)
            }
            .navigationTitle("Dashboard")
        }
    }
}

struct StatCard: View {
    var title: String
    var count: Int
    var icon: String
    var color: Color
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .font(.title)
                .foregroundColor(.white)
                .padding()
                .background(color)
                .clipShape(Circle())
            
            Text(title)
                .font(.headline)
            Spacer()
            Text("\(count)")
                .font(.title2)
                .fontWeight(.bold)
        }
        .padding()
        .background(Color(UIColor.secondarySystemBackground))
        .cornerRadius(15)
    }
}
