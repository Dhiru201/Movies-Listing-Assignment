//
//  MoviesViewModel.swift
//  Movies-Listing-Assignment
//
//  Created by Dhirendra Kumar Verma on 18/06/24.
//

import Foundation

protocol MovieListDataProtocol {
    func numberOfRowsInSection() -> Int
    func movie(_ index: Int) -> Movie?
    func fetchMovies(completion: @escaping () -> Void)
    func fetchFavoriteMovies(completion: @escaping () -> Void)
    func toggleFavorite(at indexPath: IndexPath)
}


public class MoviesViewModel {
    enum ViewModelType {
        case home
        case favorite
    }
    private var movies: [Movie] = []
    let movieManager: MovieManager!
    
    /// Initializes the view model with a specific type.
    /// - Parameter viewModelType: The type of view model to initialize.
    init(for viewModelType: ViewModelType) {
        if viewModelType == .favorite {
            self.movieManager = MovieManager(favoriteService: FavoriteService())
        } else {
            self.movieManager = MovieManager(favoriteService: FavoriteService(), movieService: MovieService())
        }
    }

    /// Fetches favorite movies from the manager.
    /// - Parameter completion: Completion handler called after fetching favorites.
    func fetchFavoriteMovies(completion: @escaping () -> Void) {
        guard let allFavorites = movieManager.getAllFavorites() else {
            return
        }
        movies = allFavorites
        completion()
    }
    
    /// Fetches movies from a service using the movie manager.
    /// - Parameter completion: Completion handler called after fetching movies.
    public func fetchMovies(completion: @escaping () -> Void) {
        movieManager.fetchMovieList(completionHandler: { result in
            print(result)
            switch result {
            case .success(let movieResponse) :
                if let movies = movieResponse.movieList {
                    self.prepareMovieData(movies)
                    completion()
                }
            case .failure(let error):
                print(error)
                self.movies = []
                completion()
            }
        })
    }
    
    /// Prepares movie data by combining fetched movies with favorite status.
    /// - Parameter movies: The list of movies fetched from the service.
    private func prepareMovieData(_ movies: [Movie]) {
        self.movies.removeAll()
        guard let allFavorites = movieManager.getAllFavorites() else {
            self.movies = movies
            return
        }
        movies.forEach { movie in
            var movieObj = movie
            if allFavorites.contains(where: { $0.id == movieObj.id }) {
                movieObj.toggleIsFavorite()
            }
            self.movies.append(movieObj)
        }
    }
}

// MARK: - MovieListDataProtocol Extension
extension MoviesViewModel : MovieListDataProtocol {
    
    func toggleFavorite(at indexPath: IndexPath) {
        guard let movie = self.movies[safe: indexPath.item] else { return }
        movieManager.toggleFavorite(movie: movie)
        self.movies[indexPath.item].toggleIsFavorite()
    }
    
    /// Returns the number of rows in the specified section.
    /// - Parameters:
    /// - Returns: The number of rows in the section.
    func numberOfRowsInSection() -> Int {
        return movies.count
    }
    
    func movie(_ index: Int) -> Movie? {
        movies[safe : index]
    }
}
