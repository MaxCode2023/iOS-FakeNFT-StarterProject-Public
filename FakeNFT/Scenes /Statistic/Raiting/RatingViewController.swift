//
//  RatingViewController.swift
//  FakeNFT
//
//  Created by macOS on 20.06.2023.
//

import UIKit

final class RatingViewController: UIViewController {
 
    private let sortImageView = UIImageView()
    private let ratingTableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(sortImageView)
        view.addSubview(ratingTableView)
        
        ratingTableView.dataSource = self
        ratingTableView.delegate = self
        ratingTableView.register(UserRatingCell.self)
        ratingTableView.separatorStyle = .none
        
        sortImageView.translatesAutoresizingMaskIntoConstraints = false
        ratingTableView.translatesAutoresizingMaskIntoConstraints = false
        
        sortImageView.image = UIImage(named: "sortIcon")
        
        NSLayoutConstraint.activate([
            sortImageView.heightAnchor.constraint(equalToConstant: 42),
            sortImageView.widthAnchor.constraint(equalToConstant: 42),
            sortImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 2),
            sortImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -9),
            
            ratingTableView.topAnchor.constraint(equalTo: sortImageView.bottomAnchor, constant: 20),
            ratingTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -8),
            ratingTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            ratingTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
}

extension RatingViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UserRatingCell = tableView.dequeueReusableCell()
        
        cell.configure(index: 1, user: nil)
        return cell
    }
    
}
