//
//  EpisodesView.swift
//  RickAndMortyTestTask
//
//  Created by Aleksey Kosov on 17.08.2023.
//

import SwiftUI

struct EpisodesView: View {

    let episodeResponse: EpisodeResponse

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(episodeResponse.name)
                    .foregroundColor(.white)
                    .font(.headline)
                HStack {
                    Text(episodeResponse.formatEpisodeSeason)
                        .foregroundColor(.green)
                        .font(.subheadline)
                    Spacer()
                    Text(episodeResponse.airDate)
                        .foregroundColor(.gray)
                }
                .padding(.top, 8)
            }
        }
        .padding()
        .background(CustomColor.cellBackgroundColor)
        .cornerRadius(16)
    }
}
