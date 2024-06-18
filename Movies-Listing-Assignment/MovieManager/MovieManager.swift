//
//  MovieManager.swift
//  Movies-Listing-Assignment
//
//  Created by Dhirendra Kumar Verma on 18/06/24.
//

import Foundation

/// Manager class for performing product-related operations.
struct MovieManager {
    
    /// The favorite repository used for data access from core Data.
    private let favoriteService: FavoriteServiceProtocol?
    
    /// The movie service used for fetching movie data locally.
    private let movieService: MovieServiceProtocol?
    
    /// Initialization of `MovieManager`.
    /// - Parameters:
    ///   - favoriteService: The favorite repository used for core data access.
    ///   - movieService: The movie service used for fetching movie data.
    init(favoriteService: FavoriteServiceProtocol?, movieService: MovieServiceProtocol? = nil) {
        self.favoriteService = favoriteService
        self.movieService = movieService
    }
    
    /// Fetches all favorite movies.
    /// - Returns: An array of `Movie` objects representing all favorite movies, or nil if an error occurs.
    func getAllFavorites() -> [Movie]? {
        return favoriteService?.getAllFavorites()
    }
    
    /// Toggles the favorite status of a movie.
    /// - Parameter movie: The `Movie` object to toggle favorite status.
    func toggleFavorite(movie: Movie) {
        if let isMovieAvailable = favoriteService?.isMovieAvailable(movie: movie), isMovieAvailable {
            favoriteService?.removeFavorite(movie: movie)
        } else {
            favoriteService?.markFavorite(movie: movie)
        }
    }
    
    /// Fetches the list of movies from the movie service.
    /// - Parameter completionHandler: The completion handler to call when the request is complete. It receives a `MovieListResult`.
    func fetchMovieList(completionHandler: @escaping (MovieListResult) -> ()) {
        guard let movieService = movieService else {
            completionHandler(.failure(.serviceUnavailable))
            return
        }
        movieService.fetchMovieList { result in
            completionHandler(result)
        }
    }
}
