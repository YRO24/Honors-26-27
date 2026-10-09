import SwiftUI

struct BookListView: View {
    @EnvironmentObject var library: LibraryModel
    @State private var searchText = ""
    @State private var selectedCategory = "All"
    
    var categories: [String] {
        ["All"] + Array(Set(library.availableBooks.map { $0.category })).sorted()
    }
    
    var filteredBooks: [Book] {
        library.availableBooks.filter { book in
            let matchesCategory = selectedCategory == "All" || book.category == selectedCategory
            let matchesSearch = searchText.isEmpty || book.title.localizedCaseInsensitiveContains(searchText) || book.author.localizedCaseInsensitiveContains(searchText)
            return matchesCategory && matchesSearch
        }
    }
    
    var body: some View {
        NavigationView {
            VStack {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(categories, id: \.self) { category in
                            Button(action: {
                                selectedCategory = category
                            }) {
                                Text(category)
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 8)
                                    .background(selectedCategory == category ? Color.blue : Color(UIColor.systemGray5))
                                    .foregroundColor(selectedCategory == category ? .white : .primary)
                                    .cornerRadius(20)
                            }
                        }
                    }
                    .padding(.horizontal)
                }
                .padding(.vertical, 8)
                
                List(filteredBooks) { book in
                    NavigationLink(destination: BookDetailView(book: book)) {
                        BookRow(book: book)
                    }
                }
                .listStyle(PlainListStyle())
            }
            .navigationTitle("Catalogue")
            .searchable(text: $searchText, prompt: "Search books or authors")
        }
    }
}

struct BookRow: View {
    var book: Book
    
    var body: some View {
        HStack(spacing: 15) {
            Image(systemName: book.coverImageName)
                .resizable()
                .scaledToFit()
                .frame(width: 40, height: 40)
                .foregroundColor(.blue)
                .padding(12)
                .background(Color(UIColor.systemGray6))
                .cornerRadius(10)
            
            VStack(alignment: .leading, spacing: 5) {
                Text(book.title)
                    .font(.headline)
                    .lineLimit(1)
                Text(book.author)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .lineLimit(1)
                Text(book.category)
                    .font(.caption)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.blue.opacity(0.1))
                    .foregroundColor(.blue)
                    .cornerRadius(8)
            }
        }
    }
}
