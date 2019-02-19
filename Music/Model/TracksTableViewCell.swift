//
//  TracksTableViewCell.swift
//  Music
//
//  Created by Admin on 2/20/19.
//  Copyright © 2019 Admin. All rights reserved.
//

import UIKit

class TracksTableViewCell: UITableViewCell {
    @IBOutlet weak var imageTrack: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblNameArtist: UILabel!
    @IBOutlet weak var moreButton: UIButton!
    
    @IBAction func moreButton(_ sender: Any) {
        
    }
    
    func setSubView() {
        if moreButton.isEnabled != true {
            moreButton.isEnabled = true
        }
    }
}
