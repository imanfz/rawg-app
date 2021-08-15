//
//  DetailGameResponse.swift
//  RAWG
//
//  Created by Iman Faizal on 12/08/21.
//

import Foundation

// MARK: - DetailGameResponse
struct DetailGameResponse: Decodable {
    let id: Int?
    let name: String?
    let released: String?
    let backgroundImage: String?
    let rating: Double?
    let ratingTop: Int?
    let description: String?
    let website: String?
    let genres: [Genre]?
    let error: String?

    enum CodingKeys: String, CodingKey {
        case error
        case id, name, released
        case backgroundImage = "background_image"
        case rating
        case ratingTop = "rating_top"
        case description = "description_raw"
        case website
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
