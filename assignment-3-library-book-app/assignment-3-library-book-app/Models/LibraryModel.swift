import Foundation
import Combine

class LibraryModel: ObservableObject {
    @Published var availableBooks: [Book] = Book.dummyBooks
    @Published var favoriteBooks: Set<Book> = []
    @Published var readingList: Set<Book> = []
    @Published var completedBooks: Set<Book> = []
    
    @Published var preferences: UserPreferences = UserPreferences()
    @Published var userName: String = "Student"
    
    // Toggle functions
    func toggleFavorite(_ book: Book) {
        if favoriteBooks.contains(book) {
            favoriteBooks.remove(book)
        } else {
            favoriteBooks.insert(book)
        }
    }
    
    func toggleReadingList(_ book: Book) {
        if readingList.contains(book) {
            readingList.remove(book)
        } else {
            readingList.insert(book)
        }
    }
    
    func toggleCompleted(_ book: Book) {
        if completedBooks.contains(book) {
            completedBooks.remove(book)
        } else {
            completedBooks.insert(book)
        }
    }
}

struct UserPreferences {
    var isDarkModeEnabled: Bool = false
    var notificationsEnabled: Bool = true
}
