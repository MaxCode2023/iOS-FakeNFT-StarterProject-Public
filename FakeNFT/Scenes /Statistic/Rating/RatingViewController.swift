//
//  RatingViewController.swift
//  FakeNFT
//
//  Created by macOS on 20.06.2023.
//

import UIKit
import ProgressHUD

final class RatingViewController: UIViewController {
    
    private let sortImageButton = UIButton()
    private let ratingTableView = UITableView()
    
    private let viewModel = RatingViewModel()
    
    private var userList: [User] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(sortImageButton)
        view.addSubview(ratingTableView)
        
        setUpConstraints()
        configureViews()
        
        bind()
        
        sortImageButton.addTarget(self, action: #selector(clickSort), for: .touchUpInside)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
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
    
    @objc private func clickSort() {
        presentSortDialog()
    }
    
    private func presentSortDialog() {
        let sortDialog = UIAlertController(title: "Сортировка", message: nil, preferredStyle: .actionSheet)
        
        sortDialog.addAction(UIAlertAction(title: "По имени", style: .default) { [weak self]_ in
            self?.viewModel.sortByName()
        })
        sortDialog.addAction(UIAlertAction(title: "По рейтингу", style: .default) { [weak self] _ in
            self?.viewModel.sortByRating()
        })
        sortDialog.addAction(UIAlertAction(title: "Закрыть", style: .cancel))
        
        present(sortDialog, animated: true)
    }
    
    private func presentErrorDialog(message: String?) {
        let errorDialog = UIAlertController(title: "Ошибка!", message: message, preferredStyle: .alert)
        errorDialog.addAction(UIAlertAction(title: "Ок", style: .default))
        present(errorDialog, animated: true)
    }
    
    private func configureViews() {
        ratingTableView.dataSource = self
        ratingTableView.delegate = self
        ratingTableView.register(UserRatingCell.self)
        ratingTableView.separatorStyle = .none
        
        sortImageButton.setImage(UIImage(named: "sortIcon"), for: .normal)
    }
    
    private func setUpConstraints() {
        sortImageButton.translatesAutoresizingMaskIntoConstraints = false
        ratingTableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            sortImageButton.heightAnchor.constraint(equalToConstant: 42),
            sortImageButton.widthAnchor.constraint(equalToConstant: 42),
            sortImageButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 2),
            sortImageButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -9),
            
            ratingTableView.topAnchor.constraint(equalTo: sortImageButton.bottomAnchor, constant: 20),
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
    
}
