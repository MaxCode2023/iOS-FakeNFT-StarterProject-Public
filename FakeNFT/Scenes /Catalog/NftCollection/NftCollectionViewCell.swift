import UIKit

final class NftCollectionViewCell: UICollectionViewCell {
    static let identifier = String(describing: NftCollectionViewCell.self)
    private var isLiked = false
    private var isAddToCart = false
    
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
        
        return stackView
    }()
    
    private lazy var nftNameLabel: UILabel = {
        let label = UILabel()
        label.font = .bodyBold
        label.textColor = .black
        
        return label
    }()
    
    private lazy var priceNftLabel: UILabel = {
        let label = UILabel()
        label.font = .caption3
        label.textColor = .black
        
        return label
    }()
    
    private lazy var cartButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .clear
        button.addTarget(self, action: #selector(cartButtonTapped), for: .touchUpInside)
        button.setImage(UIImage(named: "cartIcon"), for: .normal)
        button.tintColor = .black
        
        return button
    }()
    
    private lazy var likeButton: UIButton = {
        let button = UIButton(type: .custom)
        button.backgroundColor = .clear
        button.addTarget(self, action: #selector(likeButtonTapped), for: .touchUpInside)
        button.setImage(UIImage(named: "likeDisabledIcon"), for: .normal)
        
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
    
    func config(with nft: Nft) {
        nftNameLabel.text = nft.name
        priceNftLabel.text = String(nft.price) + " ETH"
        setupRating(nft: nft)
        loadCover(from: nft.images.first)
    }
    
    private func loadCover(from stringUrl: String?) {
        guard
            let nftUrl = stringUrl,
            let encodedStringUrl = nftUrl.addingPercentEncoding(
                withAllowedCharacters: .urlQueryAllowed
            ),
            let url = URL(string: encodedStringUrl)
        else {
            return
        }
        
        nftImageView.setImage(from: url)
    }
    
    private func setupRating(nft: Nft) {
        (1...nft.rating).forEach { _ in
            let imageView = UIImageView(image: UIImage(named: "starIcon"))
            starsStackView.addArrangedSubview(imageView)
        }
        
        if nft.rating < 5 {
            (1...(5 - nft.rating)).forEach { _ in
                let imageView = UIImageView(image: UIImage(named: "starDisabledIcon"))
                starsStackView.addArrangedSubview(imageView)
            }
        }
    }
    
    @objc private func cartButtonTapped() {
        isAddToCart.toggle()
        let imageName = isAddToCart ? "cartIconFull" : "cartIcon"
        cartButton.setImage(UIImage(named: imageName), for: .normal)
    }
    
    @objc private func likeButtonTapped() {
        isLiked.toggle()
        let imageName = isLiked ? "likeIcon" : "likeDisabledIcon"
        likeButton.setImage(UIImage(named: imageName), for: .normal)
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
            
            likeButton.centerYAnchor.constraint(equalTo: contentView.topAnchor, constant: 15),
            likeButton.centerXAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
        ])
    }
}
