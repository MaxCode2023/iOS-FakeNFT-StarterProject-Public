//
//  RatingProfileViewController.swift
//  FakeNFT
//
//  Created by macOS on 21.06.2023.
//

import UIKit
import ProgressHUD

final class RatingProfileViewController: UIViewController {

    private let userId: Int
    private var user: User?

    private let viewModel = RatingProfileViewModel()

    private let backButton = UIButton()
    private let avatarImageView = UIImageView()
    private let nameLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let websiteButton = UIButton()
    private let nftCollectionContainer = UIView()
    private let nftCollectionLabel = UILabel()
    private let nftCollectionCountLabel = UILabel()
    private let forwardImageView = UIImageView()

    init(userId: Int) {
        self.userId = userId
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        tabBarController?.tabBar.isHidden = true

        addViews()
        setUpConstraints()
        configureViews()

        bind()
        ProgressHUD.show()
        viewModel.getUser(userId: userId)
    }

    private func bind() {
        viewModel.$user.bind { [weak self] user in
            ProgressHUD.dismiss()
            if let user = user {
                self?.updateUserInfo(user: user)
            } else {
                self?.presentErrorDialog(message: nil)
            }
        }
        viewModel.$errorMessage.bind { [weak self] errorMessage in
            ProgressHUD.dismiss()
            self?.presentErrorDialog(message: errorMessage)
        }
    }

    private func updateUserInfo(user: User) {
        self.user = user
        nameLabel.text = user.name
        descriptionLabel.text = user.description
        nftCollectionCountLabel.text = "(\(user.nfts.count))"

        if let url = URL(string: user.avatar) {
            avatarImageView.loadImage(url: url, cornerRadius: 100)
        }
    }

    private func configureViews() {
        backButton.setImage(UIImage(named: "backIcon"), for: .normal)
        backButton.addTarget(self, action: #selector(navigateBack), for: .touchUpInside)

        nameLabel.font = .headline3
        nameLabel.textColor = .YPBlack
        nameLabel.numberOfLines = 1

        descriptionLabel.font = .caption2
        descriptionLabel.textColor = .YPBlack
        descriptionLabel.numberOfLines = 0

        websiteButton.layer.cornerRadius = 16
        websiteButton.layer.borderWidth = 1
        websiteButton.layer.borderColor = UIColor.YPBlack.cgColor
        websiteButton.setTitle("Перейти на сайт пользователя", for: .normal)
        websiteButton.setTitleColor(.YPBlack, for: .normal)
        websiteButton.titleLabel?.font = .caption1
        websiteButton.addTarget(self, action: #selector(navigateToWebsite), for: .touchUpInside)

        nftCollectionCountLabel.font = .bodyBold
        nftCollectionCountLabel.textColor = .YPBlack
        nftCollectionCountLabel.numberOfLines = 1

        nftCollectionLabel.text = "Коллекция NFT"
        nftCollectionLabel.font = .bodyBold
        nftCollectionLabel.textColor = .YPBlack
        nftCollectionLabel.numberOfLines = 1

        forwardImageView.image = UIImage(named: "forwardIcon")

        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(navigateToCollection))
        nftCollectionContainer.addGestureRecognizer(tapGestureRecognizer)
    }

    @objc private func navigateBack() {
        navigationController?.popViewController(animated: true)
        tabBarController?.tabBar.isHidden = false
    }

    @objc private func navigateToWebsite() {
        if let websiteUrl = user?.website,
           let websiteUrl = URL(string: websiteUrl) {
            let vc = WebsiteProfileViewController()
            vc.websiteUrl = websiteUrl
            navigationController?.pushViewController(vc, animated: true)
        } else {
            presentErrorDialog(message: nil)
        }
    }

    @objc private func navigateToCollection() {
        guard let user = user else {
            presentErrorDialog(message: nil)
            return
        }

        if user.nfts.isEmpty {
            presentErrorDialog(message: "Коллекция пуста")
        } else {
            let vc = ProfileCollectionViewController()
            vc.nftIds = user.nfts.map { Int($0) ?? 0 }
            navigationController?.pushViewController(vc, animated: true)
        }
    }

    private func addViews() {
        view.addSubview(backButton)
        view.addSubview(avatarImageView)
        view.addSubview(nameLabel)
        view.addSubview(descriptionLabel)
        view.addSubview(websiteButton)
        view.addSubview(nftCollectionContainer)
        nftCollectionContainer.addSubview(nftCollectionLabel)
        nftCollectionContainer.addSubview(nftCollectionCountLabel)
        nftCollectionContainer.addSubview(forwardImageView)
    }

    private func setUpConstraints() {
        backButton.translatesAutoresizingMaskIntoConstraints = false
        avatarImageView.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        websiteButton.translatesAutoresizingMaskIntoConstraints = false
        nftCollectionContainer.translatesAutoresizingMaskIntoConstraints = false
        nftCollectionLabel.translatesAutoresizingMaskIntoConstraints = false
        nftCollectionCountLabel.translatesAutoresizingMaskIntoConstraints = false
        forwardImageView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            backButton.widthAnchor.constraint(equalToConstant: 24),
            backButton.heightAnchor.constraint(equalToConstant: 24),
            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 9),
            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 11),

            avatarImageView.widthAnchor.constraint(equalToConstant: 70),
            avatarImageView.heightAnchor.constraint(equalToConstant: 70),
            avatarImageView.topAnchor.constraint(equalTo: backButton.bottomAnchor, constant: 29),
            avatarImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),

            nameLabel.centerYAnchor.constraint(equalTo: avatarImageView.centerYAnchor),
            nameLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 16),
            nameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),

            descriptionLabel.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 20),
            descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -18),

            websiteButton.heightAnchor.constraint(equalToConstant: 40),
            websiteButton.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 28),
            websiteButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            websiteButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),

            nftCollectionContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            nftCollectionContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            nftCollectionContainer.topAnchor.constraint(equalTo: websiteButton.bottomAnchor, constant: 40),
            nftCollectionContainer.heightAnchor.constraint(equalToConstant: 54),

            nftCollectionLabel.topAnchor.constraint(equalTo: nftCollectionContainer.topAnchor, constant: 16),
            nftCollectionLabel.bottomAnchor.constraint(equalTo: nftCollectionContainer.bottomAnchor, constant: -16),
            nftCollectionLabel.leadingAnchor.constraint(equalTo: nftCollectionContainer.leadingAnchor, constant: 0),

            nftCollectionCountLabel.topAnchor.constraint(equalTo: nftCollectionContainer.topAnchor, constant: 16),
            nftCollectionCountLabel.bottomAnchor.constraint(equalTo: nftCollectionContainer.bottomAnchor, constant: -16),
            nftCollectionCountLabel.leadingAnchor.constraint(equalTo: nftCollectionLabel.trailingAnchor, constant: 8),

            forwardImageView.widthAnchor.constraint(equalToConstant: 8),
            forwardImageView.heightAnchor.constraint(equalToConstant: 14),
            forwardImageView.topAnchor.constraint(equalTo: nftCollectionContainer.topAnchor, constant: 16),
            forwardImageView.bottomAnchor.constraint(equalTo: nftCollectionContainer.bottomAnchor, constant: -16),
            forwardImageView.trailingAnchor.constraint(equalTo: nftCollectionContainer.trailingAnchor)
        ])
    }

}
