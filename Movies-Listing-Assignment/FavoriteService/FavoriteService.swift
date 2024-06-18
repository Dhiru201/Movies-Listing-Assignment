//
//  FavoriteRepository.swift
//  Movies-Listing-Assignment
//
//  Created by Dhirendra Kumar Verma on 18/06/24.
//

import Foundation
import CoreData

/// Protocol defining the required methods for managing favorite movies.
protocol FavoriteServiceProtocol {
    func markFavorite(movie: Movie)
    func removeFavorite(movie: Movie)
    func getAllFavorites() -> [Movie]?
    func isMovieAvailable(movie: Movie) -> Bool 
}

struct FavoriteService: FavoriteServiceProtocol {
    /// Marks a movie as favorite by saving it to Core Data.
    /// - Parameter movie: The `Movie` object to be marked as favorite.
    func markFavorite(movie: Movie) {
        let _ = Movie_Entity(context: PersistentStorage.shared.context, model: movie)
        // save context
        PersistentStorage.shared.saveContext()
    }

    /// Removes a movie from favorites by deleting it from Core Data.
    /// - Parameter movie: The `Movie` object to be removed from favorites.
    func removeFavorite(movie: Movie) {
        guard let movie = getMovie(byId: movie.id) else { return }
        PersistentStorage.shared.context.delete(movie)
        PersistentStorage.shared.saveContext()
    }

    /// Fetches all favorite movies from Core Data.
    /// - Returns: An array of `Movie` objects representing all favorite movies, or nil if an error occurs.
    func getAllFavorites() -> [Movie]? {
        let result = PersistentStorage.shared.fetchManagedObject(managedObject: Movie_Entity.self)
        var movies: [Movie] = []
        result?.forEach({ (movie) in
            movies.append(movie.toModel())
        })
        return movies
    }
    
    /// Checks if a movie is already marked as favorite.
    /// - Parameter movie: The `Movie` object to check.
    /// - Returns: `true` if the movie is marked as favorite, `false` otherwise.
    func isMovieAvailable(movie: Movie) -> Bool {
        guard let _ = getMovie(byId: movie.id) else { return false }
        return true
        
    }

    /// Retrieves a movie entity by its unique identifier.
    /// - Parameter id: The unique identifier of the movie.
    /// - Returns: The `Movie_Entity` object corresponding to the specified identifier, or nil if not found.
    private func getMovie(byId id: Int) -> Movie_Entity? {
        let fetchRequest = NSFetchRequest<Movie_Entity>(entityName: "Movie_Entity")
        let predicate = NSPredicate(format: "id == %d", id)
        fetchRequest.predicate = predicate
        do {
            let result = try PersistentStorage.shared.context.fetch(fetchRequest).first
            guard result != nil else { return nil}
            return result
        } catch let error {
            debugPrint(error)
        }
        return nil
    }
}
