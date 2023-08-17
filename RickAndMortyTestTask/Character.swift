//
//  Character.swift
//  RickAndMortyTestTask
//
//  Created by Aleksey Kosov on 17.08.2023.
//

import Foundation

struct Location: Codable {
    let name: String
    let url: String
}

struct Origin: Codable {
    let name: String
    let url: String
}

struct Character: Codable, Hashable {
    let id: Int
    let name: String
    let status: String
    let species: String
    let type: String
    let gender: String
    let origin: Origin
    let location: Location
    let image: String
    let episode: [String]
    let url: String
    let created: String

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(name)
    }

    static func == (lhs: Character, rhs: Character) -> Bool {
        lhs.id == rhs.id
    }
}

struct CharacterResponse: Codable {
    let info: CharacterInfo
    let results: [Character]
}

struct CharacterInfo: Codable {
    let count: Int
    let pages: Int
    let next: String?
    let prev: String?
}
