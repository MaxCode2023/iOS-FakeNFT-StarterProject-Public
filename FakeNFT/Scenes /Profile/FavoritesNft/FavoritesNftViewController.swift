//
//  FaoritesNftViewController.swift
//  FakeNFT
//
//  Created by Суворов Дмитрий Владимирович on 26.06.2023.
//

import UIKit
import ProgressHUD

final class FavoritesNftViewController: UIViewController {
    private let viewModel: FavoriteNftViewModel

    private var favoriteNfts: [NftView] = []

    private lazy var favoriteNftCollectionView: UICollectionView = {
        let favoriteNftCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        favoriteNftCollectionView.register(FavoritesNftCollectionViewCell.self,
                                forCellWithReuseIdentifier: FavoritesNftCollectionViewCell.identifier)
        favoriteNftCollectionView.dataSource = self
        favoriteNftCollectionView.delegate = self
        favoriteNftCollectionView.translatesAutoresizingMaskIntoConstraints = false
        return favoriteNftCollectionView
    }()

    private lazy var placeholderLabel: UILabel = {
        let placeholderLabel = UILabel()
        placeholderLabel.textColor = UIColor.textPrimary
        placeholderLabel.font = UIFont.bodyBold
        placeholderLabel.textAlignment = .center
        placeholderLabel.translatesAutoresizingMaskIntoConstraints = false
        return placeholderLabel
    }()

    init(viewModel: FavoriteNftViewModel) {
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

    private func configureUI() {
        title = "Избранные NFT"
        view.backgroundColor = UIColor.background
        view.addSubview(favoriteNftCollectionView)
        view.addSubview(placeholderLabel)
        NSLayoutConstraint.activate([
            favoriteNftCollectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            favoriteNftCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            favoriteNftCollectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            favoriteNftCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),

            placeholderLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            placeholderLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    private func initObservers() {
        viewModel.$favoriteNftViewState.bind { [weak self] viewState in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.renderState(viewState: viewState)
            }
        }
    }

    private func renderState(viewState: FavoriteNftViewState) {
        switch viewState {
        case .loading:
            showProgress()

        case .placeholder(let placeholderText):
            hideProgress()
            favoriteNftCollectionView.isHidden = true
            placeholderLabel.isHidden = false
            placeholderLabel.text = placeholderText

        case .content(let favoriteNftData):
            hideProgress()
            placeholderLabel.isHidden = true
            favoriteNftCollectionView.isHidden = false
            favoriteNfts = favoriteNftData
            favoriteNftCollectionView.reloadData()

        case .error(let errorString):
            hideProgress()
            presentErrorDialog(message: errorString)
        }
    }

    private func showProgress() {
        placeholderLabel.isHidden = true
        UIApplication.shared.windows.first?.isUserInteractionEnabled = false
        ProgressHUD.show()
    }

    private func hideProgress() {
        UIApplication.shared.windows.first?.isUserInteractionEnabled = true
        ProgressHUD.dismiss()
    }

}

extension FavoritesNftViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return favoriteNfts.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: FavoritesNftCollectionViewCell.identifier,
            for: indexPath) as? FavoritesNftCollectionViewCell else {
            return UICollectionViewCell()
        }
        let nft = favoriteNfts[indexPath.row]
        cell.bindCell(nftView: nft) { [weak self] in
            self?.viewModel.onLikeTapped(nftView: nft)
        }
        return cell
    }
}

extension FavoritesNftViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.frame.width - 40) / 2
        return CGSize(width: width, height: 80)
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 7
    }
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 20, left: 16, bottom: 20, right: 16)
    }
}
