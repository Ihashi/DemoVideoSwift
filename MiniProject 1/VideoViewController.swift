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
    @IBOutlet weak var playerView: AVPlayerView!
    private var playerItem: AVPlayerItem?
    private var videoPlayer: AVPlayer?
    private var videoNumber = 0
    private var urls = ["http://fun.siz.io/stories/142893791787803c7fb48f4d/0.mp4",
                "http://fun.siz.io/stories/1429024267698bb127fbd1bf/0.mp4",
                "http://fun.siz.io/stories/1429021517853eac7ce1fc29/0.mp4",
                "http://fun.siz.io/stories/1429018976114f45db3a5f88/0.mp4"]
    
    var videoNumber = 0
    
    private struct Constants
    {
        static let VideoGestureScale: CGFloat = 20
    }
    
    @IBAction func changeVideo(gesture: UIPanGestureRecognizer)
    {
        switch gesture.state
        {
        case .Ended: fallthrough
        case .Changed:
            let translation = gesture.translationInView(videoView)
            let viewChange = -Int(translation.x / Constants.VideoGestureScale)
            
            if(translation.x > 150)
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
                gesture.setTranslation(CGPointZero, inView: videoView)
            }
            else if (translation.x < -150)
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
                gesture.setTranslation(CGPointZero, inView: videoView)
            }
            
            if viewChange != 0
            {
                println("\(translation.x)")
            }
            
        default: break
        }
    }
    
    @IBOutlet weak var videoView: UIView!
    {
        didSet
        {
            videoView.addGestureRecognizer(UIPanGestureRecognizer(target:self, action: "changeVideo:"))
        }
    }
    
    func displayButton()
    {
        var leftButton = UIButton.buttonWithType(UIButtonType.System) as! UIButton
        leftButton.frame = CGRectMake(0, (screenSize.width/2)-20, 80, 40)
        leftButton.backgroundColor = .blackColor()
        leftButton.setTitle("<- Prev", forState: UIControlState.Normal)
        leftButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        
        let rightButton = UIButton.buttonWithType(UIButtonType.System) as! UIButton
        rightButton.frame = CGRectMake((screenSize.height)-80, (screenSize.width/2)-20, 80, 40)
        rightButton.backgroundColor = .blackColor()
        rightButton.setTitle("Next ->", forState: UIControlState.Normal)
        rightButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        
        self.view.addSubview(leftButton)
        self.view.addSubview(rightButton)
    }
    
    func playVideo()
    {
        let url = NSURL(string: urls[videoNumber])
        playerItem = AVPlayerItem(URL: url)
        moviePlayer = AVPlayer(playerItem: playerItem)
        playerLayer = AVPlayerLayer(player: moviePlayer)
        moviePlayer!.actionAtItemEnd = .None
        
        playerLayer!.frame = CGRect(x: 0, y: 0, width: screenSize.height, height: screenSize.width)
        self.view.backgroundColor = .blackColor()
        self.view.layer.addSublayer(playerLayer)
        
        self.playerView.setPlayer(self.videoPlayer!)
        self.playerView.setVideoFillMode(AVLayerVideoGravityResizeAspect)

        videoPlayer?.play()
        
        NSNotificationCenter.defaultCenter().addObserver(self,
            selector: "restartVideo",
            name: AVPlayerItemDidPlayToEndTimeNotification,
            object: videoPlayer?.currentItem)
    }
    
    func restartVideo()
    {
        let seconds : Int64 = 0
        let preferredTimeScale : Int32 = 1
        let seekTime : CMTime = CMTimeMake(seconds, preferredTimeScale)
        
        videoPlayer?.seekToTime(seekTime)
        videoPlayer?.play()
    }
    
    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(true)
        playVideo()
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    deinit
    {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
}