//
//  CharacterCardCell.swift
//  RickAndMortyTestTask
//
//  Created by Aleksey Kosov on 17.08.2023.
//

import UIKit

final class CharacterCardCell: UICollectionViewCell {

    lazy var personImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "placeholderImage")
        imageView.layer.cornerRadius = 10
        imageView.clipsToBounds = true
        return imageView
    }()

    private lazy var label: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .title3)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.textColor = .white
        return label
    }()

    static let reuseIdentifier = "characterCardCellReuseID"

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    required init?(coder: NSCoder) {
        fatalError("not implemnted")
    }

    func configure(with character: Character) {
        label.text = character.name
    }

}

private extension CharacterCardCell {
    func setupUI() {
        contentView.backgroundColor = .cellBackgroundColor
        contentView.addSubview(personImageView)
        contentView.addSubview(label)

        contentView.layer.cornerRadius = 16

        let inset = CGFloat(8)
        NSLayoutConstraint.activate([
            personImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: inset),
            personImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -inset),
            personImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: inset),
            personImageView.heightAnchor.constraint(equalTo: personImageView.widthAnchor),

            label.leadingAnchor.constraint(equalTo: personImageView.leadingAnchor),
            label.trailingAnchor.constraint(equalTo: personImageView.trailingAnchor),
            label.topAnchor.constraint(equalTo: personImageView.bottomAnchor, constant: 16),
            label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16)
            ])
    }
}
