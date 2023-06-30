//
//  WebsiteProfileViewController.swift
//  FakeNFT
//
//  Created by macOS on 22.06.2023.
//

import UIKit
import WebKit
import ProgressHUD

final class WebsiteProfileViewController: UIViewController {

    private let websiteUrl: URL

    private let webView = WKWebView()
    private let backButton = UIButton()

    init(websiteUrl: URL) {
        self.websiteUrl = websiteUrl
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        addViews()
        setUpConstraints()
        configureViews()

        ProgressHUD.show()
        webView.navigationDelegate = self

        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            let request = URLRequest(url: self.websiteUrl)
            self.webView.load(request)
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        ProgressHUD.dismiss()
    }

    @objc private func navigateBack() {
        navigationController?.popViewController(animated: true)
    }

    private func configureViews() {
        backButton.setImage(UIImage(named: "backIcon"), for: .normal)
        backButton.addTarget(self, action: #selector(navigateBack), for: .touchUpInside)
    }

    private func addViews() {
        view.addSubview(webView)
        view.addSubview(backButton)
    }

    private func setUpConstraints() {
        webView.translatesAutoresizingMaskIntoConstraints = false
        backButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            backButton.widthAnchor.constraint(equalToConstant: 24),
            backButton.heightAnchor.constraint(equalToConstant: 24),
            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 9),
            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 11),

            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.topAnchor.constraint(equalTo: backButton.bottomAnchor, constant: 8),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            webView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }

}

extension WebsiteProfileViewController: WKNavigationDelegate {

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        ProgressHUD.dismiss()
    }
}
