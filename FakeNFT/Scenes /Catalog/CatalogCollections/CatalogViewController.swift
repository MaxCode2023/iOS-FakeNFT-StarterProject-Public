import UIKit

final class CatalogViewController: UIViewController {
    private var viewModel: CatalogViewModel
    private var nftCollections = [NftCollection]()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(CatalogTableViewCell.self, forCellReuseIdentifier: CatalogTableViewCell.identifier)
        tableView.separatorStyle = .none
        
        return tableView
    }()
    
    init(viewModel: CatalogViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.viewModel = CatalogViewModel(alertModel: nil)
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        bind()
        viewModel.getNftCollections()
        setupSortButton()
        addSubViews()
        addConstraints()
    }
    
    private func bind() {
        viewModel.$alertModel.bind { [weak self] alertModel in
            guard let self, let alertModel else { return }
            AlertPresenter().show(controller: self, model: alertModel)
        }
        
        viewModel.$nftCollections.bind { [weak self] nftCollections in
            guard let self else { return }
            self.nftCollections = nftCollections
            UIView.transition(with: tableView, duration: 0.3, options: .transitionCrossDissolve, animations: {
                self.tableView.reloadData()
            }, completion: nil)
        }
        
        viewModel.$isLoading.bind { isLoading in
            isLoading ? UIBlockingProgressHUD.show() : UIBlockingProgressHUD.dismiss()
        }
    }
    
    @objc
    private func sortButtonTapped() {
        viewModel.showAlertToSort()
    }
    
    private func setupSortButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(named: "sortIcon"),
            style: .plain,
            target: self,
            action: #selector(sortButtonTapped)
        )
        navigationItem.rightBarButtonItem?.tintColor = .black
    }
    
    private func addConstraints() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
    
    private func addSubViews() {
        view.addSubview(tableView)
    }
}

extension CatalogViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let nftCollection = nftCollections[indexPath.row]
        let nftCollectionVC = NftCollectionViewController(nftCollection: nftCollection)
        navigationController?.pushViewController(nftCollectionVC, animated: true)
    }
}

extension CatalogViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        nftCollections.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CatalogTableViewCell.identifier, for: indexPath) as? CatalogTableViewCell else { return UITableViewCell() }
        cell.configure(by: nftCollections[indexPath.row])
        
        return cell
    }
}
