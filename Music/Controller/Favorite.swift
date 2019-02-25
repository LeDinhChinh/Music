//
//  Favorite.swift
//  Music
//
//  Created by Admin on 2/19/19.
//  Copyright © 2019 Admin. All rights reserved.
//

import UIKit

class Favorite: UIViewController {
    
    @IBOutlet weak var viewFavorite: UIView!
    @IBOutlet weak var listTrackByFavorite: UITableView!
    
    var arrFavoriteTrack = [FavoriteTracks]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        arrFavoriteTrack = DataLocal.getDataFavoriteTrack()
        print(arrFavoriteTrack.count)
        listTrackByFavorite.separatorStyle = .none
        viewFavorite.addBorder(side: UIView.ViewSide.bottom, thickness: 1, color: UIColor.red)
    }
}

extension Favorite: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}
