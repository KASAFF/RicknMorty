//
//  ViewController.swift
//  RickAndMortyTestTask
//
//  Created by Aleksey Kosov on 17.08.2023.
//

import UIKit
import SwiftUI

final class CharacterListViewController: UIViewController, CharacterListViewProtocol {

    private enum Section {
        case main
    }

    private var loadingInProgress = false

    private lazy var padginationLoadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.hidesWhenStopped = true
        return indicator
    }()

    private lazy var loadingView = {
        let loadingView = UIView()
        loadingView.backgroundColor = .gray.withAlphaComponent(0.95)
        loadingView.layer.cornerRadius = 6
        loadingView.translatesAutoresizingMaskIntoConstraints = false
        return loadingView
    }()

    private lazy var characterLoadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.translatesAutoresizingMaskIntoConstraints = false
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
        configureHierarchy()
        configureDataSource()
        configureBottomActivityIndicator()

        configureInitialActivityIndicator()
        Task { await presenter.viewDidLoad() }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = true
    }

    private func configureInitialActivityIndicator() {
        view.addSubview(loadingView)

        NSLayoutConstraint.activate([
            loadingView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            loadingView.heightAnchor.constraint(equalToConstant: 110),
            loadingView.widthAnchor.constraint(equalToConstant: 110)
        ])

        loadingView.addSubview(characterLoadingIndicator)

        NSLayoutConstraint.activate([
            characterLoadingIndicator.centerXAnchor.constraint(equalTo: loadingView.centerXAnchor),
            characterLoadingIndicator.centerYAnchor.constraint(equalTo: loadingView.centerYAnchor),
            characterLoadingIndicator.heightAnchor.constraint(equalToConstant: 100),
            characterLoadingIndicator.widthAnchor.constraint(equalToConstant: 100)
        ])
    }

    func animateInitialLoading() {
        loadingView.isHidden = false
        characterLoadingIndicator.startAnimating()
    }

    func intialLoadingComplete() {
        loadingView.isHidden = true
        characterLoadingIndicator.stopAnimating()
    }

    private func configureBottomActivityIndicator() {
        let layoutGuide = view.safeAreaLayoutGuide
        view.addSubview(padginationLoadingIndicator)
        NSLayoutConstraint.activate([
            layoutGuide.centerXAnchor.constraint(equalTo: padginationLoadingIndicator.centerXAnchor),
            layoutGuide.bottomAnchor.constraint(equalTo: padginationLoadingIndicator.bottomAnchor, constant: 10)
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
            self.padginationLoadingIndicator.startAnimating()
        }
    }

    func stopAnimateBottomSpinner() {
        loadingInProgress = false
        DispatchQueue.main.async {
            self.padginationLoadingIndicator.stopAnimating()
        }
    }
}

extension CharacterListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let character = dataSource?.itemIdentifier(for: indexPath) else { return }

        let detailsCharactherView = DetailsView(character: character)
        let host = UIHostingController(rootView: detailsCharactherView)
        host.view.backgroundColor = .customBackgroundColor
        host.navigationItem.hidesBackButton = true
        host.navigationItem.largeTitleDisplayMode = .never

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

