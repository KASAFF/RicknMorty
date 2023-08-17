//
//  CharacterListModuleBuilder.swift
//  RickAndMortyTestTask
//
//  Created by Aleksey Kosov on 17.08.2023.
//

import UIKit

final class CharacterListModuleBuilder {

    func build() -> UIViewController {
        let networkManager = NetworkManager()
        let rickNmortyLoader = RickNMortyLoader(networkManager: networkManager)
        let imageLoader = ImageLoader(networkManager: networkManager)

        let presenter = CharacterListPresenter(rickNMortyLoader: rickNmortyLoader, imageLoader: imageLoader)
        let vc = CharacterListViewController(presenter: presenter)
        presenter.view = vc

        return vc
    }
}
