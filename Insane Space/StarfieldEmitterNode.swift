//
//  StarfieldEmitterNode.swift
//  Insane Space
//
//  Created by Osvaldo on 06/07/17.
//  Copyright © 2017 Osvaldo Ikuta. All rights reserved.
//

import Foundation
import UIKit
import SpriteKit

func starfieldEmitterNode(speed: CGFloat, lifetime: CGFloat, scale: CGFloat, birthRate: CGFloat, color: SKColor, position: CGPoint, range: CGVector, textImage: String) -> SKEmitterNode {
    
    let star = SKLabelNode(fontNamed: "Helvetica")
    star.fontSize = 80.0
    star.text = textImage
    
    let textureView = SKView()
    let texture = textureView.textureFromNode(star)
    texture!.filteringMode = .Nearest
    
    let emitterNode = SKEmitterNode()
    emitterNode.particleTexture = texture
    emitterNode.particleBirthRate = birthRate
    emitterNode.particleColor = color
    emitterNode.particleLifetime = lifetime
    //emitterNode.particleSpeed = speed
    emitterNode.particleScale = scale
    emitterNode.particleColorBlendFactor = 1
    //emitterNode.position = CGPoint(x: self.size.width, y: self.size.height / 2)
    emitterNode.position = position
    emitterNode.xAcceleration = speed
    //emitterNode.particlePositionRange = CGVector(dx: self.size.width, dy: self.size.height + 100)
    emitterNode.particlePositionRange = range
    
    
    emitterNode.particleAction =
        SKAction.repeatActionForever(SKAction.sequence([
            SKAction.rotateByAngle(CGFloat(-M_PI_4), duration: 1),
            SKAction.rotateByAngle(CGFloat(M_PI_4), duration: 1)]))
    
    emitterNode.particleSpeedRange = 16.0
    /*
    let randomNum:UInt32 = ((arc4random_uniform(2)) + 1)
    let someInt:Int = Int(randomNum)
    
    if someInt == 1 {
        let twinkles = 1
        let colorSequence = SKKeyframeSequence(capacity: twinkles*2)
 
            colorSequence.addKeyframeValue(
                SKColor.yellowColor(), time: 4)

        emitterNode.particleColorSequence = colorSequence
    }*/
    emitterNode.advanceSimulationTime(NSTimeInterval(lifetime))
    
    return emitterNode
}
