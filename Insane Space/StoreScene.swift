//
//  GameOverScene.swift
//  Insane Space
//
//  Created by Osvaldo on 06/07/17.
//  Copyright © 2017 Osvaldo Ikuta. All rights reserved.
//

import UIKit
import SpriteKit


/*protocol StoreDelegate {

    func purchaseThreeLives()
    func purchaseDoubleFire()
    func backPurchase()
    func canMakePayments()
    func showInfo()
    
}*/

class StoreScene: SKScene {
    var gameScene : GameScene?
    
    //var storeVC: StoreDelegate?
    
    var iapDoubleFire: SKSpriteNode!
    var iapThreeLives: SKSpriteNode!
    var backPurchaseBtn: SKSpriteNode!
    var infoBtn: SKSpriteNode!
    var menuScene: SKSpriteNode!
    
    override init(size: CGSize) {
        super.init(size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMoveToView(view: SKView) {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(GameScene.purchasedProduct), name: "purchasedProduct", object: nil)
        let starfieldNode = SKNode()
        starfieldNode.name = "starfieldNode"
        starfieldNode.addChild(starfieldEmitterNode(
            0, lifetime: 3, scale: 0.2,
            birthRate: 3, color: SKColor.lightGrayColor(), position: CGPoint(x: self.size.width / 2, y: self.frame.height / 2 + self.frame.height / 3.5), range: CGVector(dx: self.size.width / 2, dy: self.size.height / 3), textImage: "🌟"))
        addChild(starfieldNode)
        
        let emitterNode = starfieldEmitterNode(
            0, lifetime: 5, scale: 0.1, birthRate: 15, color: SKColor.lightGrayColor(), position: CGPoint(x: self.size.width / 2, y: self.size.height / 2), range: CGVector(dx: self.size.width / 2 + self.size.width / 3, dy: self.size.height + self.size.width / 4), textImage:"🌟")
        emitterNode.zPosition = -1
        starfieldNode.addChild(emitterNode)
        
        let iapTitle = SKLabelNode()
        iapTitle.text = "Store"
        iapTitle.position = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2 + self.frame.height / 3.3)
        iapTitle.fontName = "Chalkduster"
        iapTitle.fontSize = 70
        iapTitle.setScale(1)
        iapTitle.fontColor = UIColor(red: 0.027, green: 0.623, blue: 0.631, alpha: 1.0)
        addChild(iapTitle)
        
        
        menuScene = SKSpriteNode(imageNamed: "home")
        menuScene.setScale(0.2)
        menuScene.size = CGSize(width: 60, height: 65)
        menuScene.position = CGPoint(x: self.frame.width / 2 - self.frame.width / 2.2, y: self.frame.height - 50)
        menuScene.zPosition = 100
        menuScene.setScale(0)
        addChild(menuScene)
        menuScene.runAction(SKAction.scaleTo(0.3, duration: 0.3))
        
        let save = NSUserDefaults.standardUserDefaults()
        if save.valueForKey("ThreeLives") == nil {
            
        }else {
            let purchased = SKLabelNode(text: "Purchased")
            purchased.position = CGPoint(x: self.frame.width / 2 - self.frame.width / 4, y: self.frame.height / 2)
            purchased.fontName = "Chalkduster"
            purchased.fontSize = 40
            purchased.fontColor = UIColor(red: 0.027, green: 0.623, blue: 0.631, alpha: 1.0)
            purchased.zPosition = 100
            addChild(purchased)
            
        }
        
        iapThreeLives = SKSpriteNode(imageNamed: "como1")
        //iapThreeLives.size = CGSize(width: 100, height: 120)
        iapThreeLives.position = CGPoint(x: self.frame.width / 2 - self.frame.width / 4, y: self.frame.height / 2)
        iapThreeLives.zPosition = 1
        iapThreeLives.setScale(0.5)
        addChild(iapThreeLives)
        iapThreeLives.runAction(SKAction.scaleTo(0.8, duration: 0.3))
        let iapThreeLivesAction = SKAction.sequence([
            SKAction.scaleTo(1.0, duration: 1),
            SKAction.scaleTo(0.9, duration: 1)])
        iapThreeLives.runAction(
            SKAction.repeatActionForever(iapThreeLivesAction))
        
        let threeLivesLabel = SKLabelNode()
        threeLivesLabel.text = "3 Lives - USD 1.99"
        threeLivesLabel.position = CGPoint(x: self.frame.width / 2 - self.frame.width / 4, y: (self.frame.height / 2 - iapThreeLives.frame.height ) - 40)
        threeLivesLabel.fontName = "Chalkduster"
        threeLivesLabel.fontSize = 25
        threeLivesLabel.fontColor = UIColor(red: 0.027, green: 0.623, blue: 0.631, alpha: 1.0)
        addChild(threeLivesLabel)
        
        
        
        /*threeLivesBtnIap = SKLabelNode()
         threeLivesBtnIap.text = "Purchase"
         threeLivesBtnIap.position = CGPoint(x: self.frame.width / 2 - self.frame.width / 4, y: (self.frame.height / 2 - iapThreeLives.frame.height) - 70)
         threeLivesBtnIap.fontName = "Chalkduster"
         threeLivesBtnIap.fontSize = 25
         threeLivesBtnIap.fontColor = UIColor.whiteColor()
         addChild(threeLivesBtnIap)*/
        
        let saveD = NSUserDefaults.standardUserDefaults()
        if saveD.valueForKey("DoubleFire") == nil {
            
        } else {
            let purchasedD = SKLabelNode(text: "Purchased")
            purchasedD.position = CGPoint(x: self.frame.width / 2 + self.frame.width / 4, y: self.frame.height / 2)
            purchasedD.fontName = "Chalkduster"
            purchasedD.fontSize = 40
            purchasedD.zPosition = 100
            purchasedD.fontColor = UIColor(red: 0.027, green: 0.623, blue: 0.631, alpha: 1.0)
            addChild(purchasedD)
            
        }
        
        iapDoubleFire = SKSpriteNode(imageNamed: "como2")
        //iapDoubleFire.size = CGSize(width: 100, height: 120)
        iapDoubleFire.position = CGPoint(x: self.frame.width / 2 + self.frame.width / 4, y: self.frame.height / 2)
        iapDoubleFire.zPosition = 1
        iapDoubleFire.setScale(0.5)
        addChild(iapDoubleFire)
        iapDoubleFire.runAction(SKAction.scaleTo(0.8, duration: 0.3))
        let iapDoubleFireAction = SKAction.sequence([
            SKAction.scaleTo(1.0, duration: 1),
            SKAction.scaleTo(0.9, duration: 1)])
        iapDoubleFire.runAction(
            SKAction.repeatActionForever(iapDoubleFireAction))
        
        let doubleFireLabel = SKLabelNode()
        doubleFireLabel.text = "Double Fire - USD 2.99"
        doubleFireLabel.position = CGPoint(x: self.frame.width / 2 + self.frame.width / 4, y: (self.frame.height / 2 - iapDoubleFire.frame.height) - 40)
        doubleFireLabel.fontName = "Chalkduster"
        doubleFireLabel.fontSize = 25
        doubleFireLabel.fontColor = UIColor(red: 0.027, green: 0.623, blue: 0.631, alpha: 1.0)
        addChild(doubleFireLabel)
        
        
        
        /*doubleFireBtnIap = SKLabelNode()
         doubleFireBtnIap.text = "Purchase"
         doubleFireBtnIap.position = CGPoint(x: self.frame.width / 2 + self.frame.width / 4, y: (self.frame.height / 2 - iapThreeLives.frame.height) - 70)
         doubleFireBtnIap.fontName = "Chalkduster"
         doubleFireBtnIap.fontSize = 25
         doubleFireBtnIap.fontColor = UIColor.whiteColor()
         addChild(doubleFireBtnIap)*/
        
        backPurchaseBtn = SKSpriteNode(imageNamed: "restore")
        backPurchaseBtn.size = CGSize(width: 198, height: 99)
        backPurchaseBtn.position = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2 - self.frame.height / 2.7 )
        backPurchaseBtn.setScale(0.65)
        backPurchaseBtn.alpha = 0.8
        backPurchaseBtn.zPosition = 1
        addChild(backPurchaseBtn)
        
