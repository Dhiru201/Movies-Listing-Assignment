//
//  MovieService.swift
//  Movies-Listing-Assignment
//
//  Created by Dhirendra Kumar Verma on 18/06/24.
//

import Foundation

/// Typealias for the result of fetching a movie list.
typealias MovieListResult = Result<MovieResponse, JSONParseError>

/// Protocol defining the required methods for fetching movie data.
protocol MovieServiceProtocol {
    func fetchMovieList(completionHandler: @escaping (MovieListResult) -> ())
}

struct MovieService: MovieServiceProtocol {
    /// Fetches the list of movies.
    /// - Parameter completionHandler: The completion handler to call when the request is complete. It receives a `MovieListResult`.
    func fetchMovieList(completionHandler: @escaping (MovieListResult) -> ()) {
        JSONManager.shared.getDatafrom(localJSON: "MoviesJSON", decodeToType: MovieResponse.self, completionHandler: completionHandler)
    }
}


