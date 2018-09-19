//
//  ViewController.swift
//  Radio
//
//  Created by Catalin Palade on 08/08/2018.
//  Copyright © 2018 Catalin Palade. All rights reserved.
//

import UIKit
import AVFoundation
import MediaPlayer

enum RadioStatus {
    case playing
    case paused
}

class ViewController: UIViewController, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!

    
    var stations = [RadioStation]()
    var currentStation: RadioStation!
    
    var player: AVPlayer!
    
    var status = RadioStatus.paused {
        didSet {
            if status == .paused {
                playOutlet.setImage(UIImage(named: "playButton"), for: .normal)
                player.pause()
            } else if status == .playing {
                playOutlet.setImage(UIImage(named: "pauseButton"), for: .normal)
                playOutlet.isEnabled = true
                player.play()
            }
        }
    }
       
    @IBOutlet var bottomView: UIView!
    
    var timer: Timer!
    var newSongTimer: Timer!
    
    var endTime: Int! {
        didSet {
            if endTime != nil {
                if status == .playing {
                    timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerConfig), userInfo: nil, repeats: true)
                }
                
            }
        }
    }
    var count = 0

    @IBOutlet weak var visualEffectView: UIVisualEffectView!
    var effect: UIVisualEffect!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Radio Stations"
        
        // Setup TableView
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .clear
        tableView.backgroundView = nil
        tableView.separatorStyle = .none
        
        //bar button for info and sleep/timer
        let sleepButton = UIImage(named: "timerButton")
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: sleepButton, style: .plain, target: self, action: #selector(showOptions))
        
        
        
        // Pro FM
        let logoProFM = UIImage(named: "logoProFM")!
        let profmStation = RadioStation(name: "Pro FM",
                                        motto: "Hiturile se aud prima data la ProFM!",
                                        streamURL: "http://edge126.rdsnet.ro:84/profm/profm.mp3",
                                        logo: logoProFM)
        stations.append(profmStation)
        
        // Dance FM
        let logoDanceFM = UIImage(named: "logoDanceFM")!
        let dancefmStation = RadioStation(name: "Dance FM",
                                          motto: "Dance Radio Station",
                                          streamURL: "http://edge126.rdsnet.ro:84/profm/dancefm.mp3",
                                          logo: logoDanceFM)
        stations.append(dancefmStation)
        
        // DIGI FM
        let logoDigiFM = UIImage(named: "logoDigiFM")!
        let digifmStation = RadioStation(name: "Digi FM",
                                         motto: "CA SĂ ȘTII",
                                         streamURL: "http://edge76.rdsnet.ro:84/digifm/digifm.mp3",
                                         logo: logoDigiFM)
        stations.append(digifmStation)
        
        
        // Play Button init
        playOutlet.isEnabled = false
        bottomView.layer.shadowColor = UIColor.black.cgColor
        bottomView.layer.shadowOpacity = 0.3
        bottomView.layer.shadowOffset = CGSize.zero
        bottomView.layer.shadowRadius = 10
        bottomView.layer.shadowPath = UIBezierPath(rect: bottomView.bounds).cgPath
        bottomView.layer.shouldRasterize = true
        
        // control centre
        UIApplication.shared.beginReceivingRemoteControlEvents()
        
        // visual efect
        effect = visualEffectView.effect
        visualEffectView.effect = nil
    }
    
    
    // play/pause button tapped
    @IBOutlet var playOutlet: UIButton!
    @IBAction func playTapped(_ sender: UIButton) {
        switch status {
        case .playing:
            // Play tapped
            status = .paused
        case .paused:
            //Pause tapped
            status = .playing
        }
    }
    // timer button
    @objc func timerConfig() {
        if endTime == count {
            if status == .playing {
                status = .paused
            }
            timer.invalidate()
            count = 0
            endTime = nil
        } else {
            count += 1
            print(count)
        }
    }
    @objc func showOptions() {
        let minut = 60
        let ac = UIAlertController(title: "Stop playing in:", message: nil, preferredStyle: .actionSheet)
        // 1 minute
        ac.addAction(UIAlertAction(title: "1 minute", style: .default) { _ in self.endTime = minut })
        // 5 minutes
        ac.addAction(UIAlertAction(title: "5 minutes", style: .default) { _ in self.endTime = minut * 5 })
        // 15 minutes
        ac.addAction(UIAlertAction(title: "15 minutes", style: .default) { _ in self.endTime = minut * 15 })
        // 30 minutes
        ac.addAction(UIAlertAction(title: "30 minutes", style: .default) { _ in self.endTime = minut * 30 })
        // 1 hour
        ac.addAction(UIAlertAction(title: "1 hour", style: .default) { _ in self.endTime = minut * 60 })
        // 2 hours
        ac.addAction(UIAlertAction(title: "2 hours", style: .default) { _ in self.endTime = minut * 60 * 2 })
        // reset to 0
        ac.addAction(UIAlertAction(title: "None", style: .default) { _ in
            self.endTime = nil
            self.timer.invalidate()
            self.count = 0
        })
        
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(ac, animated: true)
    }
}

    // TableView - Settings
extension ViewController: UITableViewDataSource {
    
    @objc(tableView:heightForRowAtIndexPath:)
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stations.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StationCell", for: indexPath) as! StationTableViewCell
        // cell style
        cell.backgroundColor = UIColor.black.withAlphaComponent(0.2)
        
        // implement all the cell image and name and detail
        let station = stations[indexPath.row]
        cell.configureStationCell(station: station)
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let station = stations[indexPath.row]
        let url = URL(string: station.streamURL)
        title = station.name
        currentStation = station
        
        player = AVPlayer(url: url!)
        setupCommandCenter()
        
        status = .playing
    }
    
    private func setupCommandCenter() {
        MPNowPlayingInfoCenter.default().nowPlayingInfo = [MPMediaItemPropertyTitle: "Radio"]
        
        let commandCenter = MPRemoteCommandCenter.shared()
        commandCenter.playCommand.isEnabled = true
        commandCenter.pauseCommand.isEnabled = true
        commandCenter.playCommand.addTarget { [weak self] (event) -> MPRemoteCommandHandlerStatus in
            self!.status = .playing
            return .success
        }
        commandCenter.pauseCommand.addTarget { [weak self] (event) -> MPRemoteCommandHandlerStatus in
            self!.status = .paused
            return .success
        }
        // Define Now Playing Info
        var nowPlayingInfo = [String : Any]()
        nowPlayingInfo[MPMediaItemPropertyTitle] = title
        // Set the metadata
        MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
    }

}




