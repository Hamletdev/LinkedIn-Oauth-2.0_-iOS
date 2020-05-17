//
//  LogInViewController.swift
//  Enter
//
//  Created by Amit Chaudhary on 5/17/20.
//  Copyright © 2020 Amit Chaudhary. All rights reserved.
//

import UIKit

class LogInViewController: UIViewController {
    
    // MARK: - Properties
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
        inButton.layer.cornerRadius = 2
        inButton.backgroundColor = .systemBlue
        inButton.titleLabel?.numberOfLines = 0
        inButton.setTitle("Login", for: .normal)
        inButton.setTitleColor(.white, for: .normal)
        inButton.titleLabel?.font = .systemFont(ofSize: 20, weight: UIFont.Weight.medium)
        
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
        
        let mutAttrString = NSMutableAttributedString(string: "Name:", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18, weight: UIFont.Weight.thin), NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        mutAttrString.append(NSAttributedString(string: "  No Name", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 20, weight: UIFont.Weight.medium), NSAttributedString.Key.foregroundColor: UIColor.black]))
        fnLabel.attributedText = mutAttrString
        
        fnLabel.textAlignment = .center
        return fnLabel
    }()
    
    let emailLabel: UILabel = {
        let emLabel = UILabel()
        emLabel.numberOfLines = 0
        emLabel.adjustsFontSizeToFitWidth = true
        
        let mutAttrString = NSMutableAttributedString(string: "Email:", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18, weight: UIFont.Weight.thin), NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        mutAttrString.append(NSAttributedString(string: "  No Email", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 20, weight: UIFont.Weight.medium), NSAttributedString.Key.foregroundColor: UIColor.black]))
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
}
