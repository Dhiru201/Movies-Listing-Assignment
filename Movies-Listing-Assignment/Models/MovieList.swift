//
//  MovieList.swift
//  Movies-Listing-Assignment
//
//  Created by Dhirendra Kumar Verma on 18/06/24.
//

import Foundation

struct MovieResponse: Codable {
    let movieList: [Movie]?
}
struct Movie:  Codable {
    let title: String
    let id: Int
    let releaseDate: String
    let description: String
    let rating: Double
    let duration: String
    let genre: String
    let imageUrl: String
    var isFavorite: Bool = false
    
    mutating func toggleIsFavorite() {
        isFavorite = !isFavorite
    }
}

enum JSONParseError: Error {
    case fileNotFound
    case dataInitialization(error: Error)
    case decoding(error: Error)
    case serviceUnavailable
}

enum SortType: Int {
    case title = 0
    case releaseDate = 1
}
