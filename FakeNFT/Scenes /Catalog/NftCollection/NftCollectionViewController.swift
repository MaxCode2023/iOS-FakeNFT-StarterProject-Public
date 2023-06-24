import UIKit

final class NftCollectionViewController: UIViewController {
    private let nftCollection: NftCollection
    
    private lazy var nftCoverImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 12
        imageView.clipsToBounds = true
        imageView.backgroundColor = .red
        
        return imageView
    }()
    
    private lazy var nftCollectionNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.appFont(.bold, withSize: 22)
        label.textColor = .black
        label.text = "label.text"
        
        return label
    }()
    
    private lazy var authorNftCollectionLabel: UILabel = {
        let label = UILabel()
        label.text = "AUTHOR_OF_COLLECTION".localized
        label.font = UIFont.appFont(.regular, withSize: 13)
        label.textColor = .black
        
        return label
    }()
    
    private lazy var authorDescriprionButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("John Doe", for: .normal)
        button.backgroundColor = .clear
        
        return button
    }()
    
    private lazy var nftCollectionDescription: UITextView = {
        let textView = UITextView()
        textView.isEditable = false
        textView.isScrollEnabled = false
        textView.contentInsetAdjustmentBehavior = .never
        textView.textContainerInset = .zero
        textView.textContainer.lineFragmentPadding = 0
        textView.font = UIFont.appFont(.regular, withSize: 13)
        textView.textAlignment = .left
        textView.textColor = .black
        
        return textView
    }()
    
    init(nftCollection: NftCollection) {
        self.nftCollection = nftCollection
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        addSubViews()
        addConstraints()
    }
    
    private func addSubViews() {
        view.addSubview(nftCoverImageView)
        view.addSubview(nftCollectionNameLabel)
        view.addSubview(authorNftCollectionLabel)
        view.addSubview(authorDescriprionButton)
        view.addSubview(nftCollectionDescription)
    }
    
    private func addConstraints() {
        nftCoverImageView.translatesAutoresizingMaskIntoConstraints = false
        nftCollectionNameLabel.translatesAutoresizingMaskIntoConstraints = false
        authorNftCollectionLabel.translatesAutoresizingMaskIntoConstraints = false
        authorDescriprionButton.translatesAutoresizingMaskIntoConstraints = false
        nftCollectionDescription.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            nftCoverImageView.topAnchor.constraint(equalTo: view.topAnchor),
            nftCoverImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            nftCoverImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            nftCoverImageView.heightAnchor.constraint(equalToConstant: 310),
            
            nftCollectionNameLabel.topAnchor.constraint(equalTo: nftCoverImageView.bottomAnchor, constant: 16),
            nftCollectionNameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            nftCollectionNameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            authorNftCollectionLabel.topAnchor.constraint(equalTo: nftCollectionNameLabel.bottomAnchor, constant: 13),
            authorNftCollectionLabel.leadingAnchor.constraint(equalTo: nftCollectionNameLabel.leadingAnchor),
            
            authorDescriprionButton.centerYAnchor.constraint(equalTo: authorNftCollectionLabel.centerYAnchor),
            authorDescriprionButton.leadingAnchor.constraint(equalTo: authorNftCollectionLabel.trailingAnchor, constant: 5),
            
            nftCollectionDescription.topAnchor.constraint(equalTo: authorNftCollectionLabel.bottomAnchor, constant: 5),
            nftCollectionDescription.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            nftCollectionDescription.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
        ])
    }
}
