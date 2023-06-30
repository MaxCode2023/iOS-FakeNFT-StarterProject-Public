//
//  EditProfileViewController.swift
//  FakeNFT
//
//  Created by Суворов Дмитрий Владимирович on 30.06.2023.
//

import UIKit

final class EditProfileViewController: UIViewController {

    private let viewModel: EditProfileViewModel

    private lazy var avatarImageView: UIImageView = {
        let avatarImageView = UIImageView()
        avatarImageView.layer.masksToBounds = true
        avatarImageView.layer.cornerRadius = 35
        avatarImageView.clipsToBounds = true
        avatarImageView.translatesAutoresizingMaskIntoConstraints = false
        return avatarImageView
    }()

    private lazy var nameTitleLabel: UILabel = {
        let nameTitleLabel = UILabel()
        nameTitleLabel.font = UIFont.headline3
        nameTitleLabel.textColor = UIColor.textPrimary
        nameTitleLabel.text = "Имя"
        nameTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        return nameTitleLabel
    }()

    private lazy var nameTextField: UITextField = {
        let nameTextField = UITextField()
        nameTextField.font = UIFont.bodyRegular
        nameTextField.textColor = UIColor.textPrimary
        nameTextField.backgroundColor = UIColor.YPLightGrey
        nameTextField.layer.cornerRadius = 12
        nameTextField.translatesAutoresizingMaskIntoConstraints = false
        return nameTextField
    }()

    private lazy var descriptionTitleLabel: UILabel = {
        let descriptionTitleLabel = UILabel()
        descriptionTitleLabel.font = UIFont.headline3
        descriptionTitleLabel.textColor = UIColor.textPrimary
        descriptionTitleLabel.text = "Описание"
        descriptionTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        return descriptionTitleLabel
    }()

    private lazy var descriptionTextField: UITextField = {
        let descriptionTextField = UITextField()
        descriptionTextField.font = UIFont.bodyRegular
        descriptionTextField.textColor = UIColor.textPrimary
        descriptionTextField.backgroundColor = UIColor.YPLightGrey
        descriptionTextField.layer.cornerRadius = 12
        descriptionTextField.translatesAutoresizingMaskIntoConstraints = false
        return descriptionTextField
    }()

    private lazy var urlTitleLabel: UILabel = {
        let urlTitleLabel = UILabel()
        urlTitleLabel.font = UIFont.headline3
        urlTitleLabel.textColor = UIColor.textPrimary
        urlTitleLabel.text = "Сайт"
        urlTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        return urlTitleLabel
    }()

    private lazy var urlTextField: UITextField = {
        let urlTextField = UITextField()
        urlTextField.font = UIFont.bodyRegular
        urlTextField.textColor = UIColor.textPrimary
        urlTextField.backgroundColor = UIColor.YPLightGrey
        urlTextField.layer.cornerRadius = 12
        urlTextField.translatesAutoresizingMaskIntoConstraints = false
        return urlTextField
    }()

    init(viewModel: EditProfileViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        configureUI()
    }

    private func configureUI() {
        view.addSubview(avatarImageView)
        view.addSubview(nameTitleLabel)
        view.addSubview(nameTextField)
        view.addSubview(descriptionTitleLabel)
        view.addSubview(descriptionTextField)
        view.addSubview(urlTitleLabel)
        view.addSubview(urlTextField)

        NSLayoutConstraint.activate([
            avatarImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 22),
            avatarImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            avatarImageView.heightAnchor.constraint(equalToConstant: 70),
            avatarImageView.widthAnchor.constraint(equalToConstant: 70),

            nameTitleLabel.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 24),
            nameTitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            nameTitleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),

            nameTextField.topAnchor.constraint(equalTo: nameTitleLabel.bottomAnchor, constant: 8),
            nameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            nameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            nameTextField.heightAnchor.constraint(equalToConstant: 44),

            descriptionTitleLabel.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 24),
            descriptionTitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            descriptionTitleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),

            descriptionTextField.topAnchor.constraint(equalTo: descriptionTitleLabel.bottomAnchor, constant: 19),
            descriptionTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            descriptionTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            descriptionTextField.heightAnchor.constraint(equalToConstant: 44),

            urlTitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            urlTitleLabel.topAnchor.constraint(equalTo: descriptionTextField.bottomAnchor, constant: 24),

            urlTextField.topAnchor.constraint(equalTo: urlTitleLabel.bottomAnchor, constant: 8),
            urlTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            urlTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            urlTextField.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
}
