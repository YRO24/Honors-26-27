import Foundation

struct Book: Identifiable, Hashable {
    let id = UUID()
    let title: String
    let author: String
    let description: String
    let category: String
    let coverImageName: String // Using SF Symbols
}

extension Book {
    static let dummyBooks: [Book] = [
        Book(title: "The Swift Programming Language", author: "Apple", description: "The definitive guide to Swift and a must-read for any iOS developer.", category: "Programming", coverImageName: "swift"),
        Book(title: "Design Patterns", author: "Erich Gamma", description: "Elements of Reusable Object-Oriented Software. This classic book is a must for any software engineer.", category: "Programming", coverImageName: "book.closed"),
        Book(title: "Clean Code", author: "Robert C. Martin", description: "A Handbook of Agile Software Craftsmanship that teaches the best practices of clean and maintainable code.", category: "Programming", coverImageName: "terminal"),
        Book(title: "The Martian", author: "Andy Weir", description: "An astronaut is stranded on Mars and must use his scientific knowledge to survive.", category: "Science Fiction", coverImageName: "globe.americas"),
        Book(title: "Dune", author: "Frank Herbert", description: "A science fiction masterpiece set on the desert planet Arrakis.", category: "Science Fiction", coverImageName: "moon.fill"),
        Book(title: "Atomic Habits", author: "James Clear", description: "An easy and proven way to build good habits and break bad ones.", category: "Self-Help", coverImageName: "brain.head.profile"),
        Book(title: "Thinking, Fast and Slow", author: "Daniel Kahneman", description: "A renowned psychologist explains how two systems drive the way we think.", category: "Psychology", coverImageName: "lightbulb"),
        Book(title: "Sapiens", author: "Yuval Noah Harari", description: "A brief history of humankind.", category: "History", coverImageName: "figure.walk")
    ]
}
