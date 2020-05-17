//
//  WebViewController.swift
//  Enter
//
//  Created by Amit Chaudhary on 5/17/20.
//  Copyright © 2020 Amit Chaudhary. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: UIViewController, WKUIDelegate {
    
    // MARK: - Properties
    
   lazy var webView: WKWebView = {
        let wbView = WKWebView(frame: CGRect.zero, configuration: WKWebViewConfiguration())
        wbView.uiDelegate = self
        return wbView
    }()

    
    // MARK: - Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.navigationController?.navigationBar.isHidden = false
        self.navigationItem.title = "Authentication"
        
        self.view.addSubview(webView)
        webView.anchorView(self.view.safeAreaLayoutGuide.topAnchor, leftEdge: self.view.safeAreaLayoutGuide.leftAnchor, bottomEdge: self.view.safeAreaLayoutGuide.bottomAnchor, rightEdge: self.view.safeAreaLayoutGuide.rightAnchor, topPadding: 0, leftPadding: 0, bottomPadding: 0, rightPadding: 0, height: 0, width: 0)
        
    }
    

}
