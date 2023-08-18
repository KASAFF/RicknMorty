//
//  CharacterListViewProtocol.swift
//  RickAndMortyTestTask
//
//  Created by Aleksey Kosov on 19.08.2023.
//

import Foundation

protocol CharacterListViewProtocol: AnyObject {
    func updateDatasource(with characters: [Character])
    func startAnimateBottomSpinner()
    func stopAnimateBottomSpinner()

    func animateInitialLoading()
    func intialLoadingComplete()
}
