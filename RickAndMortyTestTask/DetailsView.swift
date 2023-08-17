//
//  DetailsView.swift
//  RickAndMortyTestTask
//
//  Created by Aleksey Kosov on 17.08.2023.
//

import SwiftUI

struct DetailsView: View {

    @StateObject private var viewModel: DetailsViewModel

    init(character: Character) {
        _viewModel = StateObject(wrappedValue: DetailsViewModel(character: character))
    }

    var body: some View {
        ScrollView {
            VStack {
                VStack(alignment: .center) {
                    viewModel.characterImage?
                        .resizable()
                        .scaledToFit()
                        .cornerRadius(16)
                        .frame(width: 150, height: 150)
                        .padding(.bottom)
                    Text(viewModel.character.name)
                        .font(.headline)
                        .foregroundColor(.white)
                    Text(viewModel.characterStatusText)
                        .foregroundColor(viewModel.characterStatusColor)
                }

                Section {
                    InfoView(character: viewModel.character)
                } header: {
                    HStack {
                        Text("Info")
                            .font(.headline)
                            .foregroundColor(.white)
                        Spacer()
                    }
                }

                Section {
                    OriginView(character: viewModel.character)
                } header: {
                    HStack {
                        Text("Origin")
                            .font(.headline)
                            .foregroundColor(.white)
                        Spacer()
                    }
                }

                Section {
                    ForEach(viewModel.episodes, id: \.self) { episode in
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
        .padding(.horizontal)
    }
}

