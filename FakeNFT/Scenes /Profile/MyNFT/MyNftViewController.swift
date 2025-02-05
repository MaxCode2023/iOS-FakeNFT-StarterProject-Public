//
//  MyNftViewController.swift
//  FakeNFT
//
//  Created by Суворов Дмитрий Владимирович on 25.06.2023.
//

import UIKit
import ProgressHUD

final class MyNftViewController: UIViewController {
    private let viewModel: MyNftViewModel

    private var myNfts: [NftView] = []

    private lazy var myNftTableView: UITableView = {
        let myNftTableView = UITableView(frame: .zero, style: .plain)
        myNftTableView.register(MyNftTableViewCell.self, forCellReuseIdentifier: MyNftTableViewCell.identifier)
        myNftTableView.separatorStyle = .none
        myNftTableView.delegate = self
        myNftTableView.dataSource = self
        myNftTableView.translatesAutoresizingMaskIntoConstraints = false
        return myNftTableView
    }()

    private lazy var placeholderLabel: UILabel = {
        let placeholderLabel = UILabel()
        placeholderLabel.textColor = UIColor.textPrimary
        placeholderLabel.font = UIFont.bodyBold
        placeholderLabel.textAlignment = .center
        placeholderLabel.translatesAutoresizingMaskIntoConstraints = false
        return placeholderLabel
    }()

    init(viewModel: MyNftViewModel) {
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

    @objc private func onSortButtonClick() {
        let alert = SortAlertBuilder.buildSortAlert(
            onPriceSort: { [weak self] in
                self?.viewModel.sortMyNftByPrice()
            },
            onRatingSort: { [weak self] in
                self?.viewModel.sortMyNftByRating()
            },
            onNameSort: { [weak self] in
                self?.viewModel.sortMyNftByName()
            }
        )
        present(alert, animated: true)
    }

    private func configureUI() {
        title = "Мои NFT"
        navigationController?.setNavigationBarHidden(false, animated: false)
        navigationController?.navigationBar.tintColor = UIColor.YPBlack
        navigationController?.navigationBar.topItem?.title = ""
        view.backgroundColor = UIColor.background
        configureNavigationBar()
        view.addSubview(myNftTableView)
        view.addSubview(placeholderLabel)
        NSLayoutConstraint.activate([
            myNftTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            myNftTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            myNftTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            myNftTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),

            placeholderLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            placeholderLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    private func configureNavigationBar() {
        let sortButton = UIBarButtonItem(
            image: UIImage(named: "sortIcon"),
            style: .plain,
            target: self,
            action: #selector(onSortButtonClick)
        )
        navigationItem.setRightBarButtonItems([sortButton], animated: true)
    }

    private func initObservers() {
        viewModel.$myNftViewState.bind { [weak self] viewState in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.renderState(viewState: viewState)
            }
        }
    }

    private func renderState(viewState: MyNftViewState) {
        switch viewState {
        case .loading:
            showProgress()

        case .placeholder(let placeholderText):
            hideProgress()
            myNftTableView.isHidden = true
            placeholderLabel.isHidden = false
            placeholderLabel.text = placeholderText

        case .content(let myNftData):
            hideProgress()
            placeholderLabel.isHidden = true
            myNftTableView.isHidden = false
            myNfts = myNftData
            myNftTableView.reloadData()

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

extension MyNftViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myNfts.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: MyNftTableViewCell.identifier,
            for: indexPath
        ) as? MyNftTableViewCell else { return UITableViewCell() }

        let nft = myNfts[indexPath.row]
        cell.bindCell(nftView: nft) { [weak self] in
            self?.viewModel.onLikeTapped(nftView: nft)
        }
        return cell
    }

}

extension MyNftViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
}
