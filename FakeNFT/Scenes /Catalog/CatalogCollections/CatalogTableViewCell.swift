import UIKit

final class CatalogTableViewCell: UITableViewCell {
    static let identifier = String(describing: CatalogTableViewCell.self)
    
    private lazy var nftCollectionCoverImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 12
        imageView.clipsToBounds = true
        
        return imageView
    }()
    
    private lazy var nftCollectionNameLabel: UILabel = {
        let label = UILabel()
        label.font = .bodyBold
        label.textColor = .black
        
        return label
    }()
    
    private lazy var nftCollectionCountLabel: UILabel = {
        let label = UILabel()
        label.font = .bodyBold
        label.textColor = .black
        
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubViews()
        addConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    func configure(by nftCollection: NftCollection) {
        nftCollectionNameLabel.text = nftCollection.name
        nftCollectionCountLabel.text = " (\(nftCollection.nfts.count))"
        loadCover(from: nftCollection.cover)
    }
    
    private func loadCover(from stringUrl: String) {
        guard
            let encodedStringUrl = stringUrl.addingPercentEncoding(
                withAllowedCharacters: .urlQueryAllowed
            ),
            let url = URL(string: encodedStringUrl)
        else {
            return
        }
        
        nftCollectionCoverImageView.setImage(from: url)
    }
    
    private func addConstraints() {
        nftCollectionCoverImageView.translatesAutoresizingMaskIntoConstraints = false
        nftCollectionNameLabel.translatesAutoresizingMaskIntoConstraints = false
        nftCollectionCountLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            nftCollectionCoverImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            nftCollectionCoverImageView.heightAnchor.constraint(equalToConstant: 140),
            nftCollectionCoverImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            nftCollectionCoverImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            nftCollectionNameLabel.topAnchor.constraint(equalTo: nftCollectionCoverImageView.bottomAnchor, constant: 4),
            nftCollectionNameLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            nftCollectionNameLabel.leadingAnchor.constraint(equalTo: nftCollectionCoverImageView.leadingAnchor),
            
            nftCollectionCountLabel.bottomAnchor.constraint(equalTo: nftCollectionNameLabel.bottomAnchor),
            nftCollectionCountLabel.leadingAnchor.constraint(equalTo: nftCollectionNameLabel.trailingAnchor),
        ])
    }
    
    private func addSubViews() {
        contentView.addSubview(nftCollectionCoverImageView)
        contentView.addSubview(nftCollectionNameLabel)
        contentView.addSubview(nftCollectionCountLabel)
    }
}
