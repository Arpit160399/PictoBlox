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
        view.backgroundColor = .white
        setUpWebView()
        setUpToolBar()
        setUploadView()
        
    }
    
    fileprivate func setUpWebView() {
        webView = WKWebView(frame: .zero, configuration: configuration)
        view.addSubview(webView)
        let url = URL(string: "https://developer.apple.com/documentation/webkit/wkwebview")!
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
    
    fileprivate func setUpToolBar(){
     let toolBar = UIToolbar()
        toolBar.setItems([UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(moveBackward))], animated: false)
        view.addSubview(toolBar)
        toolBar.translatesAutoresizingMaskIntoConstraints = false
        toolBar.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        toolBar.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        toolBar.bottomAnchor.constraint(equalTo: view.bottomAnchor,constant: -15).isActive = true
    }
    
 
   @objc func moveBackward(){
        dismiss(animated: true, completion: nil)
    }
    
}

// MARK: - Setting Load page

extension ViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        loadingAnimation()
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        stopAnimation()
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
}
