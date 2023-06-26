//
//  MyNftTableViewCell.swift
//  FakeNFT
//
//  Created by Суворов Дмитрий Владимирович on 25.06.2023.
//

import UIKit

final class MyNftTableViewCell: UITableViewCell {
    static let identifier = "MyNftTableViewCell"

    private let starCount = 5

    private lazy var nftImageView: UIImageView = {
        let nftImageView = UIImageView()
        nftImageView.translatesAutoresizingMaskIntoConstraints = false
        return nftImageView
    }()

    private lazy var nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.font = UIFont.bodyBold
        nameLabel.textColor = UIColor.textPrimary
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        return nameLabel
    }()

    private lazy var addInfoLabel: UILabel = {
        let addInfoLabel = UILabel()
        addInfoLabel.font = UIFont.caption2
        addInfoLabel.textColor = UIColor.textPrimary
        addInfoLabel.translatesAutoresizingMaskIntoConstraints = false
        return addInfoLabel
    }()

    private lazy var priceLabel: UILabel = {
        let priceLabel = UILabel()
        priceLabel.font = UIFont.caption2
        priceLabel.textColor = UIColor.textPrimary
        priceLabel.text = "Цена"
        priceLabel.translatesAutoresizingMaskIntoConstraints = false
        return priceLabel
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

    private let priceVerticalStackView: UIStackView = {
        let priceVerticalStackView = UIStackView()
        priceVerticalStackView.axis = NSLayoutConstraint.Axis.vertical
        priceVerticalStackView.spacing = 2
        priceVerticalStackView.translatesAutoresizingMaskIntoConstraints = false
        return priceVerticalStackView
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func bindCell(nftView: NftView) {
        if let image = nftView.nft.images.first,
           let url = URL(string: image) {
            nftImageView.loadImage(url: url, cornerRadius: 120)
        }
        for index in 1...starCount {
            let starImageView = UIImageView()
            starImageView.image = UIImage(named: "ratingStar")
            starImageView.tintColor = nftView.nft.rating >= index ? UIColor.yellow : UIColor.lightGray
            ratingStackView.addArrangedSubview(starImageView)
        }
        nameLabel.text = nftView.nft.name
        priceValueLabel.text = "\(nftView.nft.price) ETH"
    }

    private func configureUI() {
        backgroundColor = UIColor.background
        selectionStyle = UITableViewCell.SelectionStyle.none

        infoStackView.addArrangedSubview(nameLabel)
        infoStackView.addArrangedSubview(ratingStackView)
        infoStackView.addArrangedSubview(addInfoLabel)

        priceVerticalStackView.addArrangedSubview(priceLabel)
        priceVerticalStackView.addArrangedSubview(priceValueLabel)

        contentView.addSubview(nftImageView)
        contentView.addSubview(infoStackView)
        contentView.addSubview(priceVerticalStackView)

        NSLayoutConstraint.activate([
            nftImageView.widthAnchor.constraint(equalToConstant: 108),
            nftImageView.heightAnchor.constraint(equalToConstant: 108),
            nftImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            nftImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),

            infoStackView.centerYAnchor.constraint(equalTo: nftImageView.centerYAnchor),
            infoStackView.leadingAnchor.constraint(equalTo: nftImageView.trailingAnchor, constant: 20),

            priceVerticalStackView.centerYAnchor.constraint(equalTo: nftImageView.centerYAnchor),
            priceVerticalStackView.leadingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -114),
            priceVerticalStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
        ])
    }
}
