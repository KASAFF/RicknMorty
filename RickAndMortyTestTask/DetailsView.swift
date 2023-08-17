//
//  DetailsView.swift
//  RickAndMortyTestTask
//
//  Created by Aleksey Kosov on 17.08.2023.
//

import SwiftUI

struct DetailsView: View {

    private let character: Character
    @State private var episodes = [EpisodeResponse]()

    let imageLoader: ImageLoaderProtocol
    let rickNMortyLoader: IRickNMortyLoader

    init(character: Character) {
        self.character = character

        let jsonDecoder = JSONDecoder()
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase

        let networkManager = NetworkManager(decoder: jsonDecoder)

        self.imageLoader = ImageLoader(networkManager: networkManager)
        self.rickNMortyLoader = RickNMortyLoader(networkManager: networkManager)
    }

    @State private var characterImage: Image?

    var body: some View {
        ScrollView {
            VStack {
                VStack(alignment: .center) {
                    characterImage?
                        .resizable()
                        .scaledToFit()
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                        .frame(width: 150, height: 150)
                        .padding(.bottom)
                    Text(character.name)
                        .font(.headline)
                        .foregroundColor(.white)
                    switch character.status {
                    case .alive: Text("Alive")
                            .foregroundColor(.green)
                    case .dead: Text("Dead")
                            .foregroundColor(.red)
                    case .unknown: Text("Unknown")
                            .foregroundColor(.gray)
                    }
                }

                Section {
                    InfoView(character: character)
                } header: {
                    HStack {
                        Text("Info")
                            .font(.headline)
                            .foregroundColor(.white)
                        Spacer()
                    }
                }

                Section {
                    OriginView(character: character)
                } header: {
                    HStack {
                        Text("Origin")
                            .font(.headline)
                            .foregroundColor(.white)
                        Spacer()
                    }
                }

                Section {
                    ForEach(episodes, id: \.id) { episode in
                        EpisodesView(episodeResponse: episode)
                    }
                } header: {
                    HStack {
                        Text("Episodes")
                            .font(.headline)
                            .foregroundColor(.white)
                        Spacer()
                    }
                }
            }
        }
        .frame(maxHeight: .infinity)

        .task {
            if let image = await imageLoader.fetchImage(for: character) {
                characterImage = Image(uiImage: image)
            }

            do {
                episodes = try await rickNMortyLoader.fetchEpisodesForCharacter(character)
            } catch {
                print(error)
            }

        }
        .padding(.horizontal)
    }
}

