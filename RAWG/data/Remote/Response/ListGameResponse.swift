//
//  ListGameResponse.swift
//  RAWG
//
//  Created by Iman Faizal on 12/08/21.
//

import Foundation

// MARK: - ListGameResponse
struct ListGameResponse: Codable {
    let error: String?
    let results: [Game]?
    
    enum CodingKeys: String, CodingKey {
        case error
        case results
    }
}

// MARK: - Result
struct Game: Codable {
    let id: Int?
    let name: String?
    let released: String?
    let backgroundImage: String?
    let rating: Double?
    let genres: [Genre]?

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case released
        case backgroundImage
        case rating
        case genres
    }
}

// MARK: - Genre
struct Genre: Codable {
    let id: Int?
    let name: String?

    enum CodingKeys: String, CodingKey {
        case id
        case name
    }
}
