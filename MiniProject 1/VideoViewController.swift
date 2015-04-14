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
    var playerItem: AVPlayerItem?
    let screenSize = UIScreen.mainScreen().bounds
    var urls = ["http://fun.siz.io/stories/142893791787803c7fb48f4d/0.mp4",
                "http://fun.siz.io/stories/142893791787803c7fb48f4d/1.mp4",
                "http://fun.siz.io/stories/142893791787803c7fb48f4d/2.mp4",
                "http://fun.siz.io/stories/142893791787803c7fb48f4d/3.mp4"]
    
    var videoNumber = 0
    
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
        rightButton.backgroundColor = .blackColor()
        rightButton.setTitle("Next", forState: UIControlState.Normal)
        rightButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        rightButton.addTarget(self, action: "rightButtonAction:", forControlEvents: UIControlEvents.TouchUpInside)
        
        self.view.addSubview(leftButton)
        self.view.addSubview(rightButton)
    }
    
    func leftButtonAction(sender:UIButton!)
    {
        moviePlayer!.pause()
        
        if(videoNumber > 0)
        {
            videoNumber--
        }
        else if(videoNumber == 0)
        {
            videoNumber = urls.count-1
        }
        
        playVideo()
    }
    
    func rightButtonAction(sender:UIButton!)
    {
        moviePlayer!.pause()
        
        if(videoNumber < urls.count-1)
        {
            videoNumber++
        }
        else if(videoNumber == urls.count-1)
        {
            videoNumber = 0
        }
        
        playVideo()
    }
    
    func playVideo()
    {
        var url = NSURL(string: urls[videoNumber])
        
        playerItem = AVPlayerItem(URL: url)
        moviePlayer = AVPlayer(playerItem: playerItem)
        playerLayer = AVPlayerLayer(player: moviePlayer)
        moviePlayer!.actionAtItemEnd = .None
        
        playerLayer!.frame = CGRect(x: 0, y: 0, width: screenSize.height, height: screenSize.width)
        //playerLayer!.backgroundColor = UIColor.blackColor().CGColor
        self.view.backgroundColor = .blackColor()
        self.view.layer.addSublayer(playerLayer)
        
        moviePlayer!.play()
        displayButton()
        
        NSNotificationCenter.defaultCenter().addObserver(self,
            selector: "restartVideo",
            name: AVPlayerItemDidPlayToEndTimeNotification,
            object: moviePlayer!.currentItem)
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