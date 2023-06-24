//
//  NftCollectionCell.swift
//  FakeNFT
//
//  Created by macOS on 23.06.2023.
//

import UIKit

final class NftCollectionCell: UICollectionViewCell, ReuseIdentifying {
    
    var delegate: NftCollectionCellDelegate? = nil
    var nft: Nft? = nil
    
    private let nftImageView = UIImageView()
    private let likeButton = UIButton()
    private let ratingStackView = UIStackView()
    private let starCount = 5
    private let nftNameLabel = UILabel()
    private let nftPriceLabel = UILabel()
    private let addToCartButton = UIButton()
    
    private var isLiked = false
    
    func configure(nft: Nft) {
        self.nft = nft
        
        addViews()
        setUpConstraints()
        
        if let image = nft.images.first,
           let url = URL(string: image) {
            nftImageView.loadImage(url: url, cornerRadius: 120)
        }
        
        ratingStackView.axis = .horizontal
        ratingStackView.spacing = 2
        for index in 1...starCount {
            let starImageView = UIImageView()
            let imageName = nft.rating >= index ? "starIcon" : "starDisabledIcon"
            starImageView.image = UIImage(named: imageName)
            ratingStackView.addArrangedSubview(starImageView)
        }
        
        nftNameLabel.text = nft.name
        nftNameLabel.font = .bodyBold
        nftNameLabel.textColor = .YPBlack
        nftNameLabel.numberOfLines = 1
        
        nftPriceLabel.text = "\(nft.price) ETH"
        nftPriceLabel.font = .caption3
        nftPriceLabel.textColor = .YPBlack
        nftPriceLabel.numberOfLines = 1
        
        addToCartButton.setImage(UIImage(named: "cartIcon"), for: .normal)
        addToCartButton.addTarget(self, action: #selector(addToCartTapped), for: .touchUpInside)
        
        likeButton.setImage(UIImage(named: "likeDisabledIcon"), for: .normal)
        likeButton.addTarget(self, action: #selector(likeTapped), for: .touchUpInside)
    }
    
    @objc private func addToCartTapped() {
        if let name = nft?.name {
            delegate?.onAddToCart(nftName: name)
        }
    }
    
    @objc private func likeTapped() {
        isLiked.toggle()
        let imageName = isLiked ? "likeIcon" : "likeDisabledIcon"
        likeButton.setImage(UIImage(named: imageName), for: .normal)
    }
    
    private func addViews() {
        contentView.addSubview(nftImageView)
        contentView.addSubview(likeButton)
        contentView.addSubview(ratingStackView)
        contentView.addSubview(nftNameLabel)
        contentView.addSubview(nftPriceLabel)
        contentView.addSubview(addToCartButton)
    }
    
    private func setUpConstraints() {
        nftImageView.translatesAutoresizingMaskIntoConstraints = false
        likeButton.translatesAutoresizingMaskIntoConstraints = false
        ratingStackView.translatesAutoresizingMaskIntoConstraints = false
        nftNameLabel.translatesAutoresizingMaskIntoConstraints = false
        nftPriceLabel.translatesAutoresizingMaskIntoConstraints = false
        addToCartButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            nftImageView.widthAnchor.constraint(equalToConstant: 108),
            nftImageView.heightAnchor.constraint(equalToConstant: 108),
            nftImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            
            likeButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            likeButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
            likeButton.widthAnchor.constraint(equalToConstant: 21),
            likeButton.heightAnchor.constraint(equalToConstant: 18),
            
            ratingStackView.topAnchor.constraint(equalTo: nftImageView.bottomAnchor, constant: 8),
            ratingStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            
            nftNameLabel.topAnchor.constraint(equalTo: ratingStackView.bottomAnchor, constant: 5),
            nftNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            nftNameLabel.trailingAnchor.constraint(equalTo: addToCartButton.leadingAnchor),
            
            nftPriceLabel.topAnchor.constraint(equalTo: nftNameLabel.bottomAnchor, constant: 4),
            nftPriceLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            nftPriceLabel.trailingAnchor.constraint(equalTo: addToCartButton.leadingAnchor),
            
            addToCartButton.topAnchor.constraint(equalTo: ratingStackView.bottomAnchor, constant: 4),
            addToCartButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            addToCartButton.widthAnchor.constraint(equalToConstant: 40),
            addToCartButton.heightAnchor.constraint(equalToConstant: 40),
        ])
    }
    
}
