//
//  Episode.swift
//  RickAndMortyTestTask
//
//  Created by Aleksey Kosov on 17.08.2023.
//

import Foundation

// MARK: - Episode

struct EpisodeResponse: Codable, Hashable {
    let id: Int
    let name, airDate, episode: String
    let characters: [String]
    let url: String
    let created: String

    var formatEpisodeSeason: String {
        let pattern = #"S(\d+)E(\d+)"#
        guard let regex = try? NSRegularExpression(pattern: pattern) else {
            return "No info"
        }

        let range = NSRange(episode.startIndex..<episode.endIndex, in: episode)
        if let match = regex.firstMatch(in: episode, options: [], range: range) {
            if let seasonRange = Range(match.range(at: 1), in: episode),
               let episodeRange = Range(match.range(at: 2), in: episode) {
                let season = String(episode[seasonRange])
                let episode = String(episode[episodeRange])
                return "Episode: \(episode), Season: \(season)"
            }
        }

        return "No info"
    }
}
