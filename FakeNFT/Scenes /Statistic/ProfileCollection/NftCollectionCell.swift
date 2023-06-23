//
//  NftCollectionCell.swift
//  FakeNFT
//
//  Created by macOS on 23.06.2023.
//

import UIKit

final class NftCollectionCell: UICollectionViewCell, ReuseIdentifying {
    
    func configure() {
        let view = UIView()
//        view.backgroundColor = .red
        contentView.addSubview(view)
        contentView.backgroundColor = .blue
        
        view.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            view.widthAnchor.constraint(equalToConstant: 50),
            view.heightAnchor.constraint(equalToConstant: 50),
        ])
    }
}
