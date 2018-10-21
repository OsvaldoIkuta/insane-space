//
//  MenuScene.swift
//  Insane Space
//
//  Created by Osvaldo on 06/07/17.
//  Copyright © 2017 Osvaldo Ikuta. All rights reserved.
//

import UIKit
import SpriteKit

class MenuScene: SKScene {
    
    var playBtn: SKSpriteNode!
    var playBtnAction: SKAction!
    var gameCenterBtn: SKSpriteNode!
    var gameScene : GameScene?
    
    var gameHighScore: SKLabelNode!
    var gameTitle: SKLabelNode!
    
    var highScore: Int!
    
    override init(size: CGSize) {
        super.init(size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMoveToView(view: SKView) {
        //scene?.backgroundColor = UIColor.blackColor()
        
        playBtn = SKSpriteNode(imageNamed: "play")
        playBtn.name = "PLAY"
        playBtn.size = CGSize(width: 100, height: 120)
        playBtn.position = CGPoint(x: self.frame.width / 2 - self.frame.width / 6, y: self.frame.height / 2)
        playBtn.zPosition = 1
        addChild(playBtn)
        playBtnAction = SKAction.sequence([
            SKAction.scaleTo(1.1, duration: 1),
            SKAction.scaleTo(0.9, duration: 1)])
        playBtn.runAction(
            SKAction.repeatActionForever(playBtnAction))
        
        gameCenterBtn = SKSpriteNode(imageNamed: "leaderboard")
        gameCenterBtn.size = CGSize(width: 100, height: 120)
        gameCenterBtn.position = CGPoint(x: self.frame.width / 2 + self.frame.width / 6, y: self.frame.height / 2)
        gameCenterBtn.zPosition = 1
        addChild(gameCenterBtn)
        
        gameTitle = SKLabelNode(text: "Insane Space")
        gameTitle.text = "Insane Space"
        gameTitle.position = CGPoint(x: self.frame.width / 2, y: self.frame.height + 100)
        gameTitle.fontName = "Chalkduster"
        gameTitle.fontSize = 70
        gameTitle.fontColor = UIColor.whiteColor()
        let actionGameTitle = SKAction.moveToY(self.frame.height / 2 + self.frame.height / 4.2, duration: 0.9)
        gameTitle.runAction(actionGameTitle)
        
        addChild(gameTitle)
        
        let HighscoreDefault = NSUserDefaults.standardUserDefaults()
        if (HighscoreDefault.valueForKey("Highscore") != nil){
            
            highScore = HighscoreDefault.valueForKey("Highscore") as! NSInteger
        }
        else {
            
            highScore = 0
        }
        
        gameHighScore = SKLabelNode(text: "High Score")
        gameHighScore.text = "Insane Score: \(highScore)"
        gameHighScore.position = CGPoint(x: self.frame.width / 2 + self.frame.width / 3.8, y: self.frame.height / 2 - self.frame.height / 3)
        gameHighScore.fontName = "Chalkduster"
        gameHighScore.fontSize = 25
        gameHighScore.fontColor = UIColor.whiteColor()
        addChild(gameHighScore)
        
        let starfieldNode = SKNode()
        starfieldNode.name = "starfieldNode"
        starfieldNode.addChild(starfieldEmitterNode(
            -10, lifetime: size.height / 23, scale: 0.2,
            birthRate: 1, color: SKColor.lightGrayColor(), position: CGPoint(x: self.size.width + 100, y: self.size.height / 2), range: CGVector(dx: 0, dy: self.size.height + 100), textImage: "🌑"))
        addChild(starfieldNode)
        
        let emitterNode = starfieldEmitterNode(
            -15, lifetime: size.height / 10, scale: 0.1, birthRate: 10, color: SKColor.lightGrayColor(), position: CGPoint(x: self.size.width, y: self.size.height / 2), range: CGVector(dx: self.size.width, dy: self.size.height + 100), textImage:"🌟")
        emitterNode.zPosition = -1
        starfieldNode.addChild(emitterNode)
        
        
        /*emitterNode = starfieldEmitterNode(
            -20, lifetime: size.height / 5, scale: 0.1, birthRate: 5, color: SKColor.lightGrayColor(), position: CGPoint(x: self.size.width, y: self.size.height / 2), range: CGVector(dx: self.size.width, dy: self.size.height + 100), textImage:"🌟")
        starfieldNode.addChild(emitterNode)*/
        
        
        
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for touch: AnyObject in touches {
            let location = touch.locationInNode(self)
            let node = self.nodeAtPoint(location)
            if node.name == playBtn.name
            {
                goToGameScene()
            }

        }
    }
    
    func goToGameScene() {
        //let scene = MenuScene(size: CGSize(width: 1024, height: 768))
        removeAllActions()
        removeAllChildren()
        let transitionEffect =
            SKTransition.crossFadeWithDuration(2)
        gameScene = GameScene(size: self.size)
        //gameScene!.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        view?.presentScene(gameScene! , transition:transitionEffect)
    
    }

}
