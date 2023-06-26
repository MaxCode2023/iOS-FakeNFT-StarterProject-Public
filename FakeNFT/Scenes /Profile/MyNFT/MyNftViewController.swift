//
//  MyNftViewController.swift
//  FakeNFT
//
//  Created by Суворов Дмитрий Владимирович on 25.06.2023.
//

import UIKit

final class MyNftViewController: UIViewController {
    
    private lazy var myNftTableView: UITableView = {
        let myNftTableView = UITableView(frame: .zero, style: .plain)
        myNftTableView.register(MyNftTableViewCell.self, forCellReuseIdentifier: MyNftTableViewCell.identifier)
        myNftTableView.separatorStyle = .none
        myNftTableView.delegate = self
        myNftTableView.dataSource = self
        return myNftTableView
    }()
}

extension MyNftViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        <#code#>
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        <#code#>
    }
    
    
}

extension MyNftViewController: UITableViewDelegate {
    
}
