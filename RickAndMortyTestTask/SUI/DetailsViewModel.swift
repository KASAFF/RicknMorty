//
//  DetailsViewModel.swift
//  RickAndMortyTestTask
//
//  Created by Aleksey Kosov on 18.08.2023.
//

import Foundation

import Foundation
import SwiftUI

@MainActor
protocol DetailsViewModelProtocol: ObservableObject, AnyObject {
    var episodes: [EpisodeResponse] { get }
    var characterImage: Image? { get }
    var characterStatusText: String { get }
    var characterStatusColor: Color { get }
}

@MainActor
final class DetailsViewModel: ObservableObject {
    @Published private (set) var episodes = [EpisodeResponse]()
    @Published private (set) var characterImage: Image? = CustomImage.placeholder
    @Published private (set) var characterStatusText = ""
    @Published private (set) var characterStatusColor: Color? = .gray

    let imageLoader: ImageLoaderProtocol
    let rickNMortyLoader: IRickNMortyLoader
    let character: Character

    init(character: Character) {
        self.character = character

        let jsonDecoder = JSONDecoder()
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase

        let networkManager = NetworkManager(decoder: jsonDecoder)

        self.imageLoader = ImageLoader(networkManager: networkManager)
        self.rickNMortyLoader = RickNMortyLoader(networkManager: networkManager)

        loadCharacterData()
    }

    private func loadCharacterData() {
        Task {
            if let image = await imageLoader.fetchImage(for: character) {
                characterImage = Image(uiImage: image)
            }

            do {
                episodes = try await rickNMortyLoader.fetchEpisodesForCharacter(character)
            } catch {
                print(error)
            }

            switch character.status {
            case .alive:
                characterStatusText = "Alive"
                characterStatusColor = CustomColor.textGreen
            case .dead:
                characterStatusText = "Dead"
                characterStatusColor = .red
            case .unknown:
                characterStatusText = "Unknown"
                characterStatusColor = .gray
            }
        }
    }
}

