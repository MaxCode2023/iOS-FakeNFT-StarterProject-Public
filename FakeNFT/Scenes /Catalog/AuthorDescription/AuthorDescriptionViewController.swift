import UIKit
import WebKit

final class AuthorDescriptionViewController: UIViewController {
    private let userId: String
    private let viewModel: AuthorDescriptionViewModel
    private let webView = WKWebView()
    
    init(userId: String, viewModel: AuthorDescriptionViewModel = AuthorDescriptionViewModel()) {
        self.userId = userId
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        bind()
        viewModel.getUser(userId: userId)
        setupBackBarButtonItem()
        addSubViews()
        addConstraints()
    }
    
    private func bind() {
        viewModel.$user.bind { [weak self] user in
            guard let self, let stringUrl = user?.website else { return }
            configWebView(with: stringUrl)
        }
        
        viewModel.$isLoading.bind { isLoading in
            if isLoading {
                UIBlockingProgressHUD.show()
            } else {
                UIBlockingProgressHUD.dismiss()
            }
        }
    }
    
    private func setupBackBarButtonItem() {
        let backButton = UIButton(type: .custom)
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        
        let backButtonImageView = UIImageView(image: UIImage(named: "backButton"))
        let imageSize = CGSize(width: 24, height: 24)
        backButtonImageView.frame = CGRect(origin: .zero, size: imageSize)
        backButton.addSubview(backButtonImageView)
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
    }
    
    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    private func configWebView(with urlString: String) {
        webView.navigationDelegate = self
        DispatchQueue.main.async { [weak self] in
            guard let self, let url = URL(string: urlString) else { return }
            let request = URLRequest(url: url)
            self.webView.load(request)
        }
    }
    
    private func addSubViews() {
        view.addSubview(webView)
    }
    
    private func addConstraints() {
        webView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
}

extension AuthorDescriptionViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        viewModel.finishLoading()
    }
}
