import UIKit

final class NftCollectionViewController: UIViewController {
    private var nftCollection: NftCollection
    private var collectionViewHeightConstraint = NSLayoutConstraint()
    private var viewModel: NftCollectionViewModel
    private var nftItems = [Nft]()
    private var user: User?
    
    private lazy var scrollView: UIScrollView = {
        let scroll = UIScrollView(frame: view.bounds)
        scroll.backgroundColor = .white
        scroll.contentInsetAdjustmentBehavior = .never
        
        return scroll
    }()
    
    private lazy var nftCoverImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 12
        imageView.clipsToBounds = true
        imageView.backgroundColor = .systemGray
        
        return imageView
    }()
    
    private lazy var nftCollectionNameLabel: UILabel = {
        let label = UILabel()
        label.font = .headline3
        label.textColor = .black
        
        return label
    }()
    
    private lazy var authorNftCollectionLabel: UILabel = {
        let label = UILabel()
        label.text = "catalog.nft_collection_vc.author_of_collection".localized
        label.font = .caption2
        label.textColor = .black
        
        return label
    }()
    
    private lazy var authorDescriptionButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .clear
        button.titleLabel?.font = .caption1
        button.addTarget(self, action: #selector(authorDescriptionButtonTapped), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var nftCollectionDescription: UITextView = {
        let textView = UITextView()
        textView.isEditable = false
        textView.isScrollEnabled = false
        textView.contentInsetAdjustmentBehavior = .never
        textView.textContainerInset = .zero
        textView.textContainer.lineFragmentPadding = 0
        textView.font = .caption2
        textView.textAlignment = .left
        textView.textColor = .black
        
        return textView
    }()
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: UICollectionViewFlowLayout()
        )
        collectionView.register(NftCollectionViewCell.self, forCellWithReuseIdentifier: NftCollectionViewCell.identifier)
        collectionView.backgroundColor = .white
        collectionView.isScrollEnabled = false
        collectionView.delegate = self
        collectionView.dataSource = self
        
        return collectionView
    }()
    
    init(nftCollection: NftCollection, viewModel: NftCollectionViewModel = NftCollectionViewModel()) {
        self.nftCollection = nftCollection
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabBarController?.tabBar.isHidden = true
        view.backgroundColor = .white
        
        bind()
        viewModel.getNftItems()
        
        setupBackBarButtonItem()
        addSubViews()
        addConstraints()
        config()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionViewHeightConstraint.constant = collectionView.collectionViewLayout.collectionViewContentSize.height
    }
    
    private func bind() {
        viewModel.$nftItems.bind { [weak self] nftItems in
            guard let self else { return }
            self.nftItems = nftItems.filter { self.nftCollection.nfts.contains($0.id) }
            
            collectionView.reloadData()
            
            DispatchQueue.main.async {
                self.collectionViewHeightConstraint.constant = self.collectionView.collectionViewLayout.collectionViewContentSize.height
            }
        }
        
        viewModel.$user.bind { [weak self] user in
            guard let self else { return }
            self.user = user
            authorDescriptionButton.setTitle(self.user?.name, for: .normal)
        }
        
        viewModel.$isLoading.bind { isLoading in
            isLoading ? UIBlockingProgressHUD.show() : UIBlockingProgressHUD.dismiss()
        }
    }
    
    private func config() {
        nftCollectionNameLabel.text = nftCollection.name
        nftCollectionDescription.text = nftCollection.description
        viewModel.getUser(userId: nftCollection.author)
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
        
        nftCoverImageView.setImage(from: url)
    }
    
    @objc private func authorDescriptionButtonTapped() {
        guard let userId = user?.id else { return }
        let authorDescriptionVC = AuthorDescriptionViewController(userId: userId)
        navigationController?.pushViewController(authorDescriptionVC, animated: true)
    }
    
    private func setupBackBarButtonItem() {
        let backButton = UIButton(type: .custom)
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        
        let backButtonImageView = UIImageView(image: UIImage(named: "backIcon"))
        let imageSize = CGSize(width: 24, height: 24)
        backButtonImageView.frame = CGRect(origin: .zero, size: imageSize)
        backButton.addSubview(backButtonImageView)
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
    }
    
    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
        tabBarController?.tabBar.isHidden = false
    }
    
    private func addSubViews() {
        view.addSubview(scrollView)
        scrollView.addSubview(nftCoverImageView)
        scrollView.addSubview(nftCollectionNameLabel)
        scrollView.addSubview(authorNftCollectionLabel)
        scrollView.addSubview(authorDescriptionButton)
        scrollView.addSubview(nftCollectionDescription)
        scrollView.addSubview(collectionView)
    }
    
    private func addConstraints() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        nftCoverImageView.translatesAutoresizingMaskIntoConstraints = false
        nftCollectionNameLabel.translatesAutoresizingMaskIntoConstraints = false
        authorNftCollectionLabel.translatesAutoresizingMaskIntoConstraints = false
        authorDescriptionButton.translatesAutoresizingMaskIntoConstraints = false
        nftCollectionDescription.translatesAutoresizingMaskIntoConstraints = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollView.widthAnchor.constraint(equalTo: view.widthAnchor),
            
            nftCoverImageView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            nftCoverImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            nftCoverImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            nftCoverImageView.heightAnchor.constraint(equalToConstant: view.frame.height / 812 * 310),
            
            nftCollectionNameLabel.topAnchor.constraint(equalTo: nftCoverImageView.bottomAnchor, constant: 16),
            nftCollectionNameLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            nftCollectionNameLabel.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16),
            
            authorNftCollectionLabel.topAnchor.constraint(equalTo: nftCollectionNameLabel.bottomAnchor, constant: 13),
            authorNftCollectionLabel.leadingAnchor.constraint(equalTo: nftCollectionNameLabel.leadingAnchor),
            
            authorDescriptionButton.centerYAnchor.constraint(equalTo: authorNftCollectionLabel.centerYAnchor),
            authorDescriptionButton.leadingAnchor.constraint(equalTo: authorNftCollectionLabel.trailingAnchor, constant: 5),
            
            nftCollectionDescription.topAnchor.constraint(equalTo: authorNftCollectionLabel.bottomAnchor, constant: 5),
            nftCollectionDescription.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            nftCollectionDescription.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            collectionView.topAnchor.constraint(equalTo: nftCollectionDescription.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: 20),
        ])
        
        collectionViewHeightConstraint = collectionView.heightAnchor.constraint(equalToConstant: 0)
        collectionViewHeightConstraint.isActive = true
    }
}


extension NftCollectionViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return nftItems.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NftCollectionViewCell.identifier, for: indexPath) as? NftCollectionViewCell else { return UICollectionViewCell() }
        
        cell.config(with: nftItems[indexPath.row])
        
        return cell
    }
}

extension NftCollectionViewController: UICollectionViewDelegate {

}

extension NftCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 24, left: 16, bottom: 54, right: 16)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.bounds.width - (16+10+10+16)) / 3, height: 192)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
}
