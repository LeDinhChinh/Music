//
//  extensionUIView.swift
//  UCash
//
//  Created by Khiem on 2018-11-13.
//  Copyright © 2018 SuSoft. All rights reserved.
//

import Foundation
import UIKit
extension UIView {
    
    func makeCornerRadius(radius:CGFloat = 5,color:UIColor = .clear,width:CGFloat = 0)  {
        layer.cornerRadius = radius
        layer.borderColor = color.cgColor
        layer.borderWidth = width
    }
    
    func makeCicrleRadius() {
        layer.cornerRadius = frame.height / 2
    }
    
    func UCDropShadow(scale: Bool = true) {
        dropShadow(color: .lightGray, opacity: 0.5, offSet: CGSize(width: 1, height: 3), radius: 4, scale: true)
    }
    func UCDropShadowButton(scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowColor = UIColor.lightGray.cgColor
        layer.shadowOpacity = 0.6
        layer.shadowOffset = CGSize(width: 1, height: 3)
        layer.shadowRadius = 4
    }
    func dropShadow(color: UIColor, opacity: Float = 0.5, offSet: CGSize, radius: CGFloat = 1, scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = opacity
        layer.shadowOffset = offSet
        layer.shadowRadius = radius
        
        layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
}
