//
//  UserRatingCell.swift
//  FakeNFT
//
//  Created by macOS on 20.06.2023.
//

import UIKit

class UserRatingCell: UITableViewCell, ReuseIdentifying {
        
    private let mainStackView = UIStackView()
    
    private let indexLabel = UILabel()
    private let backgroundCardView = UIView()
    private let avatarImageView = UIImageView()
    private let nameLabel = UILabel()
    private let ratingScoreLabel = UILabel()
    
    func configure(index: Int, user: User?) {
        selectionStyle = .none
        
        contentView.addSubview(mainStackView)
        mainStackView.addArrangedSubview(indexLabel)
        mainStackView.addArrangedSubview(backgroundCardView)
        
        backgroundCardView.addSubview(avatarImageView)
        backgroundCardView.addSubview(nameLabel)
        backgroundCardView.addSubview(ratingScoreLabel)
        
        setUpConstraints()
        configureViews()
        
        indexLabel.text = "12"
        nameLabel.text = "test Name"
        ratingScoreLabel.text = "121"
    }
    
    private func configureViews() {
        mainStackView.axis = .horizontal
        mainStackView.spacing = 8
        mainStackView.alignment = .center
        
        backgroundCardView.backgroundColor = .YPLightGrey
        backgroundCardView.layer.cornerRadius = 12
        
        indexLabel.font = .caption1
        indexLabel.textColor = .YPBlack
        nameLabel.font = .headline3
        indexLabel.textColor = .YPBlack
        ratingScoreLabel.font = .headline3
        indexLabel.textColor = .YPBlack
    }
    
    private func setUpConstraints() {
        backgroundCardView.translatesAutoresizingMaskIntoConstraints = false
        indexLabel.translatesAutoresizingMaskIntoConstraints = false
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        avatarImageView.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        ratingScoreLabel.translatesAutoresizingMaskIntoConstraints = false
                
        NSLayoutConstraint.activate([
            mainStackView.heightAnchor.constraint(equalToConstant: 80),
            mainStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            mainStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            mainStackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            mainStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
                        
            backgroundCardView.heightAnchor.constraint(equalToConstant: 80),
            indexLabel.widthAnchor.constraint(equalToConstant: 27),
            
            avatarImageView.centerYAnchor.constraint(equalTo: backgroundCardView.centerYAnchor),
            nameLabel.centerYAnchor.constraint(equalTo: backgroundCardView.centerYAnchor),
            ratingScoreLabel.centerYAnchor.constraint(equalTo: backgroundCardView.centerYAnchor),
            
            avatarImageView.heightAnchor.constraint(equalToConstant: 28),
            avatarImageView.widthAnchor.constraint(equalToConstant: 28),
            
            avatarImageView.leadingAnchor.constraint(equalTo: backgroundCardView.leadingAnchor, constant: 16),
            nameLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 8),
            ratingScoreLabel.trailingAnchor.constraint(equalTo: backgroundCardView.trailingAnchor, constant: -16),
            nameLabel.trailingAnchor.constraint(equalTo: ratingScoreLabel.leadingAnchor, constant: -26),
        ])
    }
        
}
