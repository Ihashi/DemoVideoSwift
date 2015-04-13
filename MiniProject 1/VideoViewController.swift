//
//  VideoViewController.swift
//  MiniProject 1
//
//  Created by ESIEA on 10/04/2015.
//  Copyright (c) 2015 HaiNguyen. All rights reserved.
//

import UIKit
import AVFoundation

class VideoViewController: UIViewController
{
    var moviePlayer: AVPlayer?
    var playerLayer: AVPlayerLayer?
    let screenSize = UIScreen.mainScreen().bounds
    var urls = ["http://techslides.com/demos/sample-videos/small.mp4",
                "http://clips.vorwaerts-gmbh.de/VfE_html5.mp4"]
//                "http://static.siz.io/sequences/SxbF163N6NNL.mp4",
//                "http://static.siz.io/sequences/igRJLNMZTu1h.mp4",
//                "http://static.siz.io/sequences/dzoRiCq8BhhC.mp4"]
    
    var tmp = 0
    
    func displayButton()
    {
        let leftButton = UIButton.buttonWithType(UIButtonType.System) as! UIButton
        leftButton.frame = CGRectMake(0, (screenSize.width/2)-20, 80, 40)
        leftButton.backgroundColor = .blackColor()
        leftButton.setTitle("Prev", forState: UIControlState.Normal)
        leftButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        leftButton.addTarget(self, action: "leftButtonAction:", forControlEvents: UIControlEvents.TouchUpInside)
        
        let rightButton = UIButton.buttonWithType(UIButtonType.System) as! UIButton
        rightButton.frame = CGRectMake((screenSize.height)-80, (screenSize.width/2)-20, 80, 40)
        rightButton.backgroundColor = UIColor.blackColor()
        rightButton.setTitle("Next", forState: UIControlState.Normal)
        rightButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        rightButton.addTarget(self, action: "rightButtonAction:", forControlEvents: UIControlEvents.TouchUpInside)
        
        self.view.addSubview(leftButton)
        self.view.addSubview(rightButton)
    }
    
    func leftButtonAction(sender:UIButton!)
    {
        if(tmp > 0)
        {
            tmp--
            playVideo()
        }
        else if(tmp == 0)
        {
            let alert = UIAlertView()
            alert.title = "Sorry"
            alert.message = "It's the first video !"
            alert.addButtonWithTitle("OK")
            alert.show()
        }
        
        println("Left button tapped")
    }
    
    func rightButtonAction(sender:UIButton!)
    {
        if(tmp < urls.count-1)
        {
            tmp++
            playVideo()
        }
        else if(tmp == urls.count-1)
        {
            let alert = UIAlertView()
            alert.title = "Sorry"
            alert.message = "It's the last video !"
            alert.addButtonWithTitle("OK")
            alert.show()
        }
        
        println("Right button tapped")
    }
    
    func playVideo()
    {
        println("\(tmp)")
        var url = NSURL(string: urls[tmp])
        moviePlayer = AVPlayer(URL: url)
        playerLayer = AVPlayerLayer(player: moviePlayer)
        
        moviePlayer!.actionAtItemEnd = .None
        
        playerLayer!.frame = CGRect(x: 0, y: 0, width: screenSize.height, height: screenSize.width)
        
        self.view.backgroundColor = UIColor.blackColor()
        self.view.layer.addSublayer(playerLayer)
        
        moviePlayer?.play()
        displayButton()
        
        NSNotificationCenter.defaultCenter().addObserver(self,
            selector: "restartVideo",
            name: AVPlayerItemDidPlayToEndTimeNotification,
            object: moviePlayer?.currentItem)
    }
    
    func restartVideo()
    {
        let seconds : Int64 = 0
        let preferredTimeScale : Int32 = 1
        let seekTime : CMTime = CMTimeMake(seconds, preferredTimeScale)
        
        moviePlayer!.seekToTime(seekTime)
        moviePlayer!.play()
    }
    
    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(true)
        playVideo()
    }
}
