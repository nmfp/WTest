//
//  WebController.swift
//  WTest
//
//  Created by Nuno Pereira on 03/03/2019.
//  Copyright © 2019 Nuno Pereira. All rights reserved.
//

import UIKit
import WebKit

class WebController: UIViewController {

    lazy var webView: WKWebView = {
        let wv = WKWebView()
        wv.translatesAutoresizingMaskIntoConstraints = false
        return wv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
        loadPage()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        loadPage()
    }
    
    private func setupViews() {
        view.addSubview(webView)
        webView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor)
    }
    
    private func loadPage() {
        
        
        
    }
}
