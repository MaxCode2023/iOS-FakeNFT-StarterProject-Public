//
//  ProfileViewController.swift
//  FakeNFT
//
//  Created by Суворов Дмитрий Владимирович on 22.06.2023.
//

import UIKit
import ProgressHUD
import Kingfisher

final class ProfileViewController: UIViewController {
    private static let countTableRows = 3
    private static let heightTableCell = CGFloat(54)

    private let viewModel: ProfileViewModel

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

    init(viewModel: ProfileViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        initObservers()
        
        viewModel.onViewCreated()
    }

    @objc private func onEditIconClick() {

    }

    @objc private func onUrlButtonClick() {

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

            self.renderState(viewState: viewState)
        }
    }

    private func renderState(viewState: ProfileViewState) {
        switch viewState {
        case .loading:
            showProgress()
        case .content(let profileData):
            renderProfileData(profile: profileData)
        case .error(let errorString):
            showError(errorString: errorString)
        }
    }

    private func showProgress() {
        DispatchQueue.main.async {
            UIApplication.shared.windows.first?.isUserInteractionEnabled = false
            ProgressHUD.show()
        }
    }

    private func hideProgress() {
        DispatchQueue.main.async {
            UIApplication.shared.windows.first?.isUserInteractionEnabled = false
            ProgressHUD.dismiss()
        }
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

    private func showError(errorString: String) {
        hideProgress()
        let alert = UIAlertController(
            title: "Что-то пошло не так",
            message: errorString,
            preferredStyle: .alert)

        let action = UIAlertAction(title: "OK", style: .default) { [weak self] _ in
            self?.dismiss(animated: true)
        }
        alert.addAction(action)

        present(alert, animated: true, completion: nil)
    }
}

// MARK: - UITableViewDataSource
extension ProfileViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ProfileViewController.countTableRows
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell =
                tableView.dequeueReusableCell(withIdentifier: ProfileTableViewCell.identifier, for: indexPath) as? ProfileTableViewCell else { return UITableViewCell() }

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
        // TODO: - Реализовать логику перехода
    }

}
