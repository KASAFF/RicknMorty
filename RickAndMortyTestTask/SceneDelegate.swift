//
//  SceneDelegate.swift
//  RickAndMortyTestTask
//
//  Created by Aleksey Kosov on 17.08.2023.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = scene as? UIWindowScene else { return }
        let window = UIWindow(windowScene: windowScene)
        window.rootViewController = createNavigationController()
        self.window = window
        window.makeKeyAndVisible()
    }

    private func createNavigationController() -> UINavigationController {

        let characterListVC = CharacterListModuleBuilder().build()

        let navigationController = UINavigationController(rootViewController: characterListVC)

        let appearance = UINavigationBarAppearance()
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]

        navigationController.navigationItem.standardAppearance = appearance
        navigationController.navigationItem.scrollEdgeAppearance = appearance
        navigationController.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.red]

        let navigationBarAppearance = UINavigationBarAppearance()
        navigationBarAppearance.configureWithOpaqueBackground()
        navigationBarAppearance.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor : UIColor.white
        ]
        navigationBarAppearance.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationBarAppearance.backgroundColor = UIColor.customBackgroundColor
        UINavigationBar.appearance().standardAppearance = navigationBarAppearance
        UINavigationBar.appearance().compactAppearance = navigationBarAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = navigationBarAppearance

        navigationController.navigationItem.hidesBackButton = true

        navigationController.navigationBar.tintColor = .white
        navigationController.navigationBar.standardAppearance = navigationBarAppearance
        navigationController.navigationBar.scrollEdgeAppearance = navigationBarAppearance

        return navigationController
    }


    
}

