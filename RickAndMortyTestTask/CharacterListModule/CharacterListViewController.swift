//
//  ViewController.swift
//  RickAndMortyTestTask
//
//  Created by Aleksey Kosov on 17.08.2023.
//

import UIKit
import SwiftUI

protocol CharacterListViewProtocol: AnyObject {
    func updateDatasource(with characters: [Character])
    func startAnimateBottomSpinner()
    func stopAnimateBottomSpinner()
}

class CharacterListViewController: UIViewController, CharacterListViewProtocol {

    private enum Section {
        case main
    }

    private var loadingInProgress = false

    private lazy var loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.hidesWhenStopped = true
        return indicator
    }()

    private let presenter: CharacterListPresenterProtocol

    private var dataSource: UICollectionViewDiffableDataSource<Section, Character>?
    private var collectionView: UICollectionView?

    init(presenter: CharacterListPresenterProtocol) {
        self.presenter = presenter
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
        configureBottomActivityIndicator()
        presenter.viewDidLoad()
    }

    private func configureBottomActivityIndicator() {
        let layoutGuide = view.safeAreaLayoutGuide
        view.addSubview(loadingIndicator)
        NSLayoutConstraint.activate([
            layoutGuide.centerXAnchor.constraint(equalTo: loadingIndicator.centerXAnchor),
            layoutGuide.bottomAnchor.constraint(equalTo: loadingIndicator.bottomAnchor, constant: 10)
        ])
        collectionView?.contentInset.bottom = 50
    }
}

extension CharacterListViewController {
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

extension CharacterListViewController {
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
                for: indexPath) as? CharacterCardCell else { return UICollectionViewCell() }

            cell.configure(with: character)

            Task { [weak self] in
                if let personImageData = await self?.presenter.loadCharacterImage(for: character) {
                    cell.personImageView.image = UIImage(data: personImageData)
                }
            }

            return cell
        }
    }

    func updateDatasource(with characters: [Character]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Character>()
        snapshot.appendSections([.main])
        snapshot.appendItems(characters)
        dataSource?.apply(snapshot, animatingDifferences: true)
    }


    func startAnimateBottomSpinner() {
        loadingInProgress = true
        DispatchQueue.main.async {
            self.loadingIndicator.startAnimating()
        }
    }

    func stopAnimateBottomSpinner() {
        loadingInProgress = false
        DispatchQueue.main.async {
            self.loadingIndicator.stopAnimating()
        }
    }
}

extension CharacterListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let character = dataSource?.itemIdentifier(for: indexPath) else { return }

        let detailsCharactherView = DetailsView(character: character)
        let host = UIHostingController(rootView: detailsCharactherView)
        host.view.backgroundColor = .customBackgroundColor

        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)

        navigationController?.navigationBar.prefersLargeTitles = false
        navigationController?.pushViewController(host, animated: true)
    }

    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if presenter.isShouldLoadMoreChars(for: indexPath) {
            Task {
                await presenter.loadMoreCharacters()
            }
        }
    }
}

