//
//  CharacterListPresenterProtocol.swift
//  RickAndMortyTestTask
//
//  Created by Aleksey Kosov on 19.08.2023.
//

import Foundation

protocol CharacterListPresenterProtocol: AnyObject {
    func viewDidLoad() async
    func loadCharacterImage(for character: Character) async -> Data?
    func loadMoreCharacters() async
    func isShouldLoadMoreChars(for indexPath: IndexPath) -> Bool
}
