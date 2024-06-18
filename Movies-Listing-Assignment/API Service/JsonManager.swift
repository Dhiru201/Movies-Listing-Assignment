//
//  JsonManager.swift
//  Movies-Listing-Assignment
//
//  Created by Dhirendra Kumar Verma on 18/06/24.
//

import Foundation

final class JSONManager {
    
    static let shared: JSONManager = {
        let instance = JSONManager()
        return instance
    }()

    /// Fetches and decodes data from a local JSON file.
    /// - Parameters:
    ///   - filename: The name of the local JSON file (without extension).
    ///   - bundle: The bundle where the JSON file is located. Default is `.main`.
    ///   - type: The type to which the JSON data should be decoded.
    ///   - completionHandler: The completion handler to call when the request is complete. It receives a `Result` with either the decoded object or a `JSONParseError`.
    func getDatafrom<T:Codable>(localJSON filename: String,
                     bundle: Bundle = .main, decodeToType type: T.Type, completionHandler: @escaping (Result<T,JSONParseError>) -> ()) {
        guard let url = bundle.url(forResource: filename, withExtension: "json") else {
            return completionHandler(.failure(.fileNotFound))
        }
        let data: Data
        do {
            data = try Data(contentsOf: url)
        } catch let error {
            return completionHandler(.failure(.dataInitialization(error: error)))
        }
        do {
            let decodedResponse = try JSONDecoder().decode(type.self, from: data)
            print(decodedResponse)
            completionHandler(.success(decodedResponse))
        } catch let error {
            return completionHandler(.failure(.decoding(error: error)))
        }
    }
}
