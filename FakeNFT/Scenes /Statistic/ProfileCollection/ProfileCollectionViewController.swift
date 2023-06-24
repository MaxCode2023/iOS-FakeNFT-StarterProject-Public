//
//  ProfileCollectionViewController.swift
//  FakeNFT
//
//  Created by macOS on 22.06.2023.
//

import UIKit
import ProgressHUD

final class ProfileCollectionViewController: UIViewController {
    
    var nftIds: [Int] = []
    
    private let viewModel = ProfileCollectionViewModel()
    private var nftList: [Nft] = []
    
    private let backButton = UIButton()
    private let titleLabel = UILabel()
    
    private var nftCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    private let params: GeometricParams = GeometricParams(cellCount: 3,
                                                          leftInset: 0,
                                                          rightInset: 0,
                                                          cellHorizontalSpacing: 9,
                                                          cellVerticalSpacing: 8)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        addViews()
        setUpConstraints()
        configureViews()
        
        bind()
        ProgressHUD.show()
        viewModel.getNftCollection(nftIdList: nftIds)
    }
    
    @objc private func navigateBack() {
        navigationController?.popViewController(animated: true)
    }
    
    private func bind() {
        viewModel.$nftList.bind(action: { [weak self] nftList in
            ProgressHUD.dismiss()
            self?.nftList = nftList
            self?.nftCollectionView.reloadData()
        })
        viewModel.$errorMessage.bind { [weak self] errorMessage in
            ProgressHUD.dismiss()
            self?.presentErrorDialog(message: errorMessage)
        }
    }
    
    private func configureViews() {
        backButton.setImage(UIImage(named: "backIcon"), for: .normal)
        backButton.addTarget(self, action: #selector(navigateBack), for: .touchUpInside)
        
        titleLabel.font = .bodyBold
        titleLabel.textColor = .YPBlack
        titleLabel.text = "Коллекция NFT"
        titleLabel.numberOfLines = 1
        titleLabel.textAlignment = .center
        
        nftCollectionView.delegate = self
        nftCollectionView.dataSource = self
        nftCollectionView.register(NftCollectionCell.self)
    }
    
    private func addViews() {
        view.addSubview(backButton)
        view.addSubview(titleLabel)
        view.addSubview(nftCollectionView)
    }
    
    private func setUpConstraints() {
        backButton.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        nftCollectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            backButton.widthAnchor.constraint(equalToConstant: 24),
            backButton.heightAnchor.constraint(equalToConstant: 24),
            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 9),
            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 11),
            
            titleLabel.centerYAnchor.constraint(equalTo: backButton.centerYAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: backButton.trailingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            nftCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            nftCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            nftCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            nftCollectionView.topAnchor.constraint(equalTo: backButton.bottomAnchor, constant: 29)
        ])
    }
    
}

extension ProfileCollectionViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return nftList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: NftCollectionCell = nftCollectionView.dequeueReusableCell(indexPath: indexPath)
        
        cell.configure(nft: nftList[indexPath.row])
        cell.delegate = self
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let availableWidth = collectionView.frame.width - params.paddingWidth
        let cellWidth = availableWidth / CGFloat(params.cellCount)
        return CGSize(width: cellWidth, height: 192)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return params.cellHorizontalSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return params.cellVerticalSpacing
    }

}

extension ProfileCollectionViewController: NftCollectionCellDelegate {
    func onAddToCart(nftName: String) {
        let alert = UIAlertController(title: "NFT \(nftName) добавлена в корзину", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "ОК", style: .default))
        present(alert, animated: true)
    }
}
