import UIKit

final class CatalogTableViewCell: UITableViewCell {
    static let identifier = "catalogCell"
    
    private lazy var nftImageStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [nftOneImageView, nftTwoImageView, nftThreeImageView])
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 0
        stackView.alignment = .center
        stackView.layer.cornerRadius = 12
        stackView.backgroundColor = .green
        stackView.clipsToBounds = true
        
        return stackView
    }()
    
    private lazy var nftOneImageView: UIImageView = {
        let image = UIImage(named: "1")
        let imageView = UIImageView(image: image)
        imageView.contentMode = .center
        imageView.clipsToBounds = true
        
        
        return imageView
    }()
    
    private lazy var nftTwoImageView: UIImageView = {
        let image = UIImage(named: "2")
        let imageView = UIImageView(image: image)
        imageView.contentMode = .center
        imageView.clipsToBounds = true
        
        return imageView
    }()
    
    private lazy var nftThreeImageView: UIImageView = {
        let image = UIImage(named: "3")
        let imageView = UIImageView(image: image)
        imageView.contentMode = .center
        imageView.clipsToBounds = true
        
        return imageView
    }()
    
    private lazy var nftCollectionNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Peach (11)"
        label.font = UIFont.appFont(.bold, withSize: 17)
        label.textColor = .black//UIColor(named: "YP-Gray")
        
        return label
    }()
   
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
//        self.backgroundColor = 
//        contentView.backgroundColor = .orange//UIColor(named: "YP-LightBlack")
        addSubViews()
        addConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()

    }
    
//    override func layoutSubviews() {
//        super.layoutSubviews()
//
//        let margins = UIEdgeInsets(top: 21, left: 0, bottom: 0, right: 0)
//        contentView.frame = contentView.frame.inset(by: margins)
//        contentView.layer.cornerRadius = 24
//    }
    
    private func addConstraints() {
        nftImageStackView.translatesAutoresizingMaskIntoConstraints = false
        nftCollectionNameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            nftImageStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            nftImageStackView.heightAnchor.constraint(equalToConstant: 140),
//            nftImageStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            nftImageStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            nftImageStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            nftCollectionNameLabel.topAnchor.constraint(equalTo: nftImageStackView.bottomAnchor, constant: 4),
            nftCollectionNameLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            nftCollectionNameLabel.leadingAnchor.constraint(equalTo: nftImageStackView.leadingAnchor),
//            nftCollectionNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
        ])
    }
    
    private func addSubViews() {
        contentView.addSubview(nftImageStackView)
        contentView.addSubview(nftCollectionNameLabel)
    }
    
    
}
