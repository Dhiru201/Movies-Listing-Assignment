//
//  Comment+CoreDataProperties.swift
//  Movies-Listing-Assignment
//
//  Created by Dhirendra Kumar Verma on 18/06/24.
//

import Foundation
import CoreData

extension Comment_Entity {
    /// Fetch request for `Comment_Entity`.
    /// - Returns: A configured `NSFetchRequest` for `Comment_Entity`.
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Comment_Entity> {
        return NSFetchRequest<Comment_Entity>(entityName: "Comment_Entity")
    }
    
    @NSManaged public var movieId: Int32
    @NSManaged public var id: UUID
    @NSManaged public var comment: String
}

extension Comment_Entity : Identifiable {
    
    /// Initializes a new `Comment_Entity` object with the provided data model and managed object context.
    /// - Parameters:
    ///   - context: The `NSManagedObjectContext` to associate with the new object.
    ///   - model: The `Comment` containing the data for initializing the object.
    convenience init(context: NSManagedObjectContext, model: Comment) {
        self.init(context: context)
        self.movieId = Int32(model.movieId)
        self.id = model.id ?? UUID()
        self.comment = model.comment
    }
    
    /// Converts the `Comment_Entity` object to a `Comment` model object.
    /// - Returns: A `Comment` object with data from the `Comment_Entity`.
    func toModel() -> Comment {
        return Comment(id: self.id, comment: self.comment, movieId: Int(self.movieId))
    }
}
