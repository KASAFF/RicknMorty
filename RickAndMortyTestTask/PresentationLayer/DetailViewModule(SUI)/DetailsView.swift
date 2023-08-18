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
            Group {
                VStack(alignment: .center) {
                    viewModel.characterImage?
                        .resizable()
                        .scaledToFit()
                        .cornerRadius(16)
                        .frame(width: 150, height: 150)
                        .padding(.bottom, 12)
                    Text(viewModel.character.name)
                        .font(.system(size: 22, weight: .bold))
                        .foregroundColor(.white)
                        .padding(.bottom, 2)
                    Text(viewModel.characterStatusText)
                        .foregroundColor(viewModel.characterStatusColor)
                }
                .padding(.bottom)

                Section {
                    InfoView(character: viewModel.character)
                } header: {
                    SectionHeaderView(text: "Info")
                }
                .padding(.bottom)

                Section {
                    OriginView(character: viewModel.character)
                } header: {
                    SectionHeaderView(text: "Origin")
                }
                .padding(.bottom)


                Section {
                    LazyVStack {
                        ForEach(viewModel.episodes, id: \.self) { episode in
                            EpisodesView(episodeResponse: episode)
                        }
                    }
                } header: {
                    SectionHeaderView(text: "Episodes")
                }
                .padding(.bottom)
            }
            .padding(.horizontal)
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                CustomNavigationBackButton()
            }
        }
        .alert(isPresented: $viewModel.showingError) {
            Alert(
                title: Text(viewModel.errorTitle),
                message: Text(viewModel.errorText),
                primaryButton: .default(Text("OK")),
                secondaryButton: .default(Text("Try again"),
                action: viewModel.onRetryButton)
            )

        }
    }
}

