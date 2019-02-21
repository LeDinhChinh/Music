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
    var numberOfTrack = 0
    
    var artWork_url: [String] = []
    var genre: [String] = []
    var titles: [String] = []
    var uri: [String] = []
    var stringNameArtist: [String] = []
    var player: AVAudioPlayer?
    var currentPositionOfTrackInArrTrack = 0
    private var loopAllTrack: Bool = false
    private var loopForOne: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    func willPlayer() {
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
    
    func passDataForPlayer(url: URL) {
        
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
        if (player?.isPlaying)! {
            pauseOrPlayTrack.setImage(UIImage(named: "icons8-play-filled-50"), for: UIControl.State.normal)
            player?.pause()
        } else {
            pauseOrPlayTrack.setImage(UIImage(named: "icons8-pause-filled-50"), for: UIControl.State.normal)
            player?.play()
        }
    }
    
    @IBAction func previousTrack(_ sender: Any) {
        if error == false {
            player?.stop()
        }
        if numberOfTrack > 0 {
            if currentPositionOfTrackInArrTrack == 0 {
                currentPositionOfTrackInArrTrack = uri.count - 1
                DispatchQueue.main.async {
                    self.willPlayer()
                }
            } else if currentPositionOfTrackInArrTrack > uri.count {
                currentPositionOfTrackInArrTrack = 0
                DispatchQueue.main.async {
                    self.willPlayer()
                }
                pauseOrPlayTrack.setImage(UIImage(named: "icons8-pause-filled-50"), for: UIControl.State.normal)
            } else {
                currentPositionOfTrackInArrTrack = currentPositionOfTrackInArrTrack - 1
                DispatchQueue.main.async {
                    self.willPlayer()
                }
                pauseOrPlayTrack.setImage(UIImage(named: "icons8-pause-filled-50"), for: UIControl.State.normal)
            }
        }
    }
    
    @IBAction func nextTrack(_ sender: Any) {
        if error == false {
            player?.stop()
        }
        if numberOfTrack > 0 {
            if loopForOne == true {
                willPlayer()
                return
            }
            if currentPositionOfTrackInArrTrack >= uri.count - 1 {
                if loopAllTrack == false {
                    return
                }
                currentPositionOfTrackInArrTrack = 0
                DispatchQueue.main.async {
                    self.willPlayer()
                }
                pauseOrPlayTrack.setImage(UIImage(named: "icons8-pause-filled-50"), for: UIControl.State.normal)
            } else {
                currentPositionOfTrackInArrTrack = currentPositionOfTrackInArrTrack + 1
                DispatchQueue.main.async {
                    self.willPlayer()
                }
                pauseOrPlayTrack.setImage(UIImage(named: "icons8-pause-filled-50"), for: UIControl.State.normal)
            }
        }
    }
    
    @IBAction func loop(_ sender: Any) {
        if loopAllTrack == true {
            loopForOne = true
            loopAllTrack = false
        } else if loopForOne == true {
            loopForOne = false
        } else {
            loopAllTrack = true
        }
        
        if loopAllTrack == true {
            loop.setImage(UIImage(named: "icons8-reset-filled-48"), for: UIControl.State.normal)
        } else if loopForOne == true {
            loop.setImage(UIImage(named: "icons8-1st-48"), for: UIControl.State.normal)
        } else {
            loop.setImage(UIImage(named: "update-arrows (1)"), for: UIControl.State.normal)
        }
    }
}
