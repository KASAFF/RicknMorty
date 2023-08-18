//
//  AlertPresenterProtocol.swift
//  RickAndMortyTestTask
//
//  Created by Aleksey Kosov on 19.08.2023.
//

import Foundation

protocol AlertPresenterProtocol {
    func presentAlert(model: AlertModel)
    func presentErrorWithTryAgainButton(title: String, error: Error, retryHandler: @escaping () async -> Void)
}
