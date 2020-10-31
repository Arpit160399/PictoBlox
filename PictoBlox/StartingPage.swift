//
//  StartingPage.swift
//  PictoBlox
//
//  Created by Arpit Singh on 31/10/20.
//

import UIKit
class StartingPage: UIViewController {
    
    private let goToDocument = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setUpButton()
    }
    
    func setUpButton(){
        goToDocument.setTitle("Go to see the WkWebView Document",for: .normal)
        goToDocument.setTitleColor(.systemBlue, for: .normal)
        view.addSubview(goToDocument)
        goToDocument.translatesAutoresizingMaskIntoConstraints = false
        goToDocument.addTarget(self, action: #selector(goToDoc), for: .touchUpInside)
        NSLayoutConstraint.activate([
            goToDocument.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            goToDocument.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            goToDocument.widthAnchor.constraint(equalToConstant: view.frame.width)
        ])
    }
    
    @objc func goToDoc(){
        let webViewController = ViewController()
        webViewController.modalPresentationStyle = .fullScreen
        present(webViewController, animated: true, completion: nil)
    }
}
