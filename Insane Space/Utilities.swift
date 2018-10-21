//
//  Utilities.swift
//  Insane Space
//
//  Created by Osvaldo on 12/07/17.
//  Copyright © 2017 Osvaldo Ikuta. All rights reserved.
//

import Foundation
import AVFoundation
import UIKit
import SystemConfiguration
import SpriteKit
import GameKit


var backgroundMusicPlayer: AVAudioPlayer!
let tapSound = SKAction.playSoundFileNamed("tap.mp3", waitForCompletion: false)
func playBackgroundMusic(filename: String) {
    let url = NSBundle.mainBundle().URLForResource(
        filename, withExtension: nil)
        if (url == nil) {
            print("Could not find file: \(filename)")
            return
    }
    let error: NSError? = nil
    do {
        
        try backgroundMusicPlayer = AVAudioPlayer(contentsOfURL: url!)
        
    } catch {
        print(error)
    }
    
    
        if backgroundMusicPlayer == nil {
            print("Could not create audio player: \(error!)")
            return
        }

    backgroundMusicPlayer.numberOfLoops = -1
    backgroundMusicPlayer.prepareToPlay()
    backgroundMusicPlayer.play()
}

func random(n:Int) -> Int
{
    return Int(arc4random_uniform(UInt32(n)))
}

func connectedToNetwork() -> Bool {
    
    var zeroAddress = sockaddr_in()
    zeroAddress.sin_len = UInt8(sizeofValue(zeroAddress))
    zeroAddress.sin_family = sa_family_t(AF_INET)
    
    guard let defaultRouteReachability = withUnsafePointer(&zeroAddress, {
        SCNetworkReachabilityCreateWithAddress(nil, UnsafePointer($0))
    }) else {
        return false
    }
    
    var flags : SCNetworkReachabilityFlags = []
    if !SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) {
        return false
    }
    
    let isReachable = flags.contains(.Reachable)
    let needsConnection = flags.contains(.ConnectionRequired)
    
    return (isReachable && !needsConnection)
}

