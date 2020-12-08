//
//  UIView.swift
//  Enter
//
//  Created by Amit Chaudhary on 5/17/20.
//  Copyright © 2020 Amit Chaudhary. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    func anchorView(_ topEdge: NSLayoutYAxisAnchor?, leftEdge: NSLayoutXAxisAnchor?, bottomEdge: NSLayoutYAxisAnchor?, rightEdge: NSLayoutXAxisAnchor?, topPadding: CGFloat, leftPadding: CGFloat, bottomPadding: CGFloat, rightPadding: CGFloat, height: CGFloat, width: CGFloat) {
        self.translatesAutoresizingMaskIntoConstraints = false
        if let safeTop = topEdge {
            self.topAnchor.constraint(equalTo: safeTop, constant: topPadding).isActive = true
        }
        if let safeLeft = leftEdge {
            self.leftAnchor.constraint(equalTo: safeLeft, constant: leftPadding).isActive = true
        }
        if let safeBottom = bottomEdge {
            self.bottomAnchor.constraint(equalTo: safeBottom, constant: -bottomPadding).isActive = true
        }
        if let safeRight = rightEdge {
            self.rightAnchor.constraint(equalTo: safeRight, constant: -rightPadding).isActive = true
        }
        
        if height != 0 {
            self.heightAnchor.constraint(equalToConstant: height).isActive = true
        }
        
        if width != 0 {
            self.widthAnchor.constraint(equalToConstant: width).isActive = true
        }
    }
}
