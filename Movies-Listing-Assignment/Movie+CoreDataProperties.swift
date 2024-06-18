//
//  Movie+CoreDataProperties.swift
//  Movies-Listing-Assignment
//
//  Created by Dhirendra Kumar Verma on 18/06/24.
//

import Foundation
import CoreData


extension Movie_Entity {
    /// Fetch request for `Movie_Entity`.
    /// - Returns: A configured `NSFetchRequest` for `Movie_Entity`.
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Movie_Entity> {
        return NSFetchRequest<Movie_Entity>(entityName: "Movie_Entity")
    }
    
    @NSManaged public var id: Int32
    @NSManaged public var isFavorite: Bool
    @NSManaged public var title: String
    @NSManaged public var releaseDate: String
    @NSManaged public var descriptionValue: String
    @NSManaged public var rating: Double
    @NSManaged public var duration: String
    @NSManaged public var genre: String
    @NSManaged public var imageUrl: String
}

extension Movie_Entity : Identifiable {
    
    /// Initializes a new `Movie_Entity` object with the provided data model and managed object context.
    /// - Parameters:
    ///   - context: The `NSManagedObjectContext` to associate with the new object.
    ///   - model: The `Movie` containing the data for initializing the object.
    convenience init(context: NSManagedObjectContext, model: Movie) {
        self.init(context: context)
        self.id = Int32(model.id)
        self.isFavorite = true
        self.title = model.title
        self.releaseDate = model.releaseDate
        self.descriptionValue = model.description
        self.rating = model.rating
        self.duration = model.duration
        self.genre = model.genre
        self.imageUrl = model.imageUrl
    }
    
    /// Converts the `Movie_Entity` object to a `Movie` model object.
    /// - Returns: A `Movie` object with data from the `Movie_Entity`.
    func toModel() -> Movie {
        return Movie(title: self.title,
                     id: Int(self.id),
                     releaseDate: self.releaseDate,
                     description: self.descriptionValue,
                     rating: self.rating,
                     duration: self.duration,
                     genre: self.genre,
                     imageUrl: self.imageUrl,
                     isFavorite: self.isFavorite)
    }
}
