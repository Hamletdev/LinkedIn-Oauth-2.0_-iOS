//
//  WebViewController.swift
//  Enter
//
//  Created by Amit Chaudhary on 5/18/20.
//  Copyright © 2020 Amit Chaudhary. All rights reserved.
//

import UIKit
import WebKit

protocol WebViewControllerDelegate {
    func updateAccessToken(_ accessToken: String)
}

let authorizationEndPoint = "https://www.linkedin.com/oauth/v2/authorization"
let accessTokenEndPoint = "https://www.linkedin.com/oauth/v2/accessToken"

class WebViewController: UIViewController, WKUIDelegate, WKNavigationDelegate {
    
    // MARK: - Properties
    
    var authURL = URL(string: "")
    
    var delegate: WebViewControllerDelegate?
    
    
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
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Dismiss", style: UIBarButtonItem.Style.plain, target: self, action: #selector(dismissWebView))
        
        self.view.addSubview(webView)
        webView.anchorView(self.view.safeAreaLayoutGuide.topAnchor, leftEdge: self.view.safeAreaLayoutGuide.leftAnchor, bottomEdge: self.view.safeAreaLayoutGuide.bottomAnchor, rightEdge: self.view.safeAreaLayoutGuide.rightAnchor, topPadding: 0, leftPadding: 0, bottomPadding: 0, rightPadding: 0, height: 0, width: 0)
        
        webView.navigationDelegate = self
        self.startAuthorization(self.authURL!)
    }
    
    
    // MARK: - UIDelegate
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        
        let url = navigationAction.request.url!
        if url.host == "com.appcoda.linkedin.oauth" {
            if url.absoluteString.range(of:"code") != nil {
                let urlParts = url.absoluteString.components(separatedBy:"?")
                let code = urlParts[1].components(separatedBy:"=")[1]
                print("Code:", String(code.dropLast(6)))
                requestForAccessToken(authorizationCode:String(code.dropLast(6) ))
            }
        }
        decisionHandler(.allow)
        
    }
    
}

extension WebViewController {
    
    @objc func dismissWebView() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func dismissFinally() {
        self.navigationController?.popViewController(animated: true)
        
    }
    
    func startAuthorization(_ url: URL) {
        self.webView.load(URLRequest(url: url))
    }
    
    
    func  requestForAccessToken(authorizationCode:String) {
        let grantType = "authorization_code"
        //Enter redirect url here
        let redirectURL = "https://com.appcoda.linkedin.oauth/oauth".addingPercentEncoding(withAllowedCharacters: .alphanumerics)!
        // Set the POST parameters.
        print(redirectURL)
        var postParams = "grant_type=\(grantType)&"
        postParams += "code=\(authorizationCode)&"
        postParams += "redirect_uri=\(redirectURL)&"
        postParams += "client_id=\(clientId)&"
        postParams += "client_secret=\(clientSecret)"
        
        
        let postData = postParams.data(using: String.Encoding.utf8)
        
        let request = NSMutableURLRequest(url: URL(string: accessTokenEndPoint)! as URL)
        
        request.httpMethod = "POST"
        request.httpBody = postData
        request.addValue("application/x-www-form-urlencoded;", forHTTPHeaderField: "Content-Type")
        let session = URLSession(configuration: URLSessionConfiguration.default)
        
        let task: URLSessionDataTask = session.dataTask(with: request as URLRequest) { (data, response, error) -> Void in
            // Get the HTTP status code of the request.
            let statusCode = (response as! HTTPURLResponse).statusCode
            print("Status code", statusCode)
            if statusCode == 200 {
                // Convert the received JSON data into a dictionary.
                do {
                    let dataDictionary = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as! [String:Any]
                    
                    let accessToken = dataDictionary["access_token"] as! String
                    // Now you get access token and you can use it for get profile info and other operations
                    UserDefaults.standard.set(accessToken, forKey: "LIAccessToken")
                    UserDefaults.standard.synchronize()
                    DispatchQueue.main.async {
                        self.delegate?.updateAccessToken(accessToken)
                        self.dismissFinally()
                    }
                } catch {
                    print("Could not convert JSON data into a dictionary.")
                }
            } else {
                print("cancel clicked")
            }
        }
        task.resume()
    }
    
    
}
