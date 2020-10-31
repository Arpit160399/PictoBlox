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
    private let name = "count"
    private var count = 0
    private let configuration = WKWebViewConfiguration()
    private let acivityIndicater = UIActivityIndicatorView()
    private lazy var loadingView: UIView = {
        let loadingView = UIView()
        loadingView.addSubview(acivityIndicater)
        loadingView.backgroundColor = .lightGray
        loadingView.alpha = 0.9
        loadingView.layer.cornerRadius = 15
        acivityIndicater.translatesAutoresizingMaskIntoConstraints = false
        acivityIndicater.centerYAnchor.constraint(equalTo: loadingView.centerYAnchor).isActive = true
        acivityIndicater.centerXAnchor.constraint(equalTo: loadingView.centerXAnchor).isActive = true
        loadingView.translatesAutoresizingMaskIntoConstraints = false
        return loadingView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        addCssFile()
        addScriptFile()
        setUpWebView()
        setUploadView()
    }

    fileprivate func setUpWebView() {
        configuration.userContentController.add(self, name: name)
        webView = WKWebView(frame: .zero, configuration: configuration)
        view.addSubview(webView)
        let url = URL(string: "https://google.com")!
        let request = URLRequest(url: url)
        webView.load(request)
        webView.navigationDelegate = self
        webView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: view.topAnchor),
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            webView.leftAnchor.constraint(equalTo: view.leftAnchor),
            webView.rightAnchor.constraint(equalTo: view.rightAnchor)
        ])
    }
}

// MARK: - Loading css and javascript file

extension ViewController {
    fileprivate func addCssFile() {
        let cssFile = runWebCode(name: "style", type: "css")
        let cssStyle = """
            javascript:(function() {
            var parent = document.getElementsByTagName('head').item(0);
            var style = document.createElement('style');
            style.type = 'text/css';
            style.innerHTML = window.atob('\(encodeStringTo64(fromString: cssFile)!)');
            parent.appendChild(style)})()
        """
        let style = WKUserScript(source: cssStyle, injectionTime: .atDocumentEnd, forMainFrameOnly: false)
        configuration.userContentController.addUserScript(style)
    }

    fileprivate func addScriptFile() {
        let jsFile = runWebCode(name: "script", type: "js")
        let script = WKUserScript(source: jsFile, injectionTime: .atDocumentEnd, forMainFrameOnly: false)
        configuration.userContentController.addUserScript(script)
    }

    func runWebCode(name: String, type: String) -> String {
        guard let path = Bundle.main.path(forResource: name, ofType: type, inDirectory: "web Code") else {
            print("file not found")
            return ""
        }
        do {
            let file = try String(contentsOfFile: path, encoding: .utf8)
            return file
        } catch {
            print(error)
            return ""
        }
    }

    private func encodeStringTo64(fromString: String) -> String? {
        let plainData = fromString.data(using: .utf8)
        return plainData?.base64EncodedString(options: [])
    }
}

// MARK: - Scrpit message handler

extension ViewController: WKScriptMessageHandler {
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        if message.name == name {
            guard let value = message.body as? String else { return }
            count += 1
            let script = "updateLable(\(count))"
            webView.evaluateJavaScript(script, completionHandler: nil)
            showMessage(message: value, second: 1)
        }
    }

    func showMessage(message: String, second: Double) {
        let alert = UIAlertController(title: "Message", message: message, preferredStyle: .alert)
        alert.view.backgroundColor = .black
        alert.view.alpha = 0.6
        alert.view.layer.cornerRadius = 15
        present(alert, animated: true, completion: nil)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + second) {
            alert.dismiss(animated: true, completion: nil)
        }
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
        loadingView.widthAnchor.constraint(equalToConstant: 60).isActive = true
        loadingView.heightAnchor.constraint(equalToConstant: 60).isActive = true
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
