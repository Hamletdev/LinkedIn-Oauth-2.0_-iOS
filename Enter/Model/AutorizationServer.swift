//
//  UIView.swift
//  Enter
//
//  Created by Amit Chaudhary on 5/18/20.
//  Copyright © 2020 Amit Chaudhary. All rights reserved.
//

import Foundation
import UIKit


let domain = "https://www.linkedin.com/oauth/v2"
let clientId = "ENTER_YOUR_APP_CLIENT_ID"
let clientSecret = "ENTER_YOUR_APP_SECRET"  // get app clientid and client secret from linkedin developer app page.

struct Tokens {
    var accessToken: String
}

struct Profile {
    var name: String?
    var email: String?
}

func base64UrlEncode(_ data: Data) -> String {
    var b64 = data.base64EncodedString()
    b64 = b64.replacingOccurrences(of: "=", with: "")
    b64 = b64.replacingOccurrences(of: "+", with: "-")
    b64 = b64.replacingOccurrences(of: "/", with: "_")
    return b64
}

func generateRandomBytes() -> String? {
    let keyData = Data(count: 32)
    var someKeyData = keyData
    let result = someKeyData.withUnsafeMutableBytes {
        (mutableBytes: UnsafeMutablePointer<UInt8>) -> Int32 in
        SecRandomCopyBytes(kSecRandomDefault, keyData.count, mutableBytes)
    }
    if result == errSecSuccess {
        return base64UrlEncode(keyData)
    } else {
        // TODO: handle error
        return nil
    }
}


class AuthorizationServer {
    private var codeVerifier: String? = nil
    private var savedState: String? = nil
    
    var receivedCode: String? = nil
    var receivedState: String? = nil
    
    private var wkViewController: WebViewController? = nil
    
    func authorize(viewController: UIViewController, webViewController: WebViewController, handler: @escaping (Bool) -> Void) {
        
        savedState = generateRandomBytes()
        
        var urlComp = URLComponents(string: domain + "/authorization")!
        
        urlComp.queryItems = [
            URLQueryItem(name: "response_type", value: "code"),
            URLQueryItem(name: "client_id", value: clientId),
            URLQueryItem(name: "redirect_uri", value: "https://com.appcoda.linkedin.oauth/oauth"),
            URLQueryItem(name: "state", value: savedState),
            URLQueryItem(name: "scope", value: "r_liteprofile,r_emailaddress"),
        ]
        
        webViewController.authURL = urlComp.url!
        webViewController.delegate = (viewController as! WebViewControllerDelegate)
        self.wkViewController = webViewController
        viewController.navigationController?.pushViewController(self.wkViewController!, animated: true)
        handler(true)
        
    }
    
    
    func getProfile(accessToken: String, handler: @escaping (Profile?) -> Void) {
        
        let request = NSMutableURLRequest(url: URL(string: "https://api.linkedin.com/v2/me")! as URL)
        request.httpMethod = "GET"
        
        request.addValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        let task = (URLSession(configuration: URLSessionConfiguration.default)).dataTask(with: request as URLRequest) { (data, response, error) in
            if(error != nil || data == nil) {
                // TODO: handle error
                handler(nil)
                return
            }
            
            
            guard let json = try? JSONSerialization.jsonObject(with: data!) as? [String: Any] else {
                handler(nil)
                // TODO: handle error
                print(error!)
                return
            }
            
            let result = Profile(name: (json["localizedLastName"] as! String), email: (json["id"] as! String))
            handler(result)
            print(result)
        }
        task.resume()
    }
    
    
    func reset() {
        codeVerifier = nil
        savedState = nil
        receivedCode = nil
        receivedState = nil
    }
    
}

