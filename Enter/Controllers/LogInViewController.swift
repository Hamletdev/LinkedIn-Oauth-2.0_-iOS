//
//  LogInViewController.swift
//  Enter
//
//  Created by Amit Chaudhary on 5/17/20.
//  Copyright © 2020 Amit Chaudhary. All rights reserved.
//

import UIKit

class LogInViewController: UIViewController, WebViewControllerDelegate {
    
    
    // MARK: - Properties
    
    let authServer = AuthorizationServer()
    let webVC = WebViewController()
    
    var tokens: Tokens?
    var profile: Profile? = nil
    
    
    
    let logoContainerView: UIView = {
        let logoIV = UIView()
        logoIV.backgroundColor = UIColor(red: 25/255, green: 98/255, blue: 166/255, alpha: 1.0)
        
        let logoLabel = UILabel()
        logoLabel.text = "LinkedIn"
        logoLabel.textColor = .white
        logoLabel.numberOfLines = 0
        logoLabel.font = .systemFont(ofSize: 40, weight: UIFont.Weight.heavy)
        logoIV.addSubview(logoLabel)
        
        logoLabel.centerYAnchor.constraint(equalTo: logoIV.centerYAnchor).isActive = true
        logoLabel.centerXAnchor.constraint(equalTo: logoIV.centerXAnchor).isActive = true
        logoLabel.anchorView(nil, leftEdge: nil, bottomEdge: nil, rightEdge: nil, topPadding: 0, leftPadding: 0, bottomPadding: 0, rightPadding: 0, height: 0, width: 0)
        
        return logoIV
    }()
    
    let logInButton: UIButton = {
        let inButton = UIButton(type: UIButton.ButtonType.system)
        inButton.layer.cornerRadius = 4
        inButton.backgroundColor = .systemBlue
        inButton.titleLabel?.numberOfLines = 0
        inButton.setTitle("Login", for: .normal)
        inButton.setTitleColor(.white, for: .normal)
        inButton.titleLabel?.font = .systemFont(ofSize: 20, weight: UIFont.Weight.medium)
        inButton.addTarget(self, action: #selector(logInButtonTapped), for: UIControl.Event.touchUpInside)
        
        return inButton
    }()
    
    let statusLabel: UILabel = {
        let statLabel = UILabel()
        statLabel.numberOfLines = 0
        statLabel.adjustsFontSizeToFitWidth = true
        
        let mutAttrString = NSMutableAttributedString(string: "Status:", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18, weight: UIFont.Weight.thin), NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        mutAttrString.append(NSAttributedString(string: "  Not Logged In", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 20, weight: UIFont.Weight.medium), NSAttributedString.Key.foregroundColor: UIColor.black]))
        statLabel.attributedText = mutAttrString
        
        statLabel.textAlignment = .center
        return statLabel
    }()
    
    let fullNameLabel: UILabel = {
        let fnLabel = UILabel()
        fnLabel.numberOfLines = 0
        fnLabel.adjustsFontSizeToFitWidth = true
        
        let mutAttrString = NSMutableAttributedString(string: "Last Name:", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18, weight: UIFont.Weight.thin), NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        mutAttrString.append(NSAttributedString(string: "  No Name", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 20, weight: UIFont.Weight.medium), NSAttributedString.Key.foregroundColor: UIColor.black]))
        fnLabel.attributedText = mutAttrString
        
        fnLabel.textAlignment = .center
        return fnLabel
    }()
    
    let emailLabel: UILabel = {
        let emLabel = UILabel()
        emLabel.numberOfLines = 0
        emLabel.adjustsFontSizeToFitWidth = true
        
        let mutAttrString = NSMutableAttributedString(string: "ID:", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18, weight: UIFont.Weight.thin), NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        mutAttrString.append(NSAttributedString(string: "  No UserID", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 20, weight: UIFont.Weight.medium), NSAttributedString.Key.foregroundColor: UIColor.black]))
        emLabel.attributedText = mutAttrString
        
        emLabel.textAlignment = .center
        return emLabel
    }()
    
    
    // MARK: - Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.navigationController?.navigationBar.isHidden = true
        
        self.view.addSubview(self.logoContainerView)
        logoContainerView.anchorView(self.view.topAnchor, leftEdge: self.view.leftAnchor, bottomEdge: nil, rightEdge: self.view.rightAnchor, topPadding: 0, leftPadding: 0, bottomPadding: 0, rightPadding: 0, height: self.view.frame.size.height / 5, width: self.view.frame.size.width)
        self.constructVerticalStack()
        
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(applicationDidBecomeActive(_:)),
            name: UIApplication.didBecomeActiveNotification,
            object: nil)
        
        updateUI()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    func updateAccessToken(_ accessToken: String) {
        self.tokens = Tokens(accessToken: accessToken)
        self.checkState(self.tokens!.accessToken)
    }
    
    @objc func applicationDidBecomeActive(_ notification: NSNotification) {
        if let value =  UserDefaults.standard.value(forKey: "LIAccessToken") {
            self.checkState(value as! String)
        }
    }
    
}


