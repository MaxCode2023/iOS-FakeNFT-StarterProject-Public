//
//  EditProfileViewController.swift
//  FakeNFT
//
//  Created by Суворов Дмитрий Владимирович on 30.06.2023.
//

import UIKit

final class EditProfileViewController: UIViewController {

    private let viewModel: EditProfileViewModel
    private var currentProfileData: EditProfileViewState.EditProfileData?

    private lazy var avatarImageView: UIImageView = {
        let avatarImageView = UIImageView()
        avatarImageView.layer.masksToBounds = true
        avatarImageView.layer.cornerRadius = 35
        avatarImageView.clipsToBounds = true
        avatarImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showAvatarChangeAlert)))
        avatarImageView.isUserInteractionEnabled = true
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
        nameTextField.addTarget(self, action: #selector(onNameChanged), for: UIControl.Event.allEditingEvents)
        nameTextField.translatesAutoresizingMaskIntoConstraints = false

        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: nameTextField.frame.height))
        nameTextField.leftView = paddingView
        nameTextField.rightView = paddingView
        nameTextField.leftViewMode = .always
        nameTextField.rightViewMode = .always
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

    private lazy var descriptionTextField: UITextView = {
        let descriptionTextField = UITextView()
        descriptionTextField.font = UIFont.bodyRegular
        descriptionTextField.textColor = UIColor.textPrimary
        descriptionTextField.backgroundColor = UIColor.YPLightGrey
        descriptionTextField.layer.cornerRadius = 12
        descriptionTextField.delegate = self
        descriptionTextField.isScrollEnabled = false
        descriptionTextField.contentInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: -16)
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
        urlTextField.addTarget(self, action: #selector(onUrlChanged), for: UIControl.Event.allEditingEvents)
        urlTextField.translatesAutoresizingMaskIntoConstraints = false

        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: urlTextField.frame.height))
        urlTextField.leftView = paddingView
        urlTextField.rightView = paddingView
        urlTextField.leftViewMode = .always
        urlTextField.rightViewMode = .always
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
        initObservers()

        viewModel.onViewDidLoad()
    }

    override func viewWillDisappear(_ animated: Bool) {
        viewModel.onViewWillDisappear()
        super.viewWillDisappear(animated)
    }

    @objc
    private func onNameChanged(_ sender: UITextInput) {
        viewModel.updateName(newName: nameTextField.text)
    }

    @objc
    private func onDescriptionChanged(_ sender: UITextInput) {
        viewModel.updateDescription(newDescription: descriptionTextField.text)
    }

    @objc
    private func onUrlChanged(_ sender: UITextInput) {
        viewModel.updateWebsite(newWebsite: urlTextField.text)
    }

    @objc
    private func showAvatarChangeAlert() {
        let alert = UIAlertController(title: "Сменить автар", message: "Введите новый URL", preferredStyle: .alert)

        alert.addTextField { [weak self] textField in
            guard let self = self, let currentAvatar = self.currentProfileData?.avatar else { return }
            textField.text = currentAvatar
        }
        let alertAction = UIAlertAction(title: "OK", style: .default, handler: { [weak self] (_) in
            self?.viewModel.updateAvatar(newAvatar: alert.textFields?[0].text)
        })
        alert.addAction(alertAction)

        self.present(alert, animated: true, completion: nil)
    }

    @objc
    private func onCloseButtonClick() {
        dismiss(animated: true)
    }

    private func configureUI() {
        configureNavigationBar()
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

            urlTitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            urlTitleLabel.topAnchor.constraint(equalTo: descriptionTextField.bottomAnchor, constant: 24),

            urlTextField.topAnchor.constraint(equalTo: urlTitleLabel.bottomAnchor, constant: 8),
            urlTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            urlTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            urlTextField.heightAnchor.constraint(equalToConstant: 44)
        ])
    }

    private func configureNavigationBar() {
        let closeButton = UIBarButtonItem(
            image: UIImage(named: "closeIcon"),
            style: .plain,
            target: self,
            action: #selector(onCloseButtonClick)
        )
        closeButton.tintColor = UIColor.YPBlack
        navigationItem.setRightBarButton(closeButton, animated: true)
    }

    private func initObservers() {
        viewModel.$editProfileViewState.bind { [weak self] viewState in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.renderState(viewState: viewState)
            }
        }
    }

    private func renderState(viewState: EditProfileViewState?) {
        guard let viewState = viewState else { return }

        switch viewState {
        case .content(let editProfileData):
            currentProfileData = editProfileData

            nameTextField.text = editProfileData.name
            descriptionTextField.text = editProfileData.description
            avatarImageView.kf.setImage(with: URL(string: editProfileData.avatar))
            urlTextField.text = editProfileData.website
        }
    }
}

extension EditProfileViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        viewModel.updateDescription(newDescription: descriptionTextField.text)
    }
}
