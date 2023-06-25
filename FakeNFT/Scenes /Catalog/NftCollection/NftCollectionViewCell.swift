import UIKit

final class NftCollectionViewCell: UICollectionViewCell {
    static let identifier = "collectionCell"
    
    private lazy var nftImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 12
        imageView.clipsToBounds = true
        imageView.backgroundColor = .systemGray
        
        return imageView
    }()
    
    private lazy var starsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .leading
        stackView.distribution = .fillProportionally
        stackView.spacing = 2
        
       
        for _ in 1...5 {
            let imageView = UIImageView(image: UIImage(named: "star.empty"))
            stackView.addArrangedSubview(imageView)
        }
        return stackView
    }()
    
    private lazy var nftNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Archie"
        label.font = UIFont.appFont(.bold, withSize: 17)
        label.textColor = .black
        
        return label
    }()
    
    private lazy var priceNftLabel: UILabel = {
        let label = UILabel()
        label.text = "100 $"
        label.font = UIFont.appFont(.medium, withSize: 10)
        label.textColor = .black
        
        return label
    }()
    
    private lazy var cartButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .clear
        button.addTarget(self, action: #selector(cartButtonTapped), for: .touchUpInside)
        button.setImage(UIImage(named: "cart.full"), for: .normal)
        button.tintColor = .black
        
        return button
    }()
    
    private lazy var likeButton: UIButton = {
        let button = UIButton(type: .custom)
        button.backgroundColor = .clear
        button.addTarget(self, action: #selector(likeButtonTapped), for: .touchUpInside)
        button.setImage(UIImage(named: "like.empty"), for: .normal)
        
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubviews()
        addConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func config(with nft: String) {
        nftNameLabel.text = nft
    }
    
    @objc private func cartButtonTapped() {
        
    }
    
    @objc private func likeButtonTapped() {
        
    }
    
    private func addSubviews() {
        contentView.addSubview(nftImageView)
        contentView.addSubview(starsStackView)
        contentView.addSubview(nftNameLabel)
        contentView.addSubview(priceNftLabel)
        contentView.addSubview(cartButton)
        contentView.addSubview(likeButton)
    }
    
    private func addConstraints() {
        nftImageView.translatesAutoresizingMaskIntoConstraints = false
        starsStackView.translatesAutoresizingMaskIntoConstraints = false
        nftNameLabel.translatesAutoresizingMaskIntoConstraints = false
        priceNftLabel.translatesAutoresizingMaskIntoConstraints = false
        cartButton.translatesAutoresizingMaskIntoConstraints = false
        likeButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            nftImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            nftImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            nftImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            nftImageView.heightAnchor.constraint(equalTo: nftImageView.widthAnchor),
            
            starsStackView.topAnchor.constraint(equalTo: nftImageView.bottomAnchor, constant: 8),
            starsStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            
            nftNameLabel.topAnchor.constraint(equalTo: starsStackView.bottomAnchor, constant: 5),
            nftNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            
            priceNftLabel.topAnchor.constraint(equalTo: nftNameLabel.bottomAnchor, constant: 5),
            priceNftLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            
            cartButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            cartButton.leadingAnchor.constraint(equalTo: nftNameLabel.trailingAnchor),
            cartButton.widthAnchor.constraint(equalToConstant: 40),
            cartButton.heightAnchor.constraint(equalToConstant: 40),
            cartButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20),
            
            likeButton.topAnchor.constraint(equalTo: contentView.topAnchor),
            likeButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
        ])
    }
}
