//
//  Player.swift
//  Music
//
//  Created by Admin on 2/19/19.
//  Copyright © 2019 Admin. All rights reserved.
//

import UIKit
import AVFoundation
import Alamofire

final class Player: UIViewController, AVAudioPlayerDelegate {
    @IBOutlet weak var trackImage: UIImageView!
    @IBOutlet weak var timeTrackSlide: UISlider!
    @IBOutlet weak var currentTimeTrack: UILabel!
    @IBOutlet weak var durationTimeTrack: UILabel!
    @IBOutlet weak var nameTrack: UILabel!
    @IBOutlet weak var nameArtist: UILabel!
    @IBOutlet weak private var volumeDown: UIButton!
    @IBOutlet weak private var volumeSlide: UISlider!
    @IBOutlet weak private var volumeUp: UIButton!
    @IBOutlet weak private var favorite: UIButton!
    @IBOutlet weak private var shuffle: UIButton!
    @IBOutlet weak private var pauseOrPlayTrack: UIButton!
    @IBOutlet weak private var loop: UIButton!
    
    var error = false
    var numberOfTrack = -1
    var favoriteFlag = false
    var shuffleTrackFlag = false
    var artWork_url: [String] = []
    var genre: [String] = []
    var titles: [String] = []
    var uri: [String] = []
    var stringNameArtist: [String] = []
    var arrFavoriteTracks = [FavoriteTracks]()
    var player: AVAudioPlayer?
    var currentPositionOfTrackInArrTrack = 0
    
