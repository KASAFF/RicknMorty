//
//  ViewController.swift
//  RickAndMortyTestTask
//
//  Created by Aleksey Kosov on 17.08.2023.
//

import UIKit
import SwiftUI

class MainViewController: UIViewController {

    enum Section {
        case main
    }

    var dataSource: UICollectionViewDiffableDataSource<Section, Character>?
    var collectionView: UICollectionView?

    var rickNMortyCharacters = [Character]() {
        didSet {
            updateDatasource()
        }
    }

    let rickNMortyLoader: IRickNMortyLoader
    let imageLoader: ImageLoaderProtocol

    init(rickNMortyLoader: IRickNMortyLoader,
         imageLoader: ImageLoaderProtocol) {
        self.rickNMortyLoader = rickNMortyLoader
        self.imageLoader = imageLoader
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override var preferredStatusBarStyle: UIStatusBarStyle { .darkContent }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Characters"
        navigationController?.navigationBar.prefersLargeTitles = true
        configureHierarchy()
        configureDataSource()

        Task {
            rickNMortyCharacters = await rickNMortyLoader.fetchCharacters()
        }
    }
}

extension MainViewController {
    func createLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5),
                                              heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .fractionalHeight(0.28))

        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, repeatingSubitem: item, count: 2)
        let spacing = CGFloat(16)
        group.interItemSpacing = .fixed(spacing)

        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = spacing

        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 20)

        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
}

extension MainViewController {
    func configureHierarchy() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createLayout())
        guard let collectionView else { return }
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = .customBackgroundColor
        collectionView.delegate = self
        collectionView.register(CharacterCardCell.self, forCellWithReuseIdentifier: CharacterCardCell.reuseIdentifier)
        view.addSubview(collectionView)
    }
    func configureDataSource() {
        guard let collectionView else { return }
        dataSource = UICollectionViewDiffableDataSource<Section, Character>(collectionView: collectionView) {
            (collectionView: UICollectionView, indexPath: IndexPath, character: Character) -> UICollectionViewCell? in

            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: CharacterCardCell.reuseIdentifier,
                for: indexPath) as? CharacterCardCell else { fatalError("Cannot create new cell") }

            cell.configure(with: character)
            Task { cell.personImageView.image = await self.imageLoader.fetchImage(for: character) }

            return cell
        }
        updateDatasource()
    }

    private func updateDatasource() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Character>()
        snapshot.appendSections([.main])
        snapshot.appendItems(rickNMortyCharacters)
        dataSource?.apply(snapshot, animatingDifferences: true)
    }
}

extension MainViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let character = dataSource?.itemIdentifier(for: indexPath) else { return }

        let detailsCharactherView = DetailsView(character: character)
        let host = UIHostingController(rootView: detailsCharactherView)
        host.view.backgroundColor = .customBackgroundColor

        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)

        navigationController?.navigationBar.prefersLargeTitles = false
        navigationController?.pushViewController(host, animated: true)
    }
}

