//
//  FavoritesNftCollectionViewCell.swift
//  FakeNFT
//
//  Created by Суворов Дмитрий Владимирович on 26.06.2023.
//

import UIKit

final class FavoritesNftCollectionViewCell: UICollectionViewCell {
    static let identifier = "FavoritesNftCollectionViewCell"

    private let starCount = 5

    private var likeButtonAction: (() -> Void)?

    private lazy var nftImageView: UIImageView = {
        let nftImageView = UIImageView()
        nftImageView.clipsToBounds = true
        nftImageView.layer.cornerRadius = 12
        nftImageView.translatesAutoresizingMaskIntoConstraints = false
        return nftImageView
    }()

    private lazy var likeButton: UIButton = {
        let likeButton = UIButton()
        likeButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        likeButton.tintColor = UIColor.white
        likeButton.addTarget(self, action: #selector(onLikeButtonClick), for: .touchUpInside)
        likeButton.translatesAutoresizingMaskIntoConstraints = false
        return likeButton
    }()

    private lazy var nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.font = UIFont.bodyBold
        nameLabel.textColor = UIColor.textPrimary
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        return nameLabel
    }()

    private lazy var priceValueLabel: UILabel = {
        let priceValueLabel = UILabel()
        priceValueLabel.font = UIFont.bodyBold
        priceValueLabel.textColor = UIColor.textPrimary
        priceValueLabel.translatesAutoresizingMaskIntoConstraints = false
        return priceValueLabel
    }()

    private lazy var ratingStackView: UIStackView = {
        let ratingStackView = UIStackView()
        ratingStackView.axis = NSLayoutConstraint.Axis.horizontal
        ratingStackView.spacing = 2
        ratingStackView.translatesAutoresizingMaskIntoConstraints = false
        return ratingStackView
    }()

    private lazy var infoStackView: UIStackView = {
        let infoStackView = UIStackView()
        infoStackView.axis = NSLayoutConstraint.Axis.vertical
        infoStackView.alignment = UIStackView.Alignment.leading
        infoStackView.spacing = 4
        infoStackView.translatesAutoresizingMaskIntoConstraints = false
        return infoStackView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func bindCell(nftView: NftView, likeButtonAction: @escaping (() -> Void)) {
        self.likeButtonAction = likeButtonAction
        if let image = nftView.nft.images.first,
           let url = URL(string: image) {
            nftImageView.loadImage(url: url, cornerRadius: 120)
        }

        for index in 1...starCount {
            guard let starImageView =
                    ratingStackView.arrangedSubviews[index - 1] as? UIImageView else { continue }
            starImageView.tintColor = nftView.nft.rating >= index ? UIColor.yellow : UIColor.lightGray
        }

        likeButton.tintColor = nftView.isLiked ? UIColor.red : UIColor.white
        nameLabel.text = nftView.nft.name
        priceValueLabel.text = "\(nftView.nft.price) ETH"
    }

    @objc private func onLikeButtonClick() {
        likeButtonAction?()
    }

    private func configureUI() {
        backgroundColor = UIColor.background

        infoStackView.addArrangedSubview(nameLabel)
        infoStackView.addArrangedSubview(ratingStackView)
        infoStackView.addArrangedSubview(priceValueLabel)

        contentView.addSubview(nftImageView)
        contentView.addSubview(likeButton)
        contentView.addSubview(infoStackView)

        NSLayoutConstraint.activate([
            nftImageView.widthAnchor.constraint(equalToConstant: 80),
            nftImageView.heightAnchor.constraint(equalToConstant: 80),
            nftImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            nftImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),

            likeButton.widthAnchor.constraint(equalToConstant: 21),
            likeButton.heightAnchor.constraint(equalToConstant: 21),
            likeButton.topAnchor.constraint(equalTo: nftImageView.topAnchor, constant: 5),
            likeButton.trailingAnchor.constraint(equalTo: nftImageView.trailingAnchor, constant: -5),

            infoStackView.centerYAnchor.constraint(equalTo: nftImageView.centerYAnchor),
            infoStackView.leadingAnchor.constraint(equalTo: nftImageView.trailingAnchor, constant: 12),
            infoStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            infoStackView.heightAnchor.constraint(equalToConstant: 67)
        ])
        for _ in 0..<starCount {
            let starImageView = UIImageView()
            starImageView.image = UIImage(named: "ratingStar")
            starImageView.tintColor = UIColor.lightGray
            ratingStackView.addArrangedSubview(starImageView)
        }
    }
}
