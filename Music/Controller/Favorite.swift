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
    @IBOutlet weak var tableViewFavorite: UITableView!
    
    var arrFavoriteTrack = [FavoriteTracks]()
        
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        arrFavoriteTrack = DataLocal.getDataFavoriteTrack()
    }
    override func viewDidAppear(_ animated: Bool) {
        tableViewFavorite.reloadData()
    }
}

extension Favorite: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrFavoriteTrack.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "TrackFavoriteCell") as? TrackFavoriteTableViewCell {
            if let artWork_url = URL(string: arrFavoriteTrack[indexPath.row].url_image),
                let data = try? Data(contentsOf: artWork_url) {
                cell.imageTrack.image = UIImage(data: data)
            }
            cell.lblNameArtist.text = arrFavoriteTrack[indexPath.row].nameArtist
            cell.lblTitle.text = arrFavoriteTrack[indexPath.row].titles
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let playerVC = self.tabBarController?.viewControllers?[2] as! Player
        playerVC.arrFavoriteTracks = self.arrFavoriteTrack
        playerVC.dataFromFavoriteVC = true
        playerVC.dataFromHomeVC = false
        playerVC.favoriteFlag = true
        playerVC.currentPositionOfTrackInArrTrack = indexPath.row
        playerVC.numberOfTrack = self.arrFavoriteTrack.count - 1
        DispatchQueue.main.async {
            playerVC.willPlayerWithDataFromFavoriteVC()
        }
        tabBarController?.selectedIndex = 2
    }
}
