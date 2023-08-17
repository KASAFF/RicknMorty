//
//  RickMortyError.swift
//  RickAndMortyTestTask
//
//  Created by Aleksey Kosov on 17.08.2023.
//


import Foundation

enum RickMortyError: Error {
    case loadingImageListError
    case invalidURL
    case invalidResponse
    case invalidData
    case unableToDecode
}

extension RickMortyError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .invalidURL:
            return NSLocalizedString("The provided URL is invalid.", comment: "Invalid URL")
        case .invalidResponse:
            return NSLocalizedString("The server returned an invalid response.", comment: "Invalid response")
        case .invalidData:
            return NSLocalizedString("The received data is invalid or corrupted.", comment: "Invalid data")
        case .unableToDecode:
            return NSLocalizedString("Unable to decode the received data.", comment: "Unable to decode")
        case .loadingImageListError:
            return NSLocalizedString("Error when loading list with images. Try again later", comment: "Image list loading error")
        }
    }
}
