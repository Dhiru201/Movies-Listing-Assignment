//
//  CommentService.swift
//  Movies-Listing-Assignment
//
//  Created by Dhirendra Kumar Verma on 18/06/24.
//

import Foundation
import CoreData

/// Protocol defining the required methods for managing favorite movies.
protocol CommentServiceProtocol {
    func saveComment(comment: Comment)
    func getAllComments() -> [Comment]?
}

struct CommentService: CommentServiceProtocol {
    func saveComment(comment: Comment) {
        let _ = Comment_Entity(context: PersistentStorage.shared.context, model: comment)
        // save context
        PersistentStorage.shared.saveContext()
    }
    
    func getAllComments() -> [Comment]? {
        let result = PersistentStorage.shared.fetchManagedObject(managedObject: Comment_Entity.self)
        var comments: [Comment] = []
        result?.forEach({ (comment) in
            comments.append(comment.toModel())
        })
        return comments
    }
}
