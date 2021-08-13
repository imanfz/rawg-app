//
//  DetailGameResponse.swift
//  RAWG
//
//  Created by Iman Faizal on 12/08/21.
//

import Foundation

// MARK: - DetailGameResponse

struct DetailGamesResponse: Decodable {
    let id: Int?
    let name: String?
    let released: String?
    let backgroundImage: String?
    let rating: Double?
    let ratingTop: Int?
    let description: String?
}

struct DetailGame: Decodable {
    let error: String?
    let detailGame: DetailGamesResponse?
    

    enum CodingKeys: String, CodingKey {
        case error = "error"
        case detailGame
    }
}
