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
import Presentr

class ListTrackByGenre: UIViewController {

    @IBOutlet weak var listTrackByGenreTableView: UITableView!
    @IBOutlet weak var banerImage: UIImageView!
    
    var artWork_url: [String] = []
    var genre: [String] = []
    var titles: [String] = []
    var uri: [String] = []
    var nameArtist: [String] = []
    var bannerImg = ""
    
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
            }
            self.artWork_url = artWork_url
            self.genre = genre
            self.titles = titles
            self.uri = uri
            self.nameArtist = nameArtist
            self.listTrackByGenreTableView.reloadData()
        }
    }
    
    func setUpViewMoreButton() {
        view.addSubview(contentView)
    }
    
    let contentView: UIView = {
        let view = UIView(frame: CGRect(x: 223, y: 0.0, width: 100, height: 100))
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.lightGray.cgColor
        return view
    }()
    
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
        tabBarController?.selectedIndex = 2
    }
}
