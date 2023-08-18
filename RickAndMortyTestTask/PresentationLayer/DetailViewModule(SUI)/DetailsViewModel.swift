//
//  DetailsViewModel.swift
//  RickAndMortyTestTask
//
//  Created by Aleksey Kosov on 18.08.2023.
//

import SwiftUI


@MainActor
final class DetailsViewModel: ObservableObject {
    @Published private (set) var episodes = [EpisodeResponse]()
    @Published private (set) var characterImage: Image? = CustomImage.placeholder
    @Published private (set) var characterStatusText = ""
    @Published private (set) var characterStatusColor: Color? = .gray

    @Published var showingError = false
    @Published var errorTitle: String = ""
    @Published var errorText: String = ""


    @Published var isLoading = true

    let imageLoader: ImageLoaderProtocol
    let rickNMortyLoader: IRickNMortyLoader
    let character: Character

    var onRetryButton: (() -> Void)? = nil

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
        isLoading = true
        Task {
            if let image = await imageLoader.fetchImage(for: character) {
                characterImage = Image(uiImage: image)
            }

            do {
                episodes = try await rickNMortyLoader.fetchEpisodesForCharacter(character)
                isLoading = false
            } catch {
                if let rickError = error as? RickMortyError {
                    errorText = rickError.errorDescription ?? "Please try again later"
                    errorTitle = "Something went wrong"
                    onRetryButton = { [weak self] in
                        self?.loadCharacterData()
                    }
                    showingError = true
                }
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

