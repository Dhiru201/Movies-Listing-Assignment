//
//  Comments.swift
//  Movies-Listing-Assignment
//
//  Created by Dhirendra Kumar Verma on 18/06/24.
//

import Foundation

/// Data model representing product information.
public struct Comment: Codable {
    let id: UUID?
    let comment: String
    let movieId: Int
}

