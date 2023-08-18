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
                    .font(.system(size: 19, weight: .semibold))
                HStack {
                    Text(episodeResponse.formatEpisodeSeason)
                        .foregroundColor(CustomColor.textGreen)
                        .font(.system(size: 14, weight: .light))
                    Spacer()
                    Text(episodeResponse.airDate)
                        .font(.system(size: 13, weight: .light))
                        .foregroundColor(CustomColor.textGray)
                }
                .padding(.top, 8)
            }
        }
        .padding()
        .background(CustomColor.cellBackgroundColor)
        .cornerRadius(16)
    }
}
