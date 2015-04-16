//
//  AVPlayerView.swift
//  MiniProject 1
//
//  Created by ESIEA on 15/04/2015.
//  Copyright (c) 2015 HaiNguyen. All rights reserved.
//

import UIKit
import AVFoundation

class AVPlayerView : UIView {
    
    override class func layerClass() -> AnyClass {
        return AVPlayerLayer.self
    }

    func setPlayer(player: AVPlayer) {
        let layer: AVPlayerLayer = self.layer as! AVPlayerLayer
        layer.player = player
    }
    
    func setVideoFillMode(fillMode: NSString) {
        let layer: AVPlayerLayer = self.layer as! AVPlayerLayer
        layer.videoGravity = fillMode as! String
    }
}
