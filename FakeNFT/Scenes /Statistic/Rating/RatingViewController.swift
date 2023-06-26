//
//  RatingViewController.swift
//  FakeNFT
//
//  Created by macOS on 20.06.2023.
//

import UIKit
import ProgressHUD

final class RatingViewController: UIViewController {

    private let sortButton = UIButton()
    private let ratingTableView = UITableView()

    private let viewModel = RatingViewModel()
    private var sortAlertPresenter: SortAlertPresenter?

    private var userList: [User] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        self.sortAlertPresenter = SortAlertPresenter(viewController: self)

        addViews()
        setUpConstraints()
        configureViews()

        bind()
        ProgressHUD.show()
        viewModel.getUserList()
    }

    private func bind() {
        viewModel.$userList.bind { [weak self] userList in
            ProgressHUD.dismiss()
            self?.userList = userList
            self?.ratingTableView.reloadData()
        }
        viewModel.$errorMessage.bind { [weak self] errorMessage in
            ProgressHUD.dismiss()
            self?.presentErrorDialog(message: errorMessage)
        }
    }

    private func configureViews() {
        ratingTableView.dataSource = self
        ratingTableView.delegate = self
        ratingTableView.register(UserRatingCell.self)
        ratingTableView.separatorStyle = .none

        ratingTableView.refreshControl = UIRefreshControl()
        ratingTableView.refreshControl?.addTarget(self, action: #selector(refreshRating), for: .valueChanged)

        sortButton.setImage(UIImage(named: "sortIcon"), for: .normal)
        sortButton.addTarget(self, action: #selector(sortButtonTapped), for: .touchUpInside)
    }

    @objc private func sortButtonTapped() {
        sortAlertPresenter?.presentSortDialog(onNameSort: { [weak self] in
            self?.viewModel.sortByName()
        }, onRatingSort: { [weak self] in
            self?.viewModel.sortByRating()
        })
    }

    @objc private func refreshRating() {
        ratingTableView.refreshControl?.endRefreshing()
        viewModel.getUserList()
    }

    private func addViews() {
        view.addSubview(sortButton)
        view.addSubview(ratingTableView)
    }

    private func setUpConstraints() {
        sortButton.translatesAutoresizingMaskIntoConstraints = false
        ratingTableView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            sortButton.heightAnchor.constraint(equalToConstant: 42),
            sortButton.widthAnchor.constraint(equalToConstant: 42),
            sortButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 2),
            sortButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -9),

            ratingTableView.topAnchor.constraint(equalTo: sortButton.bottomAnchor, constant: 20),
            ratingTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -8),
            ratingTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            ratingTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }

}

extension RatingViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        userList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UserRatingCell = tableView.dequeueReusableCell()

        let index = indexPath.row
        cell.configure(index: index, user: userList[index])

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let userId = userList[indexPath.row].id

        if let userId = Int(userId) {
            navigateToRatingProfile(userId: Int(userId))
        }
    }

    private func navigateToRatingProfile(userId: Int) {
        let vc = RatingProfileViewController(userId: userId)
        navigationController?.pushViewController(vc, animated: true)
    }

}
