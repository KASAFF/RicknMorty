//
//  CharacterListPresenter.swift
//  RickAndMortyTestTask
//
//  Created by Aleksey Kosov on 17.08.2023.
//

import Foundation

protocol CharacterListPresenterProtocol: AnyObject {
    func viewDidLoad()
    func loadCharacterImage(for character: Character) async -> Data?
    func loadMoreCharacters() async
    func isShouldLoadMoreChars(for indexPath: IndexPath) -> Bool
}

final class CharacterListPresenter: CharacterListPresenterProtocol {
    var view: CharacterListViewProtocol?
    private let rickNMortyLoader: IRickNMortyLoader
    private let imageLoader: ImageLoaderProtocol

    private var rickNMortyCharacters = [Character]()

    init(rickNMortyLoader: IRickNMortyLoader,
         imageLoader: ImageLoaderProtocol) {
        self.rickNMortyLoader = rickNMortyLoader
        self.imageLoader = imageLoader
    }
    
    func viewDidLoad() {
        Task {
            view?.startAnimateBottomSpinner()
            rickNMortyCharacters = await rickNMortyLoader.fetchCharacters()
            view?.updateDatasource(with: rickNMortyCharacters)
            view?.stopAnimateBottomSpinner()
        }
    }

    func loadCharacterImage(for character: Character) async -> Data? {
        let imageData = await imageLoader.fetchImage(for: character)?.pngData()
        return imageData
    }

    func loadMoreCharacters() async {
        Task {
            view?.startAnimateBottomSpinner()
            let newCharacters = await rickNMortyLoader.fetchCharacters()
            rickNMortyCharacters.append(contentsOf: newCharacters)
            view?.updateDatasource(with: rickNMortyCharacters)
            view?.stopAnimateBottomSpinner()
        }
    }

    func isShouldLoadMoreChars(for indexPath: IndexPath) -> Bool {
        indexPath.item == rickNMortyCharacters.count - 1
    }
}
