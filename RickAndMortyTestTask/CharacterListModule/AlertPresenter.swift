//
//  AlertPresenter.swift
//  RickAndMortyTestTask
//
//  Created by Aleksey Kosov on 18.08.2023.
//

import UIKit

struct AlertModel {
    let title: String
    let message: String?
    let actions: [UIAlertAction]
}

protocol AlertPresenterProtocol {
    func presentAlert(model: AlertModel)
    func presentErrorWithTryAgainButton(title: String, error: Error, retryHandler: @escaping () async -> Void)
}

final class AlertPresenter: AlertPresenterProtocol {
    var viewController: UIViewController?
    private weak var alertController: UIAlertController?

    init(viewController: UIViewController? = nil) {
        self.viewController = viewController
    }

    func presentAlert(model: AlertModel) {
        let alertController = UIAlertController(title: model.title,
                                                message: model.message,
                                                preferredStyle: .alert)

        for action in model.actions {
            alertController.addAction(action)
            if action.style == .default {
                alertController.preferredAction = action
            }
        }
        DispatchQueue.main.async {
            self.viewController?.present(alertController, animated: true)
            self.alertController = alertController
        }
    }

    func presentErrorWithTryAgainButton(title: String, error: Error, retryHandler: @escaping () async -> Void) {
        let tryAgainAction = UIAlertAction(title: "Try Again", style: .default) { _ in
            Task { await retryHandler() }
        }
        let okayAction = UIAlertAction(title: "Okay", style: .cancel, handler: nil)

        let alertModel: AlertModel
        if let rickNMortyError = error as? RickMortyError {
            alertModel = AlertModel(title: title,
                                        message: rickNMortyError.errorDescription,
                                        actions: [tryAgainAction, okayAction])
        } else {
            alertModel = AlertModel(title: title, message: error.localizedDescription, actions: [tryAgainAction, okayAction])
        }


        presentAlert(model: alertModel)
    }
}