        infoBtn = SKSpriteNode(imageNamed: "info")
        infoBtn.size = CGSize(width: 198, height: 198)
        infoBtn.position = CGPoint(x: self.frame.width / 2 + (backPurchaseBtn.frame.width - 25), y: self.frame.height / 2 - self.frame.height / 2.7 )
        infoBtn.setScale(0.3)
        infoBtn.alpha = 0.5
        infoBtn.zPosition = 1
        addChild(infoBtn)
    }
    
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for touch in touches{
            let location = touch.locationInNode(self)
            if menuScene.containsPoint(location)
            {
                goToGameScene()
            }/*else if backPurchaseBtn.containsPoint(location) {
                playTapSound()
                storeVC?.backPurchase()
                print("restore purchase")
            }else if iapDoubleFire.containsPoint(location) {
                playTapSound()
                storeVC?.purchaseDoubleFire()
                print("call DoubleFire")
            }else if infoBtn.containsPoint(location) {
                playTapSound()
                storeVC?.showInfo()
                print("info")
            } else if iapThreeLives.containsPoint(location) {
                playTapSound()
                storeVC?.purchaseThreeLives()
                print("call three lives")
            }*/
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
    
    func playTapSound() {
        runAction(tapSound)
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: "purchasedProduct", object: nil)
    }
}


