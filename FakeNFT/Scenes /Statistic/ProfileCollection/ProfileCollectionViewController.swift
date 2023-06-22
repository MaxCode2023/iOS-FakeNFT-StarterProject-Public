//
//  ProfileCollectionViewController.swift
//  FakeNFT
//
//  Created by macOS on 22.06.2023.
//

import UIKit

final class ProfileCollectionViewController: UIViewController {
    
    private let backButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        view.addSubview(backButton)
        setUpConstraints()
        
        backButton.setImage(UIImage(named: "backIcon"), for: .normal)
        backButton.addTarget(self, action: #selector(navigateBack), for: .touchUpInside)
    }
    
    @objc private func navigateBack() {
        navigationController?.popViewController(animated: true)
    }
    
    private func setUpConstraints() {
        backButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            backButton.widthAnchor.constraint(equalToConstant: 24),
            backButton.heightAnchor.constraint(equalToConstant: 24),
            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 9),
            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 11),
        ])
    }
    
}