extension LogInViewController {
    
    func constructVerticalStack() {
        let aStackView = UIStackView(arrangedSubviews: [self.logInButton, self.statusLabel, self.fullNameLabel, self.emailLabel])
        aStackView.axis = .vertical
        aStackView.spacing = 25
        aStackView.distribution = .fillProportionally
        self.view.addSubview(aStackView)
        aStackView.anchorView(logoContainerView.bottomAnchor, leftEdge: self.view.leftAnchor, bottomEdge: nil, rightEdge: self.view.rightAnchor, topPadding: 50, leftPadding: 40, bottomPadding: 0, rightPadding: 40, height: 0, width: 0)
        
    }
    
    
    @objc func logInButtonTapped() {
        if self.tokens == nil {
            self.authServer.authorize(viewController: self, webViewController: self.webVC, handler: { (success) in
                if !success {
                    //TODO: show error
                    self.updateUI()
                }
            })
        } else {
            self.logout()
            updateUI()
        }
    }
    
    
    func updateUI() {
        DispatchQueue.main.async {
            
            if self.tokens == nil {
                if self.authServer.receivedCode == nil {
                    
                    let mutAttrString = NSMutableAttributedString(string: "Last Name:", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18, weight: UIFont.Weight.thin), NSAttributedString.Key.foregroundColor: UIColor.lightGray])
                    mutAttrString.append(NSAttributedString(string: "  No Name", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.medium), NSAttributedString.Key.foregroundColor: UIColor.black]))
                    self.fullNameLabel.attributedText = mutAttrString
                    
                    let mutAttrString1 = NSMutableAttributedString(string: "ID:", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18, weight: UIFont.Weight.thin), NSAttributedString.Key.foregroundColor: UIColor.lightGray])
                    mutAttrString1.append(NSAttributedString(string: "  No UserID", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.medium), NSAttributedString.Key.foregroundColor: UIColor.black]))
                    self.emailLabel.attributedText = mutAttrString1
                    
                    self.statusLabel.text = "Log-Out"
                    
                } else {
                }
                self.logInButton.setTitle("Login", for: UIControl.State.normal)
                
            } else {
                if self.profile?.name == nil {
                } else {
                    self.fullNameLabel.text = self.profile?.name
                    self.emailLabel.text = self.profile?.email
                    self.statusLabel.text = "Logged- In"
                }
                self.logInButton.setTitle("Logout", for: UIControl.State.normal)
                
            }
        }
    }
    
    
    private func checkState(_ accessT: String) {
        
        self.tokens?.accessToken = accessT
        
        self.authServer.getProfile(accessToken: accessT, handler: { (profile) in
            self.profile = profile
            self.updateUI()
        })
        
        self.updateUI()
        
    }
    
    func logout() {
        tokens = nil
        profile = nil
        authServer.reset()
        UserDefaults.standard.removeObject(forKey: "LIAccessToken")
    }
    
}
