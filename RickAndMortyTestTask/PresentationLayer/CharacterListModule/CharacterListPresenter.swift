//
//  CharacterListPresenter.swift
//  RickAndMortyTestTask
//
//  Created by Aleksey Kosov on 17.08.2023.
//

import Foundation

protocol CharacterListPresenterProtocol: AnyObject {
    func viewDidLoad() async
    func loadCharacterImage(for character: Character) async -> Data?
    func loadMoreCharacters() async
    func isShouldLoadMoreChars(for indexPath: IndexPath) -> Bool
}

final class CharacterListPresenter: CharacterListPresenterProtocol {
    var view: CharacterListViewProtocol?
    private let rickNMortyLoader: IRickNMortyLoader
    private let imageLoader: ImageLoaderProtocol
    private let alertPresenter: AlertPresenterProtocol

    private var rickNMortyCharacters = [Character]()

    init(rickNMortyLoader: IRickNMortyLoader,
         imageLoader: ImageLoaderProtocol,
         alertPresenter: AlertPresenterProtocol) {
        self.rickNMortyLoader = rickNMortyLoader
        self.imageLoader = imageLoader
        self.alertPresenter = alertPresenter
    }
    
    func viewDidLoad() async {
        DispatchQueue.main.async {
            self.view?.animateInitialLoading()
        }
        do {
            view?.startAnimateBottomSpinner()
            rickNMortyCharacters = try await rickNMortyLoader.fetchCharacters()
            view?.updateDatasource(with: rickNMortyCharacters)
            DispatchQueue.main.async {
                self.view?.stopAnimateBottomSpinner()
                self.view?.intialLoadingComplete()
            }
        } catch {
            DispatchQueue.main.async {
                self.view?.stopAnimateBottomSpinner()
                self.view?.intialLoadingComplete()
            }
            self.alertPresenter.presentErrorWithTryAgainButton(title: "Something went wrong", error: error) { [weak self] in
                await self?.viewDidLoad()
            }
        }
    }

    func loadCharacterImage(for character: Character) async -> Data? {
        let imageData = await imageLoader.fetchImage(for: character)?.pngData()
        return imageData
    }

    func loadMoreCharacters() async {
        do {
            self.view?.startAnimateBottomSpinner()
            let newCharacters = try await self.rickNMortyLoader.fetchCharacters()
            self.rickNMortyCharacters.append(contentsOf: newCharacters)
            self.view?.updateDatasource(with: self.rickNMortyCharacters)
            self.view?.stopAnimateBottomSpinner()
        } catch {
            view?.stopAnimateBottomSpinner()
            self.alertPresenter.presentErrorWithTryAgainButton(title: "Something went wrong", error: error) { [weak self] in
                await self?.loadMoreCharacters()
            }
        }
    }

    func isShouldLoadMoreChars(for indexPath: IndexPath) -> Bool {
        indexPath.item == rickNMortyCharacters.count - 1
    }
}