    var dataFromHomeVC = false
    var dataFromFavoriteVC = false
    private var loopAllTrack: Bool = false
    private var loopForOne: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func willPlayerWithDataFromHomeVC() {
        if let url = URL(string: artWork_url[currentPositionOfTrackInArrTrack]) {
            let data = try? Data(contentsOf: url)
            trackImage.image = UIImage(data: data!)
        }
        nameTrack.text = titles[currentPositionOfTrackInArrTrack]
        nameArtist.text = stringNameArtist[currentPositionOfTrackInArrTrack]
        let url = URL(string: uri[currentPositionOfTrackInArrTrack] + id_client)
        Alamofire.request(url!).responseObject { (response :DataResponse<Errors>) in
            if let value = response.value {
                if value.errors[0].error_message == "401 - Unauthorized" {
                    self.error = true
                    self.player?.stop()
                    let alert = UIAlertController(title: "Error", message: "Error play music", preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                    return
                }
            }
            let arrFavoriteTracks = DataLocal.getDataFavoriteTrack()
            if self.isTrackFavorite(favoriteTrack: arrFavoriteTracks, url: self.uri[self.currentPositionOfTrackInArrTrack]) {
                self.favorite.setImage(UIImage(named: "favorite"), for: UIControl.State.normal)
            } else {
                self.favorite.setImage(UIImage(named: "favorite-heart-button (1)"), for: UIControl.State.normal)
            }
            self.error = false
            do {
                let data = try Data(contentsOf: url!)
                self.player = try AVAudioPlayer(data: data)
                self.player?.delegate = self
                Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { (Timer) in
                    self.currentTimeTrack.text = self.intToHoursMinutesSeconds(seconds: (self.player?.currentTime)!)
                    self.timeTrackSlide.value = Float((self.player?.currentTime)!)
                }
                self.timeTrackSlide.maximumValue = Float((self.player?.duration)!)
                self.durationTimeTrack.text = self.intToHoursMinutesSeconds(seconds: (self.player?.duration)!)
                self.player?.volume = self.volumeSlide.value
                self.player?.play()
                self.pauseOrPlayTrack.setImage(UIImage(named: "icons8-pause-filled-50"), for: UIControl.State.normal)
            } catch {
                if (self.player?.isPlaying)! {
                    self.player?.pause()
                }
                self.pauseOrPlayTrack.setImage(UIImage(named: "icons8-play-filled-50"), for: UIControl.State.normal)
                let alert = UIAlertController(title: "Error", message: "This music cannot be played", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    func willPlayerWithDataFromFavoriteVC() {
        if let url = URL(string: arrFavoriteTracks[currentPositionOfTrackInArrTrack].url_image) {
            let data = try? Data(contentsOf: url)
            trackImage.image = UIImage(data: data!)
        }
        if let isPlaying = player?.isPlaying {
            if isPlaying {
                player?.stop()
            }
        }
        nameTrack.text = arrFavoriteTracks[currentPositionOfTrackInArrTrack].titles
        nameArtist.text = arrFavoriteTracks[currentPositionOfTrackInArrTrack].nameArtist
        let url = URL(string: arrFavoriteTracks[currentPositionOfTrackInArrTrack].uri + id_client)
        Alamofire.request(url!).responseObject { (response :DataResponse<Errors>) in
            if let value = response.value {
                if value.errors[0].error_message == "401 - Unauthorized" {
                    self.error = true
                    self.player?.stop()
                    let alert = UIAlertController(title: "Error", message: "Error play music", preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                    return
                }
            }
            self.error = false
            self.favorite.setImage(UIImage(named: "favorite"), for: UIControl.State.normal)
            do {
                let data = try Data(contentsOf: url!)
                self.player = try AVAudioPlayer(data: data)
                self.player?.delegate = self
                Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { (Timer) in
                    self.currentTimeTrack.text = self.intToHoursMinutesSeconds(seconds: (self.player?.currentTime)!)
                    self.timeTrackSlide.value = Float((self.player?.currentTime)!)
                }
                self.timeTrackSlide.maximumValue = Float((self.player?.duration)!)
                self.durationTimeTrack.text = self.intToHoursMinutesSeconds(seconds: (self.player?.duration)!)
                self.player?.volume = self.volumeSlide.value
                self.player?.play()
                self.pauseOrPlayTrack.setImage(UIImage(named: "icons8-pause-filled-50"), for: UIControl.State.normal)
            } catch {
                if (self.player?.isPlaying)! {
                    self.player?.pause()
                }
                self.pauseOrPlayTrack.setImage(UIImage(named: "icons8-play-filled-50"), for: UIControl.State.normal)
                let alert = UIAlertController(title: "Error", message: "This music cannot be played", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    func isTrackFavorite(favoriteTrack: [FavoriteTracks], url: String) -> Bool {
        for i in 0..<favoriteTrack.count {
            if url == favoriteTrack[i].uri {
                return true
            }
        }
        return false
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        nextTrack((Any).self)
    }
    
    private func intToHoursMinutesSeconds(seconds: TimeInterval) -> String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute, .second]
        let formattedString = formatter.string(from: TimeInterval(seconds))
        return formattedString!
    }
    
    @IBAction func willChangeTimerOfTrack(_ sender: Any) {
        player?.currentTime = TimeInterval(timeTrackSlide.value)
    }
    
    @IBAction func willChangeVolumeOfTrack(_ sender: Any) {
        player?.volume = volumeSlide.value
    }
    
    @IBAction func pauseOrPlayTrack(_ sender: Any) {
        if error == true {
            return
        }
        if let isPlaying = player?.isPlaying {
            if (isPlaying) {
                pauseOrPlayTrack.setImage(UIImage(named: "icons8-play-filled-50"), for: UIControl.State.normal)
                player?.pause()
            } else {
                pauseOrPlayTrack.setImage(UIImage(named: "icons8-pause-filled-50"), for: UIControl.State.normal)
                player?.play()
            }
        }
        
    }
    
    @IBAction func previousTrack(_ sender: Any) {
        if error == false {
            player?.stop()
        }
        if numberOfTrack > 0 {
            if dataFromHomeVC {
                if currentPositionOfTrackInArrTrack == 0 {
                    currentPositionOfTrackInArrTrack = uri.count - 1
                    DispatchQueue.main.async {
                        self.willPlayerWithDataFromHomeVC()
                    }
                } else {
                    currentPositionOfTrackInArrTrack = currentPositionOfTrackInArrTrack - 1
                    DispatchQueue.main.async {
                        self.willPlayerWithDataFromHomeVC()
                    }
                    pauseOrPlayTrack.setImage(UIImage(named: "icons8-pause-filled-50"), for: UIControl.State.normal)
                }
            } else {
                if currentPositionOfTrackInArrTrack == 0 {
                    currentPositionOfTrackInArrTrack = arrFavoriteTracks.count - 1
                    DispatchQueue.main.async {
                        self.willPlayerWithDataFromFavoriteVC()
                    }
                } else {
                    currentPositionOfTrackInArrTrack = currentPositionOfTrackInArrTrack - 1
                    DispatchQueue.main.async {
                        self.willPlayerWithDataFromFavoriteVC()
                    }
                    pauseOrPlayTrack.setImage(UIImage(named: "icons8-pause-filled-50"), for: UIControl.State.normal)
                }
            }
        }
    }
    
    @IBAction func nextTrack(_ sender: Any) {
        if error == false {
            player?.stop()
        }
        if numberOfTrack > 0 {
            if dataFromHomeVC {
                if loopForOne {
                    willPlayerWithDataFromHomeVC()
                    return
                }
                if shuffleTrackFlag {
                    currentPositionOfTrackInArrTrack = Int.random(in: 0..<10)
                    willPlayerWithDataFromHomeVC()
                    return
                }
                if currentPositionOfTrackInArrTrack >= numberOfTrack {
                    if loopAllTrack == false {
                        return
                    }
                    currentPositionOfTrackInArrTrack = 0
                    DispatchQueue.main.async {
                        self.willPlayerWithDataFromHomeVC()
                    }
                    pauseOrPlayTrack.setImage(UIImage(named: "icons8-pause-filled-50"), for: UIControl.State.normal)
                } else {
                    currentPositionOfTrackInArrTrack = currentPositionOfTrackInArrTrack + 1
                    DispatchQueue.main.async {
                        self.willPlayerWithDataFromHomeVC()
                    }
                    pauseOrPlayTrack.setImage(UIImage(named: "icons8-pause-filled-50"), for: UIControl.State.normal)
                }
            } else {
                if loopForOne {
                    willPlayerWithDataFromFavoriteVC()
                    return
                }
                if shuffleTrackFlag {
                    currentPositionOfTrackInArrTrack = Int.random(in: 0..<10)
                    willPlayerWithDataFromFavoriteVC()
                    return
                }
                if currentPositionOfTrackInArrTrack >= arrFavoriteTracks.count - 1 {
                    if loopAllTrack == false {
                        return
                    }
                    currentPositionOfTrackInArrTrack = 0
                    DispatchQueue.main.async {
                        self.willPlayerWithDataFromFavoriteVC()
                    }
                    pauseOrPlayTrack.setImage(UIImage(named: "icons8-pause-filled-50"), for: UIControl.State.normal)
                } else {
                    currentPositionOfTrackInArrTrack = currentPositionOfTrackInArrTrack + 1
                    DispatchQueue.main.async {
                        self.willPlayerWithDataFromFavoriteVC()
                    }
                    pauseOrPlayTrack.setImage(UIImage(named: "icons8-pause-filled-50"), for: UIControl.State.normal)
                }
            }
        }
    }
    
    @IBAction func loop(_ sender: Any) {
        if loopAllTrack == true {
            loopForOne = true
            loopAllTrack = false
            loop.setImage(UIImage(named: "icons8-1st-48"), for: UIControl.State.normal)
        } else if loopForOne == true {
            loopForOne = false
            loop.setImage(UIImage(named: "update-arrows (1)"), for: UIControl.State.normal)
        } else {
            loopAllTrack = true
            loop.setImage(UIImage(named: "icons8-reset-filled-48"), for: UIControl.State.normal)
        }
    }
    
    @IBAction func favoriteTrack(_ sender: Any) {
        if dataFromHomeVC {
            if favoriteFlag == false {
                if numberOfTrack >= 0 {
                    favoriteFlag = true
                    DataLocal.insertRecore(artWork_url[currentPositionOfTrackInArrTrack], genre[currentPositionOfTrackInArrTrack], titles[currentPositionOfTrackInArrTrack], uri[currentPositionOfTrackInArrTrack], stringNameArtist[currentPositionOfTrackInArrTrack])
                    favorite.setImage(UIImage(named: "favorite"), for: UIControl.State.normal)
                }
            } else {
                favoriteFlag = false
                favorite.setImage(UIImage(named: "favorite-heart-button (1)"), for: UIControl.State.normal)
            }
        } else {
            if favoriteFlag == false {
                if numberOfTrack >= 0 {
                    favoriteFlag = true
                    DataLocal.insertRecore(arrFavoriteTracks[currentPositionOfTrackInArrTrack].url_image, arrFavoriteTracks[currentPositionOfTrackInArrTrack].genre, arrFavoriteTracks[currentPositionOfTrackInArrTrack].titles, arrFavoriteTracks[currentPositionOfTrackInArrTrack].uri, arrFavoriteTracks[currentPositionOfTrackInArrTrack].nameArtist)
                    favorite.setImage(UIImage(named: "favorite"), for: UIControl.State.normal)
                }
            } else {
                favoriteFlag = false
                DataLocal.removeData(uri: arrFavoriteTracks[currentPositionOfTrackInArrTrack].uri)
                favorite.setImage(UIImage(named: "favorite-heart-button (1)"), for: UIControl.State.normal)
            }
        }
    }
    
    @IBAction func shuffleTrack(_ sender: Any) {
        if shuffleTrackFlag == false {
            shuffleTrackFlag = true
            shuffle.setImage(UIImage(named: "random"), for: UIControl.State.normal)
        } else {
            shuffleTrackFlag = false
            shuffle.setImage(UIImage(named: "shuffle-mode-arrows (1)"), for: UIControl.State.normal)
        }
    }
}
