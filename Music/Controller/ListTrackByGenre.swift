//
//  ListTrackByGenre.swift
//  Music
//
//  Created by Admin on 2/20/19.
//  Copyright © 2019 Admin. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireObjectMapper

final class ListTrackByGenre: UIViewController {

    @IBOutlet weak var listTrackByGenreTableView: UITableView!
    @IBOutlet weak var banerImage: UIImageView!
    
    var artWork_url: [String] = []
    var genre: [String] = []
    var titles: [String] = []
    var uri: [String] = []
    var nameArtist: [String] = []
    var bannerImg = ""
    var numberOfTrack = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        banerImage.image = UIImage(named: bannerImg)
        listTrackByGenreTableView.separatorStyle = .singleLine
    }
    
    func requestAPI(url: URL) {
        Alamofire.request(url).responseObject { (response: DataResponse<TracksResponse>) in
            var artWork_url: [String] = []
            var genre: [String] = []
            var titles: [String] = []
            var uri: [String] = []
            var nameArtist: [String] = []
            var numberOfTrack = 0
            guard let value = response.value else {
                return
            }
            
            for i in 0..<value.collection.count {
                guard let track = response.value?.collection[i].track else {
                    return
                }
                artWork_url.append(track.artwork_url)
                genre.append(track.genre)
                titles.append(track.title)
                uri.append(track.uri)
                nameArtist.append(track.user?.full_name ?? "")
                numberOfTrack = value.collection.count - 1
            }
            self.artWork_url = artWork_url
            self.genre = genre
            self.titles = titles
            self.uri = uri
            self.nameArtist = nameArtist
            self.listTrackByGenreTableView.reloadData()
            self.numberOfTrack = numberOfTrack
        }
    }
}

extension ListTrackByGenre: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "TrackGenreCell") as? TracksGenreTableViewCell {
            if let artWork_url = URL(string: artWork_url[indexPath.row]),
               let data = try? Data(contentsOf: artWork_url) {
                cell.imageTrack.image = UIImage(data: data)
            }
            cell.lblNameArtist.text = nameArtist[indexPath.row]
            cell.lblTitle.text = titles[indexPath.row]
            return cell
        }
    
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let playerVC = self.tabBarController?.viewControllers?[2] as! Player
        playerVC.titles = self.titles
        playerVC.genre = self.genre
        playerVC.stringNameArtist = self.nameArtist
        playerVC.artWork_url = self.artWork_url
        playerVC.uri = self.uri
        playerVC.currentPositionOfTrackInArrTrack = indexPath.row
        playerVC.numberOfTrack = self.numberOfTrack
        playerVC.dataFromHomeVC = true
        playerVC.dataFromFavoriteVC = false
        DispatchQueue.main.async {
            playerVC.willPlayerWithDataFromHomeVC()
        }
        tabBarController?.selectedIndex = 2
    }
}
