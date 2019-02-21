//
//  ViewController.swift
//  Music
//
//  Created by Admin on 2/19/19.
//  Copyright © 2019 Admin. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireObjectMapper

class Home: UIViewController {
    
    @IBOutlet weak var genreCollectionView: UICollectionView!
    @IBOutlet weak var topArtistCollectionView: UICollectionView!
    @IBOutlet weak var topMusicCollectionView: UICollectionView!
    
    let genreArr = ["hiphop","classical","audio","country","alternativerock","ambient"]
    let topArtistArr = ["Avicii", "Martin Garrix", "Armin Van Burien", "Ran-D", "Headhunter", "Kshmr", "Hardwell", "Skrillex", "David Gueta", "Zedd"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        genreCollectionView.delegate = self
        genreCollectionView.showsHorizontalScrollIndicator = false
        topArtistCollectionView.showsHorizontalScrollIndicator = false
        topMusicCollectionView.showsHorizontalScrollIndicator = false
    }
    
}

extension Home: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == genreCollectionView {
            return genreArr.count
        } else if collectionView == topArtistCollectionView {
            return topArtistArr.count
        } else if collectionView == topMusicCollectionView {
            return 10
        }
        
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.genreCollectionView {
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "genreCell", for: indexPath) as? GenreCollectionViewCell {
                cell.imageGenre.image = UIImage(named: genreArr[indexPath.row])
                return cell
            }
        } else if collectionView == self.topArtistCollectionView {
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "topArtistCell", for: indexPath) as? TopArtistCollectionViewCell {
                cell.imageTopArtist.image = UIImage(named: topArtistArr[indexPath.row])
                cell.lblTopArtist.text = topArtistArr[indexPath.row]
                return cell
            }
        } else if collectionView == self.topMusicCollectionView {
            guard let url_classical = URL(string: classical_api_1) else {
                fatalError("")
            }
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "topMusicCell", for: indexPath) as? TopMusicCollectionViewCell {
                Alamofire.request(url_classical).responseObject { (response: DataResponse<TracksResponse>) in
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
                        nameArtist.append((track.user?.full_name)!)
                    }
                    if let artWork_url = URL(string: artWork_url[indexPath.row]),
                        let data = try? Data(contentsOf: artWork_url) {
                        cell.imageTopMusic.image = UIImage(data: data)
                    }
                    
                    cell.lblTitleTrack.text = titles[indexPath.row]
                    cell.lblNameArtist.text = nameArtist[indexPath.row]
                }
                return cell
            }
        }
        return UICollectionViewCell()           
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var width: CGFloat = 0
        var height: CGFloat = 0
        if collectionView == self.genreCollectionView {
            width = collectionView.frame.size.width / 2.5
            height = collectionView.frame.size.height
            return CGSize(width: width, height: height)
        } else if collectionView == self.topArtistCollectionView {
            width = collectionView.frame.size.width / 2
            height = collectionView.frame.size.height
            return CGSize(width: width, height: height)
        } else if collectionView == self.topMusicCollectionView {
            width = collectionView.frame.size.width / 2
            height = collectionView.frame.size.height 
            return CGSize(width: width, height: height)
        }
        return CGSize()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        guard let url_hiphop_rap_1 = URL(string: hiphop_rap_api_1),
            let url_classical_1 = URL(string: classical_api_1),
            let url_audio_1 = URL(string: audio_api_1),
            let url_country_1 = URL(string: country_api_1),
            let url_alternal_rock_1 = URL(string: alternative_rock_api_1),
            let url_ambient_1 = URL(string: ambient_api_1) else {
                return
        }
        
        if collectionView == self.genreCollectionView {
            let listTrackByGenreVC = self.storyboard?.instantiateViewController(withIdentifier: "listTrackByGenreVC") as! ListTrackByGenre
            switch indexPath.row {
            case 0:
                listTrackByGenreVC.requestAPI(url: url_hiphop_rap_1)
                listTrackByGenreVC.bannerImg = genreArr[indexPath.row]
            case 1:
                listTrackByGenreVC.requestAPI(url: url_classical_1)
                listTrackByGenreVC.bannerImg = genreArr[indexPath.row]
            case 2:
                listTrackByGenreVC.requestAPI(url: url_audio_1)
                listTrackByGenreVC.bannerImg = genreArr[indexPath.row]
            case 3:
                listTrackByGenreVC.requestAPI(url: url_country_1)
                listTrackByGenreVC.bannerImg = genreArr[indexPath.row]
            case 4:
                listTrackByGenreVC.requestAPI(url: url_alternal_rock_1)
                listTrackByGenreVC.bannerImg = genreArr[indexPath.row]
            case 5:
                listTrackByGenreVC.requestAPI(url: url_ambient_1)
                listTrackByGenreVC.bannerImg = genreArr[indexPath.row]
            default:
                return
            }
            self.navigationController?.pushViewController(listTrackByGenreVC, animated: true)
        } else if collectionView == self.topArtistCollectionView {
            if let DetailArtistVC = self.storyboard?.instantiateViewController(withIdentifier: "detailArtist") as? DetailArtist {
                self.navigationController?.pushViewController(DetailArtistVC, animated: true)
            }
        } else if collectionView == self.topMusicCollectionView {
            let player = self.tabBarController?.viewControllers?[2] as! Player
            player.test = "test"
            tabBarController?.selectedIndex = 2
        }
    }
}
