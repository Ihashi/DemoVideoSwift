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
    private var moviePlayer: AVPlayer?
    private var playerLayer: AVPlayerLayer?
    private var playerItem: AVPlayerItem?
    private var leftButton: UIButton?
    private var rightButton: UIButton?
    
    let screenSize = UIScreen.mainScreen().bounds
    private var urls = ["http://fun.siz.io/stories/142893791787803c7fb48f4d/0.mp4",
                "http://fun.siz.io/stories/1429024267698bb127fbd1bf/0.mp4",
                "http://fun.siz.io/stories/1429021517853eac7ce1fc29/0.mp4",
                "http://fun.siz.io/stories/1429018976114f45db3a5f88/0.mp4"]
    
    private var videoNumber = 0
    
    func displayButton()
    {
        let leftButton = UIButton.buttonWithType(UIButtonType.System) as! UIButton
        leftButton.frame = CGRectMake(0, (screenSize.width/2)-20, 80, 40)
        leftButton.backgroundColor = .blackColor()
        leftButton.setTitle("Prev", forState: UIControlState.Normal)
        leftButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        leftButton.addTarget(self, action: "previousVideo", forControlEvents: UIControlEvents.TouchUpInside)
        
        let rightButton = UIButton.buttonWithType(UIButtonType.System) as! UIButton
        rightButton.frame = CGRectMake((screenSize.height)-80, (screenSize.width/2)-20, 80, 40)
        rightButton.backgroundColor = .blackColor()
        rightButton.setTitle("Next", forState: UIControlState.Normal)
        rightButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        rightButton.addTarget(self, action: "nextVideo", forControlEvents: UIControlEvents.TouchUpInside)
        
        view.addSubview(leftButton)
        view.addSubview(rightButton)
    }
    
    func removePlayerAndButtons()
    {
        NSNotificationCenter.defaultCenter().removeObserver(self,
            name: AVPlayerItemDidPlayToEndTimeNotification,
            object: moviePlayer?.currentItem)
        
        moviePlayer?.pause()
        playerLayer?.removeFromSuperlayer()
        rightButton?.removeFromSuperview()
        leftButton?.removeFromSuperview()
    }
    
    func previousVideo()
    {
        removePlayerAndButtons()
        
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
    
    func nextVideo()
    {
        removePlayerAndButtons()
        
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
        moviePlayer?.actionAtItemEnd = .None
        
        playerLayer?.frame = CGRect(x: 0, y: 0, width: screenSize.height, height: screenSize.width)
        self.view.backgroundColor = .blackColor()
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
        
        moviePlayer?.seekToTime(seekTime)
        moviePlayer?.play()
    }
    
    deinit
    {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(true)
        playVideo()
    }
}