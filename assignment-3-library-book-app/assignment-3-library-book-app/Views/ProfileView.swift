import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var library: LibraryModel
    @Environment(\.locale) var locale
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("User Info")) {
                    HStack {
                        Image(systemName: "person.circle.fill")
                            .resizable()
                            .frame(width: 50, height: 50)
                            .foregroundColor(.blue)
                        
                        VStack(alignment: .leading) {
                            Text(library.userName)
                                .font(.headline)
                            Text("Language: \(locale.identifier)")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                    .padding(.vertical, 8)
                }
                
                Section(header: Text("Stats")) {
                    HStack {
                        Text("Completed Books")
                        Spacer()
                        Text("\(library.completedBooks.count)")
                            .foregroundColor(.secondary)
                    }
                    
                    HStack {
                        Text("Favorite Books")
                        Spacer()
                        Text("\(library.favoriteBooks.count)")
                            .foregroundColor(.secondary)
                    }
                }
                
                if !library.completedBooks.isEmpty {
                    Section(header: Text("Recently Completed")) {
                        ForEach(Array(library.completedBooks).prefix(3)) { book in
                            Text(book.title)
                        }
                    }
                }
                
                Section(header: Text("Observed Object Demo")) {
                    UserStatsView(library: library)
                }
            }
            .navigationTitle("Profile")
        }
    }
}

struct UserStatsView: View {
    @ObservedObject var library: LibraryModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("This view uses @ObservedObject explicitly.")
                .font(.caption)
                .foregroundColor(.secondary)
            HStack {
                Text("Total interactions:")
                Spacer()
                Text("\(library.completedBooks.count + library.favoriteBooks.count + library.readingList.count)")
                    .fontWeight(.bold)
            }
        }
    }
}
