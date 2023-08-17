//
//  RickNMortyLoader.swift
//  RickAndMortyTestTask
//
//  Created by Aleksey Kosov on 17.08.2023.
//

import Foundation

protocol IRickNMortyLoader {
    func fetchCharacters() async -> [Character]
}

final class RickNMortyLoader: IRickNMortyLoader {

    let networkManager: INetworkRouting

    init(networkManager: INetworkRouting) {
        self.networkManager = networkManager
    }


    func fetchCharacters() async -> [Character] {
        let urlString = "https://rickandmortyapi.com/api/character"
        guard let url = URL(string: urlString) else { return [] }

        do {
            let response: CharacterResponse = try await networkManager.fetchDecoded(with: url)
            return response.results
        } catch {
            print(error)
            return []
        }
    }
}
