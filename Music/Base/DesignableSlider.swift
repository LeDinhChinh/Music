//
//  DesignableSlider.swift
//  Music
//
//  Created by Admin on 2/23/19.
//  Copyright © 2019 Admin. All rights reserved.
//

import UIKit

@IBDesignable
class DesignableSlider: UISlider {
    @IBInspectable var thumbImage: UIImage? {
        didSet {
            setThumbImage(thumbImage, for: UIControl.State.normal)
        }
    }
}
