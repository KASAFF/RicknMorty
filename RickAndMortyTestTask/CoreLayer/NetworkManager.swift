//
//  NetworkManager.swift
//  RickAndMortyTestTask
//
//  Created by Aleksey Kosov on 17.08.2023.
//

import Foundation
import Combine

protocol INetworkRouting {
    func fetchData(with url: URL) async throws -> Data
    func fetchDecoded<T: Decodable>(with url: URL) async throws -> T
}

final class NetworkManager: INetworkRouting {

    private let decoder: JSONDecoder

    init(decoder: JSONDecoder = JSONDecoder()) {
        self.decoder = decoder
    }

    func fetchData(with url: URL) async throws -> Data {
        let request = URLRequest(url: url)
        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            throw RickMortyError.invalidResponse
        }

        return data
    }

    func fetchDecoded<T: Decodable>(with url: URL) async throws -> T {
        let data = try await fetchData(with: url)
        do {
            let decodedObject = try decoder.decode(T.self, from: data)
            return decodedObject
        } catch {
            print(error)
            throw RickMortyError.unableToDecode
        }
    }
}

