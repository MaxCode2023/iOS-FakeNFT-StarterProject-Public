//
//  ProfileViewController.swift
//  FakeNFT
//
//  Created by Суворов Дмитрий Владимирович on 22.06.2023.
//

import UIKit
import ProgressHUD

final class ProfileViewController: UIViewController {
    private static let heightTableCell = CGFloat(54)

    private let viewModel = ProfileViewModel()

    private var currentTableCellTitles: [String] = []

    private lazy var nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.font = UIFont.headline3
        nameLabel.textColor = UIColor.textPrimary
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        return nameLabel
    }()

    private lazy var descriptionLabel: UILabel = {
        let descriptionLabel = UILabel()
        descriptionLabel.font = UIFont.caption2
        descriptionLabel.textColor = UIColor.textPrimary
        descriptionLabel.numberOfLines = 0
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        return descriptionLabel
    }()

    private lazy var urlButton: UIButton = {
        let urlButton = UIButton()
        urlButton.titleLabel?.font = UIFont.caption1
        urlButton.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.left
        urlButton.setTitleColor(UIColor.systemBlue, for: UIControl.State.normal)
        urlButton.addTarget(self, action: #selector(onUrlButtonClick), for: UIControl.Event.touchUpInside)
        urlButton.translatesAutoresizingMaskIntoConstraints = false
        return urlButton
    }()

    private lazy var avatarImageView: UIImageView = {
        let avatarImageView = UIImageView()
        avatarImageView.layer.masksToBounds = true
        avatarImageView.layer.cornerRadius = 35
        avatarImageView.clipsToBounds = true
        avatarImageView.translatesAutoresizingMaskIntoConstraints = false
        return avatarImageView
    }()

    private lazy var editIcon: UIBarButtonItem = {
        let editIcon = UIBarButtonItem(
            image: UIImage(named: "editIcon"),
            style: .plain,
            target: self,
            action: #selector(onEditIconClick)
        )
        editIcon.tintColor = UIColor.tintPrimary
        return editIcon
    }()

    private lazy var profileTableView: UITableView = {
        let profileTableView = UITableView(frame: CGRect.zero, style: UITableView.Style.plain)
        profileTableView.register(ProfileTableViewCell.self, forCellReuseIdentifier: ProfileTableViewCell.identifier)
        profileTableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        profileTableView.isScrollEnabled = false
        profileTableView.dataSource = self
        profileTableView.delegate = self
        profileTableView.translatesAutoresizingMaskIntoConstraints = false
        return profileTableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        initObservers()

        viewModel.onViewCreated()
    }

    @objc private func onEditIconClick() {
        viewModel.onEditButtonClick()
    }

    @objc private func onUrlButtonClick() {
        viewModel.onUrlButtonClick()
    }

    private func configureUI() {
        view.backgroundColor = UIColor.background
        navigationItem.setRightBarButtonItems([editIcon], animated: true)
        view.addSubview(nameLabel)
        view.addSubview(descriptionLabel)
        view.addSubview(urlButton)
        view.addSubview(avatarImageView)
        view.addSubview(profileTableView)
        NSLayoutConstraint.activate([
            avatarImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 22),
            avatarImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            avatarImageView.heightAnchor.constraint(equalToConstant: 70),
            avatarImageView.widthAnchor.constraint(equalToConstant: 70),

            nameLabel.centerYAnchor.constraint(equalTo: avatarImageView.centerYAnchor),
            nameLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 16),
            nameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),

            descriptionLabel.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 20),
            descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -18),

            urlButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            urlButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            urlButton.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 12),
            urlButton.heightAnchor.constraint(equalToConstant: 30),

            profileTableView.heightAnchor.constraint(equalToConstant: 1125),
            profileTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            profileTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            profileTableView.topAnchor.constraint(equalTo: urlButton.bottomAnchor, constant: 44)
        ])
    }

    private func initObservers() {
        viewModel.$profileViewState.bind { [weak self] viewState in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.renderState(viewState: viewState)
            }
        }

        viewModel.$profileViewRoute.bind { [weak self] route in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.navigateTo(destination: route)
            }
        }
    }

    private func renderState(viewState: ProfileViewState) {
        switch viewState {
        case .loading:
            showProgress()
        case .content(let profileData):
            renderProfileData(profile: profileData)
        case .error(let errorString):
            renderErrorState(errorString: errorString)
        }
    }

    private func navigateTo(destination: ProfileViewRoute?) {
        guard let destination = destination else { return }
        switch destination {
        case .toUrl(let url):
            navigateToWebSite(url: url)
        case .toMyNft:
            navigateToMyNft()
        case .toFavoriteNft:
            navigateToFavoriteNft()
        case .toEdit:
            navigateToEditProfile()
        }
    }

    private func showProgress() {
        profileTableView.isHidden = true
        UIApplication.shared.windows.first?.isUserInteractionEnabled = false
        ProgressHUD.show()
    }

    private func hideProgress() {
        profileTableView.isHidden = false
        UIApplication.shared.windows.first?.isUserInteractionEnabled = true
        ProgressHUD.dismiss()
    }

    private func renderErrorState(errorString: String) {
        hideProgress()
        profileTableView.isHidden = true
        presentErrorDialog(message: errorString)
    }

    private func renderProfileData(profile: ProfileViewState.ProfileData) {
        hideProgress()
        nameLabel.text = profile.name
        descriptionLabel.text = profile.description
        urlButton.setTitle(profile.website, for: UIControl.State.normal)
        avatarImageView.kf.setImage(with: URL(string: profile.avatar))
        currentTableCellTitles = profile.cellTitles
        profileTableView.reloadData()
    }

    private func navigateToMyNft() {
        let viewModel = MyNftViewModel()
        let myNftVc = MyNftViewController(viewModel: viewModel)
        navigationController?.pushViewController(myNftVc, animated: true)
    }

    private func navigateToFavoriteNft() {
        let viewModel = FavoriteNftViewModel()
        let favoriteNftVc = FavoritesNftViewController(viewModel: viewModel)
        navigationController?.pushViewController(favoriteNftVc, animated: true)
    }

    private func navigateToWebSite(url: URL) {
        let websiteVc = WebsiteProfileViewController(websiteUrl: url)
        navigationController?.pushViewController(websiteVc, animated: true)
    }

    private func navigateToEditProfile() {
        let viewModel = EditProfileViewModel()
        let editProfileVC = EditProfileViewController(viewModel: viewModel)
        let editProfileNC = UINavigationController(rootViewController: editProfileVC)
        present(editProfileNC, animated: true)
    }
}

// MARK: - UITableViewDataSource
extension ProfileViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentTableCellTitles.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: ProfileTableViewCell.identifier,
            for: indexPath
        ) as? ProfileTableViewCell else { return UITableViewCell() }

        let title = currentTableCellTitles[indexPath.row]
        cell.bindCell(label: title)
        return cell
    }
}

// MARK: - UITableViewDelegate
extension ProfileViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return ProfileViewController.heightTableCell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0: viewModel.onMyNftClick()
        case 1: viewModel.onFavoriteNftClick()
        case 2: viewModel.onAboutDeveloperClick()
        default: return
        }
    }

}
