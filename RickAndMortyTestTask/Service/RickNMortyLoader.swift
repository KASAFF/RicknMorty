//
//  RickNMortyLoader.swift
//  RickAndMortyTestTask
//
//  Created by Aleksey Kosov on 17.08.2023.
//

import Foundation

protocol IRickNMortyLoader {
    func fetchCharacters() async -> [Character]
    func fetchEpisodesForCharacter(_ character: Character) async throws -> [EpisodeResponse]
}

final actor RickNMortyLoader: IRickNMortyLoader {

    let networkManager: INetworkRouting

    init(networkManager: INetworkRouting) {
        self.networkManager = networkManager
    }

    private var currentPage = 1

    func fetchCharacters() async -> [Character] {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "rickandmortyapi.com"
        urlComponents.path = "/api/character"
        urlComponents.queryItems = [URLQueryItem(name: "page", value: String(currentPage))]

        guard let url = urlComponents.url else { return [] }

        do {
            let response: CharacterResponse = try await networkManager.fetchDecoded(with: url)
            guard response.info.next != nil else { return [] }
            currentPage += 1
            return response.results
        } catch {
            print(error)
            return []
        }
    }

    func fetchEpisodesForCharacter(_ character: Character) async throws -> [EpisodeResponse] {
        var episodes = [EpisodeResponse]()

        for episodeUrl in character.episode {
            guard let url = URL(string: episodeUrl) else {
                continue
            }

            do {
                let epsiode: EpisodeResponse = try await networkManager.fetchDecoded(with: url)
                episodes.append(epsiode)
            } catch {
                print(error)
                throw error
            }
        }

        return episodes
    }

}
