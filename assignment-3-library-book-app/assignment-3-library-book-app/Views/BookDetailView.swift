import SwiftUI

struct BookDetailView: View {
    var book: Book
    @EnvironmentObject var library: LibraryModel
    @Environment(\.dismiss) var dismiss
    @Environment(\.dynamicTypeSize) var dynamicTypeSize
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                Image(systemName: book.coverImageName)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 150)
                    .foregroundColor(.blue)
                    .padding(40)
                    .background(Color(UIColor.systemGray6))
                    .cornerRadius(20)
                    .shadow(radius: 5)
                
                Text(book.title)
                    .font(.title)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                
                Text(book.author)
                    .font(.title3)
                    .foregroundColor(.secondary)
                
                HStack(spacing: 30) {
                    ActionIcon(
                        icon: library.favoriteBooks.contains(book) ? "star.fill" : "star",
                        text: "Favorite",
                        color: .orange
                    ) {
                        library.toggleFavorite(book)
                    }
                    
                    ActionIcon(
                        icon: library.readingList.contains(book) ? "bookmark.fill" : "bookmark",
                        text: "Reading List",
                        color: .blue
                    ) {
                        library.toggleReadingList(book)
                    }
                    
                    ActionIcon(
                        icon: library.completedBooks.contains(book) ? "checkmark.circle.fill" : "checkmark.circle",
                        text: "Completed",
                        color: .green
                    ) {
                        library.toggleCompleted(book)
                    }
                }
                .padding(.vertical)
                
                VStack(alignment: .leading, spacing: 10) {
                    Text("Description")
                        .font(.headline)
                    Text(book.description)
                        .font(.body)
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .background(Color(UIColor.secondarySystemBackground))
                .cornerRadius(15)
                
                Spacer()
            }
            .padding()
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct ActionIcon: View {
    var icon: String
    var text: String
    var color: Color
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack {
                Image(systemName: icon)
                    .font(.system(size: 24))
                    .foregroundColor(color)
                    .padding()
                    .background(color.opacity(0.1))
                    .clipShape(Circle())
                
                Text(text)
                    .font(.caption)
                    .foregroundColor(.primary)
            }
        }
    }
}
