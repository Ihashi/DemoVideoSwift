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
    private var playerItem: AVPlayerItem?
    private var videoPlayer: AVPlayer?
    private var videoNumber = 0
    private var urls = ["http://fun.siz.io/stories/142893791787803c7fb48f4d/0.mp4",
                "http://fun.siz.io/stories/1429024267698bb127fbd1bf/0.mp4",
                "http://fun.siz.io/stories/1429021517853eac7ce1fc29/0.mp4",
                "http://fun.siz.io/stories/1429018976114f45db3a5f88/0.mp4"]
    
    @IBOutlet weak var playerView: AVPlayerView!
    {
        didSet
        {
            playerView.addGestureRecognizer(UIPanGestureRecognizer(target:self, action: "changeVideo:"))
        }
    }
    
    private struct Constants
    {
        static let VideoGestureScale: CGFloat = 60
    }
    
    @IBAction func changeVideo(gesture: UIPanGestureRecognizer)
    {
        let translation = gesture.translationInView(view)
        let viewChange = translation.x / Constants.VideoGestureScale
        
        switch gesture.state
        {
        case .Changed:
            if let view = gesture.view
            {
                view.center = CGPoint(x: view.center.x + viewChange, y: view.center.y)
            }
        case .Ended:
            if(translation.x < -120)
            {
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
            else if (translation.x > 120)
            {
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

            gesture.view?.center = CGPoint(x: self.view.bounds.width/2, y: self.view.bounds.height/2)
            gesture.setTranslation(CGPointZero, inView: view)
        default: break
        }
    }
    
    func playVideo()
    {
        let url = NSURL(string: urls[videoNumber])
        playerItem = AVPlayerItem(URL: url)
        videoPlayer = AVPlayer(playerItem: playerItem)
        videoPlayer?.actionAtItemEnd = .None
        
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