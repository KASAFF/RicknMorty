//
//  ImageLoader.swift
//  RickAndMortyTestTask
//
//  Created by Aleksey Kosov on 17.08.2023.
//

import UIKit

protocol ImageLoaderProtocol {
    func fetchImage(for character: Character) async -> UIImage?
    func fetchImage(url: URL?) async -> UIImage?
}

final class ImageLoader: ImageLoaderProtocol {

    init(networkManager: INetworkRouting) {
        self.networkManager = networkManager
    }

    private let cache: NSCache<NSString, UIImage> = {
        let cache = NSCache<NSString, UIImage>()
        cache.countLimit = 100
        return cache
    }()

    private let networkManager: INetworkRouting

    func fetchImage(for character: Character) async -> UIImage? {
        let cacheKey = NSString(string: String(character.id))
        guard let url = URL(string: character.image) else {
            return nil
        }

        return await fetchImageWithCacheKey(cacheKey, url: url)
    }

        func fetchImage(url: URL?) async -> UIImage? {
            guard let stringKey = url?.absoluteString else { return nil }
            let cacheKey = NSString(string: stringKey)
            guard let url = url else {
                return nil
            }

            return await fetchImageWithCacheKey(cacheKey, url: url)
        }

    private func fetchImageWithCacheKey(_ cacheKey: NSString, url: URL) async -> UIImage? {
        if let image = self.cache.object(forKey: cacheKey) {
            return image
        }

        do {
            let imageData = try await networkManager.fetchData(with: url)
            return UIImage(data: imageData)
        } catch {
            print(error)
            return .placeholder
        }
    }

    private func compressImage(_ image: UIImage, compressionQuality: CGFloat = 0.3) -> UIImage? {
        guard let compressedImageData = image.jpegData(compressionQuality: compressionQuality) else {
            return nil
        }
        return UIImage(data: compressedImageData)
    }
}



