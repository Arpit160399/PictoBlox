//
//  ViewController.swift
//  PictoBlox
//
//  Created by Arpit Singh on 31/10/20.
//

import UIKit
import WebKit
class ViewController: UIViewController {
   
    private var webView: WKWebView!
    private let configuration = WKWebViewConfiguration()
    private let acivityIndicater = UIActivityIndicatorView()
    private var Blog = true
    private let forward = UIButton()
    private let backward = UIButton()
    private let showBlog = UIButton()
    private lazy var loadingView: UIView = {
        let loadingView = UIView()
        loadingView.addSubview(acivityIndicater)
        loadingView.backgroundColor = .black
        loadingView.alpha = 0.9
        loadingView.layer.cornerRadius = 15
        acivityIndicater.translatesAutoresizingMaskIntoConstraints = false
        acivityIndicater.centerYAnchor.constraint(equalTo: loadingView.centerYAnchor).isActive = true
        acivityIndicater.color = .white
        acivityIndicater.centerXAnchor.constraint(equalTo: loadingView.centerXAnchor).isActive = true
        loadingView.translatesAutoresizingMaskIntoConstraints = false
        return loadingView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigation()
        setUpWebView()
        setUploadView()
    }

    fileprivate func setUpWebView() {
        webView = WKWebView(frame: .zero, configuration: configuration)
        view.addSubview(webView)
        let url = URL(string: "https://apple.com")!
        let request = URLRequest(url: url)
        webView.load(request)
        webView.navigationDelegate = self
        webView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            webView.leftAnchor.constraint(equalTo: view.leftAnchor),
            webView.rightAnchor.constraint(equalTo: view.rightAnchor)
        ])
    }
}

// MARK: - setting site Navigation system
extension ViewController {
    
    fileprivate func setUpNavigation(){
        navigationController?.navigationBar.barTintColor = .systemBlue
        navigationController?.navigationBar.tintColor = .white
        forward.setTitle("Forward", for: .normal)
        backward.setTitle("Backward", for: .normal)
        showBlog.setTitle("Blog", for: .normal)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backward)
        navigationItem.rightBarButtonItems = [UIBarButtonItem(customView: forward),UIBarButtonItem(customView: showBlog)]
        forward.addTarget(self, action: #selector(moveForward), for: .touchUpInside)
        backward.addTarget(self, action: #selector(moveBackward), for: .touchUpInside)
        showBlog.addTarget(self, action: #selector(loadHtml), for: .touchUpInside)
    }
    
  @objc func moveForward(){
        webView.goForward()
    }
    
   @objc func moveBackward(){
        webView.goBack()
    }
    
}
// MARK: - Setting Load page

extension ViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        loadingAnimation()
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        stopAnimation()
        if webView.canGoBack {
            backward.isEnabled = true
            backward.alpha = 1
        } else {
            backward.isEnabled = false
            backward.alpha = 0.4
        }
        if webView.canGoForward {
            forward.isEnabled = true
            forward.alpha = 1
        } else {
            forward.isEnabled = false
            forward.alpha = 0.4
        }
    }

    private func setUploadView() {
        loadingView.isHidden = true
        view.addSubview(loadingView)
        loadingView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loadingView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        loadingView.widthAnchor.constraint(equalToConstant: 70).isActive = true
        loadingView.heightAnchor.constraint(equalToConstant: 70).isActive = true
    }

    private func loadingAnimation() {
        loadingView.isHidden = false
        acivityIndicater.startAnimating()
    }

    private func stopAnimation() {
        acivityIndicater.stopAnimating()
        loadingView.isHidden = true
    }
    
    @objc private func loadHtml(){
        if Blog
        {
            guard let path = Bundle.main.path(forResource: "index", ofType: "html", inDirectory: "web Code") else { return }
        do {
        let html = try String(contentsOfFile: path)
        webView.loadHTMLString(html, baseURL: nil)
            showBlog.setTitle("Site", for: .normal)
        } catch {
           print(error)
        }
        } else {
            let url = URL(string: "https://apple.com")!
            let request = URLRequest(url: url)
            showBlog.setTitle("Blog", for: .normal)
            webView.load(request)
        }
        Blog = !Blog
    }
    
}
