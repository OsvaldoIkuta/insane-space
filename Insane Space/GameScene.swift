//
//  GameScene.swift
//  Insane Space
//
//  Created by Osvaldo on 06/07/17.
//  Copyright (c) 2017 Osvaldo Ikuta. All rights reserved.
//
import UIKit
import SpriteKit
import GameKit

struct PhysicsCategory {
    static let Player : UInt32 =      0b1
    static let Bullet : UInt32 =      0b10
    static let Bullet2 : UInt32 =     0b100
    static let Meteor : UInt32 =      0b1000
    static let Enemy : UInt32 =       0b10000
    static let EnemyBullet : UInt32 = 0b100000
}

protocol GameSceneDelegate {
    //func startGame()
    func showRewardVideo()
    func saveGameCenterLeaderboard(highScore: Int)
    func showLeaderboard()
    func purchaseThreeLives()
    func purchaseDoubleFire()
    func backPurchase()
    func canMakePayments()
    func showInfo()
    func checkRewardedVideo() -> Bool
    func showRateMyApp()
    
}


class GameScene: SKScene, SKPhysicsContactDelegate {
    
    //var goStoreScene: StoreScene!
    var gameVC: GameSceneDelegate?
    
    //let playableRect: CGRect!
    
    var playerTail: SKEmitterNode!
    var enemyTail: SKEmitterNode!
    
    var player: SKSpriteNode!
    //var  meteor: SKSpriteNode!
    var limit: SKSpriteNode!
    var limitTop: SKSpriteNode!
    var restartGame: SKSpriteNode!
    var meteor: SKSpriteNode!
    var bullet: SKSpriteNode!
    var bullet2: SKSpriteNode!
    var enemy: SKSpriteNode!
    var enemyBullet: SKSpriteNode!
    var menuScene: SKSpriteNode!
    var gameCenter: SKSpriteNode!
    var loadAddBtn: SKSpriteNode!
    var viewAd: SKSpriteNode!
    var playBtn: SKSpriteNode!
    var gameCenterBtn: SKSpriteNode!
    var inAppPurchase: SKSpriteNode!
    var iapBtn: SKSpriteNode!
    var shieldButton: SKSpriteNode!
    var iapDoubleFire: SKSpriteNode!
    var iapThreeLives: SKSpriteNode!
    var backPurchaseBtn: SKSpriteNode!
    var infoBtn: SKSpriteNode!
    var tapToStartImg: SKSpriteNode!
    //var iapThreeLives: SKSpriteNode!
    //var cancelLoadAddBtn: SKSpriteNode!
    //var bulletNode:SKNode!
    //var meteorNode: SKNode!
    
    var livesArray:[SKSpriteNode]!
    
    var emitterColor: SKColor = SKColor.clearColor()
    
    var shield = SKShapeNode(circleOfRadius: 100)
    
    var bulletActionDuration: NSTimeInterval!
    var bulletDelayDuration: NSTimeInterval!
    var enemyBulletActionDuration: NSTimeInterval!
    var enemyBulletDelayDuration: NSTimeInterval!
    var meteorActionDuration: NSTimeInterval!
    var meteorDelayDuration: NSTimeInterval!
    var enemyActionDuration: NSTimeInterval!
    var enemyDelayDuration: NSTimeInterval!
    var starFieldVelocity: CGFloat!
    var emitterNodeScale: CGFloat!
    var emitterNodeVelocity: CGFloat!
    
    var gameStarted: Bool = false
    var gameOver: Bool = false
    var enemyDestroyed: Bool = false
    var playerDestroyedBool: Bool = false
    var meteorDestroyed: Bool = true
    var gameShowedAd: Bool = false
    var gameMenu: Bool = true
    var iapScene: Bool = false
    var playedSound: Bool = false
    var gameOverBool: Bool = false
    var askLoadAdBool: Bool = false
    var showLevelTitleBool: Bool = false
    var playerAlive: Bool = false
    var touchPlayBtn: Bool = false
    
    var spawnDelayMeteorForever: SKAction!
    var viewAdAction: SKAction!
    var playBtnAction: SKAction!
    var actionPlayer: SKAction!
    var actionEnemy: SKAction!
    var removeLives: SKAction!
    var delayBullets: SKAction!
    var spawnBullet: SKAction!
    var spawnDelayBullets: SKAction!
    var spawnDelayBulletsForever: SKAction!
    var followPlayer: SKAction!
    
    var gameScore: SKLabelNode!
    var gameInsaneScore: SKLabelNode!
    var askMessage: SKLabelNode!
    var cancelLoadAddBtn: SKLabelNode!
    var gameHighScore: SKLabelNode!
    var gameTitle: SKLabelNode!
    var threeLivesBtnIap: SKLabelNode!
    var doubleFireBtnIap: SKLabelNode!
    var showLevel: SKLabelNode!
    var tapToStart: SKLabelNode!
    
    var limitSize = CGSize()
    var limitColor = SKColor.whiteColor()
    
    
    let laserSound = SKAction.playSoundFileNamed("laser.wav", waitForCompletion: false)
    let explodeSound = SKAction.playSoundFileNamed("explode.wav", waitForCompletion: false)
    let gameOverSound = SKAction.playSoundFileNamed("gameover.mp3", waitForCompletion: false)
    let menuSound = SKAction.playSoundFileNamed("ad.mp3", waitForCompletion: false)
    let cheerSound = SKAction.playSoundFileNamed("cheer.mp3", waitForCompletion: false)
    
    var randomInt: Int!
    var numberPlayed: Int = 0
    var nextIntToRandom: Int = 10
    var addWillLoad: Int = 0
    var askLoadAdSoundPlayed: Int = 0
    var highScore: Int!
    var continueScore: Int!
    var score: Int = 0 {
        didSet {
            gameScore.text = "Score: \(score)"
            //gameScore.text = "Score: 10000000000000000000"
        }
    
    }
    
    override init(size: CGSize) {
        /*let maxAspectRatio: CGFloat = 16.0/9.0 //iPhone 5"
        let playableHeight = size.width / maxAspectRatio
        let playableMargin = (size.height-playableHeight)/2.0
        playableRect = CGRect(x: 0, y: playableMargin,
                              width: size.width,
                              height: playableHeight)*/
        
        super.init(size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func restartScene(){
        gameOverBool = false
        playedSound = false
        askLoadAdBool = false
        askLoadAdSoundPlayed = 0
        removeAllChildren()
        removeAllActions()
        gameOver = false
        gameStarted = false
        playerDestroyedBool = false
        gameShowedAd = false
        nextIntToRandom = 10
        score = 0
        addWillLoad = 0
        createScene()
        
    }
    
    func oneMoreChance() {
        removeAllChildren()
        removeAllActions()
        gameOver = false
        gameStarted = false
        score = continueScore
        addWillLoad = 1
        playerDestroyedBool = false
        createScene()
    }
    
    func createScene() {
        physicsWorld.contactDelegate = self
        
        //NSNotificationCenter.defaultCenter().postNotificationName("startGame", object: nil)
        
        //gameVC!.startGame()
        
        if addWillLoad == 0 {
            numberPlayed += 1
            showLevel(1)
            levelProprities(1.5, bulletDelay: 2.0, enemyBulletAction: 1.4, enemyBulletDelay: 1.9, meteorAction: 2.0, meteorDelay: 1.6, enemyAction: 0.6, enemyDelay: 2.0, starVelocity: -50, emitterColorSet: SKColor.clearColor())
            nextIntToRandom = 10
            playerAlive = (gameVC?.checkRewardedVideo())!
            tapToStart = SKLabelNode(text: "Tap to Start")
            tapToStart.fontName = "Chalkduster"
            tapToStart.fontColor = UIColor(red: 0.027, green: 0.623, blue: 0.631, alpha: 1.0)
            tapToStart.fontSize = 50
            tapToStart.position = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2)
            addChild(tapToStart)
            
            tapToStartImg = SKSpriteNode(imageNamed: "touch")
            tapToStartImg.position = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2 - self.frame.height / 5)
            tapToStartImg.zPosition = 100
            tapToStartImg.size = CGSizeMake(198, 198)
            tapToStartImg.setScale(0.8)
            addChild(tapToStartImg)
            let tapToStartImgAction = SKAction.sequence([
                SKAction.scaleTo(1.0, duration: 0.2),
                SKAction.scaleTo(0.8, duration: 0.2)])
            tapToStartImg.runAction(
                SKAction.repeatActionForever(tapToStartImgAction))
            gameScore = SKLabelNode(text: "Score: 0")
            let save = NSUserDefaults.standardUserDefaults()
            if save.valueForKey("ThreeLives") == nil {

            }else {
                addLives()
            }
            
        } else if addWillLoad == 1{
            tapToStart = SKLabelNode(text: "Tap to Continue")
            tapToStart.fontColor = UIColor(red: 0.027, green: 0.623, blue: 0.631, alpha: 1.0)
            tapToStart.fontName = "Chalkduster"
            tapToStart.fontSize = 50
            tapToStart.position = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2)
            addChild(tapToStart)
            
            tapToStartImg = SKSpriteNode(imageNamed: "touch")
            tapToStartImg.position = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2 - self.frame.height / 5)
            tapToStartImg.zPosition = 100
            tapToStartImg.size = CGSizeMake(198, 198)
            tapToStartImg.setScale(0.8)
            addChild(tapToStartImg)
            let tapToStartImgAction = SKAction.sequence([
                SKAction.scaleTo(1.0, duration: 0.2),
                SKAction.scaleTo(0.8, duration: 0.2)])
            tapToStartImg.runAction(
                SKAction.repeatActionForever(tapToStartImgAction))
            gameScore = SKLabelNode(text: "Score: \(continueScore)")
        }
        
        physicsWorld.gravity = CGVectorMake(0, -6)
        //self.scene?.size = CGSize(width: 640, height: 1136)
        /* Setup your scene here */
        /*let myLabel = SKLabelNode(fontNamed:"Chalkduster")
         myLabel.text = "Hello, World!"
         myLabel.fontSize = 45
         myLabel.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame))
         
         self.addChild(myLabel)*/
        
        //view?.showsPhysics = true
        let HighscoreDefault = NSUserDefaults.standardUserDefaults()
        if (HighscoreDefault.valueForKey("Highscore") != nil){
            
            highScore = HighscoreDefault.valueForKey("Highscore") as! NSInteger
        }
        else {
            
            highScore = 0
        }
        
        let starfieldNode = SKNode()
        starfieldNode.name = "starfieldNode"
        starfieldNode.addChild(starfieldEmitterNode(
            starFieldVelocity, lifetime: size.height / 23, scale: 0.1,
            birthRate: 5, color: SKColor.lightGrayColor(), position: CGPoint(x: self.size.width, y: self.size.height / 2), range: CGVector(dx: self.size.width + self.size.width, dy: self.size.height + 100), textImage: "🌟"))
        addChild(starfieldNode)
        
        let emitterNode = starfieldEmitterNode(
            -10, lifetime: size.height / 10, scale: 0.2, birthRate: 1, color: SKColor.lightGrayColor(), position: CGPoint(x: self.size.width, y: self.size.height / 2), range: CGVector(dx: self.size.width, dy: self.size.height + 100), textImage:"🌑")
        emitterNode.particleColor = emitterColor
        emitterNode.zPosition = -1
        starfieldNode.addChild(emitterNode)

        /*emitterNode = starfieldEmitterNode(
            -20, lifetime: size.height / 5, scale: 0.1, birthRate: 5, color: SKColor.lightGrayColor(), position: CGPoint(x: self.size.width, y: self.size.height / 2), range: CGVector(dx: self.size.width, dy: self.size.height + 100), textImage:"🌟")
        starfieldNode.addChild(emitterNode)*/
        
        limitSize = CGSize(width: size.width, height: 90)
        limit = SKSpriteNode(color: limitColor, size: limitSize)
        limit.position = CGPoint(x: self.size.width / 2, y: 0 - 50)
        limit.physicsBody = SKPhysicsBody(rectangleOfSize: limit.size)
        limit.physicsBody?.affectedByGravity = false
        limit.physicsBody?.dynamic = false
        limit.zPosition = 2
        addChild(limit)
        
    
        limitTop = SKSpriteNode(color: limitColor, size: limitSize)
        limitTop.position = CGPoint(x: self.size.width / 2, y: self.frame.height + 50)
        limitTop.physicsBody = SKPhysicsBody(rectangleOfSize: limit.size)
        limitTop.physicsBody?.affectedByGravity = false
        limitTop.physicsBody?.dynamic = false
        limitTop.zPosition = 2
        addChild(limitTop)
        
        gameScore.position = CGPoint(x: self.frame.width / 2 - self.frame.width / 4, y: self.frame.height / 2 + self.frame.height / 2.5)
        gameScore.fontName = "Chalkduster"
        gameScore.fontSize = 36
        gameScore.zPosition = 100
        gameScore.fontColor = UIColor(red: 0.027, green: 0.623, blue: 0.631, alpha: 1.0)
        addChild(gameScore)
        
        addPlayer()
        
        spawnEnemy()
    }
    
    override func didMoveToView(view: SKView) {
        gameMenuScene()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(GameScene.oneMoreChance), name: "oneMoreChance", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(GameScene.goToGameOverScene), name: "goToGameOverScene", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(GameScene.purchasedProduct), name: "purchasedProduct", object: nil)
    }
    
    func askForLoadAdd() {
        askLoadAdBool = true
        askMessage = SKLabelNode()
        askMessage.text = "ONE MORE CHANCE?"
        askMessage.fontName = "Chalkduster"
        askMessage.fontColor = UIColor(red: 0.027, green: 0.623, blue: 0.631, alpha: 1.0)
        askMessage.fontSize = 40
        askMessage.position = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2 + self.frame.height / 4)
        askMessage.zPosition = 100
        addChild(askMessage)
        
        loadAddBtn = SKSpriteNode(imageNamed: "moreOne")
        loadAddBtn.position = CGPoint(x: self.frame.width / 2 - self.frame.width / 7, y: self.frame.height / 2)
        loadAddBtn.zPosition = 100
        loadAddBtn.size = CGSizeMake(100, 120)
        addChild(loadAddBtn)
        viewAdAction = SKAction.sequence([
            SKAction.scaleTo(1.5, duration: 1),
            SKAction.scaleTo(1.3, duration: 1)])
        loadAddBtn.runAction(
            SKAction.repeatActionForever(viewAdAction))
        
        //cancelLoadAddBtn = SKSpriteNode(imageNamed: "leaderboard")
        //cancelLoadAddBtn.position = CGPoint(x: self.frame.width / 2 + self.frame.width / 2, y: self.frame.height / 2)
        //cancelLoadAddBtn.zPosition = 100
        //self.addChild(cancelLoadAddBtn)
        
        cancelLoadAddBtn = SKLabelNode()
        cancelLoadAddBtn.text = "CANCEL"
        cancelLoadAddBtn.fontName = "Chalkduster"
        cancelLoadAddBtn.fontColor = UIColor(red: 0.027, green: 0.623, blue: 0.631, alpha: 1.0)
        cancelLoadAddBtn.fontSize = 20
        cancelLoadAddBtn.position = CGPoint(x: self.frame.width / 2 + self.frame.width / 7, y: self.frame.height / 2 - self.frame.height / 8)
        cancelLoadAddBtn.zPosition = 100
        addChild(cancelLoadAddBtn)
    }
    
    func creteGameOverScene(){
        gameOverBool = true
        let HighscoreDefault = NSUserDefaults.standardUserDefaults()
        if (score >= highScore){
            HighscoreDefault.setValue(score, forKey: "Highscore")
            highScore = HighscoreDefault.valueForKey("Highscore") as! NSInteger
            HighscoreDefault.synchronize()
            
            
            gameVC?.saveGameCenterLeaderboard(highScore)
            
            let gameOverCongratulations = SKLabelNode(text: "Insane Score")
            gameOverCongratulations.position = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2 + self.frame.height / 3.5)
            gameOverCongratulations.fontName = "Chalkduster"
            gameOverCongratulations.zPosition = 100
            gameOverCongratulations.fontSize = 70
            gameOverCongratulations.setScale(0)
            gameOverCongratulations.fontColor = UIColor(red: 0.027, green: 0.623, blue: 0.631, alpha: 1.0)
            addChild(gameOverCongratulations)
            let gameOverCongratulationsAction = SKAction.sequence([
                SKAction.scaleTo(1.0, duration: 1),
                SKAction.scaleTo(0.8, duration: 1)])
            gameOverCongratulations.runAction(
                SKAction.repeatActionForever(gameOverCongratulationsAction))
            
        } else {
            let gameOverLabel = SKLabelNode(text: "Game Over")
            gameOverLabel.position = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2 + self.frame.height / 4)
            gameOverLabel.fontName = "Chalkduster"
            gameOverLabel.zPosition = 100
            gameOverLabel.fontSize = 70
            gameOverLabel.setScale(0)
            gameOverLabel.fontColor = UIColor(red: 0.027, green: 0.623, blue: 0.631, alpha: 1.0)
            addChild(gameOverLabel)
            let gameOverLabelAction = SKAction.sequence([
                SKAction.scaleTo(1.0, duration: 1),
                SKAction.scaleTo(0.8, duration: 1)])
            gameOverLabel.runAction(
                SKAction.repeatActionForever(gameOverLabelAction))
            
        }
        checkForAchievements()
        
        restartGame = SKSpriteNode(imageNamed: "play")
        restartGame.size = CGSizeMake(110, 120)
        restartGame.position = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2 - self.frame.height / 4)
        restartGame.zPosition = 100
        restartGame.setScale(5)
        addChild(restartGame)
        restartGame.runAction(SKAction.scaleTo(1.5, duration: 0.3))
        
        menuScene = SKSpriteNode(imageNamed: "home")
        //menuScene.setScale(0.3)
        menuScene.position = CGPoint(x: self.frame.width / 2 + self.frame.width / 3, y: self.frame.height / 2 - self.frame.height / 4)
        menuScene.zPosition = 100
        menuScene.size = CGSizeMake(110, 120)
        menuScene.setScale(0)
        addChild(menuScene)
        menuScene.runAction(SKAction.scaleTo(1, duration: 0.3))
        
        gameCenter = SKSpriteNode(imageNamed: "leaderboard")
        gameCenter.position = CGPoint(x: self.frame.width / 2 - self.frame.width / 3, y: self.frame.height / 2 - self.frame.height / 4)
        gameCenter.zPosition = 100
        gameCenter.size = CGSizeMake(110, 120)
        gameCenter.setScale(0)
        addChild(gameCenter)
        gameCenter.runAction(SKAction.scaleTo(1.0, duration: 0.3))
        
        gameInsaneScore = SKLabelNode()
        gameInsaneScore.fontName = "Chalkduster"
        gameInsaneScore.text = "High: \(highScore)"
        gameInsaneScore.fontColor = UIColor(red: 0.027, green: 0.623, blue: 0.631, alpha: 1.0)
        gameInsaneScore.position = CGPoint(x: self.frame.width / 2 + self.frame.width / 4, y: self.frame.height / 2)
        gameInsaneScore.zPosition = 100
        addChild(gameInsaneScore)
        
        let position = CGPoint(x: self.frame.width / 2 - self.frame.width / 4, y: gameInsaneScore.position.y)
        let gameScoreAction = SKAction.moveTo(position, duration: 1)//(self.size.width / 2 - self.size.width / 3, y: gameInsaneScore.position.y, duration: 1)
        gameScore.runAction(gameScoreAction)
        
    }
    
    func goToGameScene() {
        gameMenu = false
        playedSound = false
        addWillLoad = 0
        gameStarted = false
        gameOver = false
        playerDestroyedBool = false
        gameShowedAd = false
        createScene()
        score = 0
    
    }
    
    func purchasedProduct() {
        removeAllChildren()
        removeAllActions()
        gameVC?.canMakePayments()
        iapScene = true
        playTapSound()
        inAppPurchaseScene()
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        for touch in touches{
            let location = touch.locationInNode(self)
            
            if gameMenu == true && iapScene == false{
                if playBtn.containsPoint(location){
                    removeAllChildren()
                    removeAllActions()
                    playTapSound()
                    touchPlayBtn = true
                    goToGameScene()
                } else if gameCenterBtn.containsPoint(location) {
                    playTapSound()
                    gameVC?.showLeaderboard()
                }else if inAppPurchase.containsPoint(location){
                    removeAllChildren()
                    removeAllActions()
                    gameVC?.canMakePayments()
                    iapScene = true
                    playTapSound()
                    inAppPurchaseScene()
                    
                }
            }else if gameMenu == true && iapScene == true{
                if backPurchaseBtn.containsPoint(location) {
                    playTapSound()
                    gameVC?.backPurchase()
                    print("restore purchase")
                }else if iapDoubleFire.containsPoint(location) {
                    playTapSound()
                    gameVC?.purchaseDoubleFire()
                    print("call DoubleFire")
                }else if infoBtn.containsPoint(location) {
                    playTapSound()
                    gameVC?.showInfo()
                    print("info")
                } else if iapThreeLives.containsPoint(location) {
                    playTapSound()
                    gameVC?.purchaseThreeLives()
                    print("call three lives")
                }else if menuScene.containsPoint(location) {
                    removeAllChildren()
                    removeAllActions()
                    playTapSound()
                    iapScene = false
                    gameMenuScene()
                }
            }else if touchPlayBtn == true && gameStarted == false && gameMenu == false{
                gameShowedAd = false
                gameStarted = true
                player.physicsBody?.affectedByGravity = true
                
                tapToStart.removeFromParent()
                tapToStartImg.removeFromParent()
                
                playBackgroundMusic("Smart_Riot.mp3")
                
                //_ = NSTimer.scheduledTimerWithTimeInterval(0.3, target: self, selector: #selector(GameScene.spawnBullets), userInfo: nil, repeats: true)
                
                //_ = NSTimer.scheduledTimerWithTimeInterval(0.5, target: self, selector: #selector(GameScene.spawnMeteor), userInfo: nil, repeats: true)
                
                let spawn = SKAction.runBlock({
                    [weak self] in
                    
                    self?.spawnMeteor()
                    
                    })
                
                let delayMeteor = SKAction.waitForDuration(meteorDelayDuration)
                let spawnDelayMeteor = SKAction.sequence([delayMeteor, spawn])
                spawnDelayMeteorForever = SKAction.repeatActionForever(spawnDelayMeteor)
                runAction(spawnDelayMeteorForever)
                
                spawnBullet = SKAction.runBlock({
                    [weak self] in
                    
                    self?.spawnBullets()
                    self?.playLaserSound()
                    
                    })
                
                delayBullets = SKAction.waitForDuration(bulletDelayDuration)
                spawnDelayBullets = SKAction.sequence([spawnBullet, delayBullets])
                spawnDelayBulletsForever = SKAction.repeatActionForever(spawnDelayBullets)
                runAction(spawnDelayBulletsForever)
                
                continueSpawnEnemyBullets()
                
                
                player.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
                player.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 190))
                
                
            }
            else{
                
                if gameOver == true{
                    //scene!.physicsWorld.speed = 0.0
                    
                }
                else{
                    player.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
                    player.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 190))
                    
                    
                }
                
            }

            
            
            
            if gameOver == false && playerDestroyedBool == true{
                if loadAddBtn.containsPoint(location){
                    playTapSound()
                    gameVC!.showRewardVideo()
                    //NSNotificationCenter.defaultCenter().postNotificationName("showRewardVideo", object: nil)
                    //addPlayer()
                    
                } else if cancelLoadAddBtn.containsPoint(location){
                    playTapSound()
                    goToGameOverScene()
                    
                }
                
            } else if gameOver == true{
                if restartGame.containsPoint(location){
                    playTapSound()
                    restartScene()
                    
                } else if menuScene.containsPoint(location) {
                    gameMenu = true
                    removeAllChildren()
                    removeAllActions()
                    playTapSound()
                    gameOverBool = false
                    touchPlayBtn = false
                    gameMenuScene()
                } else if gameCenter.containsPoint(location) {
                    playTapSound()
                    gameVC?.showLeaderboard()
                }
            }
            
        }
        
        if gameStarted == true && gameMenu == false {
            actionEnemy = SKAction.moveToX(self.frame.width / 2 + self.frame.width / 2.5, duration: enemyActionDuration)
            enemy.runAction(actionEnemy)
        
        }
        
        if enemyDestroyed == true {
            spawnEnemy()
            enemyDestroyed = false
            //continueSpawnEnemyBullets()
        }

    }
    
    
    
    
    func didBeginContact(contact: SKPhysicsContact) {
        var firstBody = contact.bodyA
        var secondBody = contact.bodyB
        
        //|| (firstBody.categoryBitMask == PhysicsCategory.Player) && (secondBody.categoryBitMask == PhysicsCategory.Meteor)
        //|| (firstBody.categoryBitMask == PhysicsCategory.Player) && (secondBody.categoryBitMask == PhysicsCategory.EnemyBullet)
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        } else {
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        
        

        
        if (((firstBody.categoryBitMask == PhysicsCategory.Meteor) && (secondBody.categoryBitMask == PhysicsCategory.Bullet)) || ((firstBody.categoryBitMask == PhysicsCategory.Bullet) && (secondBody.categoryBitMask == PhysicsCategory.Meteor))){
            CollisionWithBullet(firstBody.node as! SKSpriteNode, Bullet: secondBody.node as! SKSpriteNode)
            score += 1
            meteorDestroyed = true
            
        } else if (firstBody.categoryBitMask == PhysicsCategory.Meteor) && (secondBody.categoryBitMask == PhysicsCategory.Player) {
            CollisionWithPlayer(firstBody.node as! SKSpriteNode, Player: secondBody.node as! SKSpriteNode)
            
        } else if (firstBody.categoryBitMask == PhysicsCategory.Player) && (secondBody.categoryBitMask == PhysicsCategory.Meteor){
            CollisionWithPlayer(secondBody.node as! SKSpriteNode, Player: firstBody.node as! SKSpriteNode)

        } else if (firstBody.categoryBitMask == PhysicsCategory.EnemyBullet) && (secondBody.categoryBitMask == PhysicsCategory.Player){
            CollisionWithPlayer(firstBody.node as! SKSpriteNode, Player: secondBody.node as! SKSpriteNode)

        
        } else if (firstBody.categoryBitMask == PhysicsCategory.Player) && (secondBody.categoryBitMask == PhysicsCategory.EnemyBullet){
            CollisionWithPlayer(secondBody.node as! SKSpriteNode, Player: firstBody.node as! SKSpriteNode)

        
        } else if (firstBody.categoryBitMask == PhysicsCategory.EnemyBullet) && (secondBody.categoryBitMask == PhysicsCategory.Bullet) || (firstBody.categoryBitMask == PhysicsCategory.Bullet) && (secondBody.categoryBitMask == PhysicsCategory.EnemyBullet){
            CollisionWithBullet(firstBody.node as! SKSpriteNode, Bullet: secondBody.node as! SKSpriteNode)
            
        } else if (firstBody.categoryBitMask == PhysicsCategory.Enemy) && (secondBody.categoryBitMask == PhysicsCategory.Bullet) || (firstBody.categoryBitMask == PhysicsCategory.Bullet) && (secondBody.categoryBitMask == PhysicsCategory.Enemy){
            CollisionWithEnemy(firstBody.node as! SKSpriteNode, Bullet: secondBody.node as! SKSpriteNode)
            score += 3
            
        } else if (firstBody.categoryBitMask == PhysicsCategory.Enemy) && (secondBody.categoryBitMask == PhysicsCategory.Meteor) || (firstBody.categoryBitMask == PhysicsCategory.Meteor) && (secondBody.categoryBitMask == PhysicsCategory.Enemy){
            CollisionWithEnemy(firstBody.node as! SKSpriteNode, Bullet: secondBody.node as! SKSpriteNode)
            
        }

    }
    
    
    func CollisionWithBullet(Enemy: SKSpriteNode, Bullet:SKSpriteNode){

        Enemy.removeFromParent()
        Bullet.removeFromParent()
        playExplodeSound()
        let explosionEmitter = SKEmitterNode(fileNamed: "explosion")
        explosionEmitter?.position = Enemy.position
        addChild(explosionEmitter!)
        
        runAction(SKAction.waitForDuration(0.5)){
            explosionEmitter!.removeFromParent()
        }
        
    }
    
    func CollisionWithEnemy(Enemy: SKSpriteNode, Bullet:SKSpriteNode){

        Enemy.removeFromParent()
        Bullet.removeFromParent()
        enemyRemoved()
        let explosionEmitter = SKEmitterNode(fileNamed: "explosion")
        playExplodeSound()
        explosionEmitter?.position = Enemy.position
        addChild(explosionEmitter!)
        
        runAction(SKAction.waitForDuration(0.5)){
            explosionEmitter?.removeFromParent()
        }

        
        
        
    }
    
    func CollisionWithPlayer(Enemy: SKSpriteNode, Player:SKSpriteNode){
        let save = NSUserDefaults.standardUserDefaults()
        if save.valueForKey("ThreeLives") == nil {
            playerDestroyed()
            Enemy.removeFromParent()
            Player.removeFromParent()
            playerDestroyedBool = true
            continueScore = score
            //Player.physicsBody?.mass = 300000
            //Player.physicsBody?.density = 300000
            let explosionEmitter = SKEmitterNode(fileNamed: "explosion")
            playExplodeSound()
            explosionEmitter?.position = Player.position
            addChild(explosionEmitter!)
            
            runAction(SKAction.waitForDuration(3)){
                explosionEmitter?.removeFromParent()
            }
            
        } else{
            
            if self.livesArray.count > 0 {
            
                let liveNode = self.livesArray.first
                liveNode!.removeFromParent()
                self.livesArray.removeFirst()
                removeLives = SKAction.sequence([
                    //SKAction.scaleTo(1.5, duration: 0.1),
                    //SKAction.scaleTo(1.0, duration: 0.1)
                    SKAction.fadeAlphaTo(0, duration: 0.5),
                    SKAction.fadeAlphaTo(1, duration: 0.5)
                    ])
                Player.runAction(
                    SKAction.repeatAction(removeLives, count: 5))
                Enemy.removeFromParent()
                let explosionEmitter = SKEmitterNode(fileNamed: "explosion")
                playExplodeSound()
                explosionEmitter?.position = Player.position
                addChild(explosionEmitter!)
            
                runAction(SKAction.waitForDuration(3)){
                    explosionEmitter?.removeFromParent()
                }
            
            } else if self.livesArray.count == 0{
                playerDestroyed()
                Enemy.removeFromParent()
                Player.removeFromParent()
                playerDestroyedBool = true
                continueScore = score
                //Player.physicsBody?.mass = 300000
                //Player.physicsBody?.density = 300000
                let explosionEmitter = SKEmitterNode(fileNamed: "explosion")
                playExplodeSound()
                explosionEmitter?.position = Player.position
                addChild(explosionEmitter!)
        
                runAction(SKAction.waitForDuration(3)){
                    explosionEmitter?.removeFromParent()
                }
            
            }
        
        }
        
    }
    
    func addLives (){
        
        livesArray = [SKSpriteNode]()
        
        for live in 1 ... 3 {
            let liveNode = SKSpriteNode(imageNamed: "3Lives")
            liveNode.name = "live\(live)"
            //liveNode.size = CGSize(width: 90, height: 88)
            liveNode.position = CGPoint(x: self.frame.size.width - CGFloat((4 - live)) * liveNode.size.width, y: self.frame.size.height - 60)
            self.addChild(liveNode)
            livesArray.append(liveNode)
        }
    }

    
    func spawnBullets(){
        let save = NSUserDefaults.standardUserDefaults()
        if save.valueForKey("DoubleFire") == nil {
            bullet = SKSpriteNode(imageNamed: "laser_blue")
            bullet.zPosition = -5
            bullet.name = "BULLET"
            //bullet.size = CGSize(width: 58, height: 24)
            bullet.position = CGPointMake(player.position.x + player.frame.width / 2, player.position.y - 19)
            let action = SKAction.moveToX(self.size.width + 30, duration: bulletActionDuration)
            let actionDone = SKAction.removeFromParent()
            bullet.runAction(SKAction.sequence([action, actionDone]))
            
            bullet.physicsBody = SKPhysicsBody(rectangleOfSize: bullet.size)
            bullet.physicsBody?.categoryBitMask = PhysicsCategory.Bullet
            bullet.physicsBody?.collisionBitMask = PhysicsCategory.Meteor | PhysicsCategory.Enemy | PhysicsCategory.EnemyBullet
            bullet.physicsBody?.contactTestBitMask = PhysicsCategory.Meteor | PhysicsCategory.Enemy | PhysicsCategory.EnemyBullet
            bullet.physicsBody?.affectedByGravity = false
            bullet.physicsBody?.dynamic = true
            addChild(bullet)
                        
        } else {
            bullet = SKSpriteNode(imageNamed: "laser_blue")
            bullet.zPosition = -5
            bullet.name = "BULLET"
            //bullet.size = CGSize(width: 58, height: 24)
            
            bullet2 = SKSpriteNode(imageNamed: "laser_blue")
            bullet2.zPosition = -5
            bullet2.name = "BULLET"
            //bullet2.size = CGSize(width: 58, height: 24)
            
            bullet.position = CGPointMake(player.position.x + ((player.frame.width / 2) - 20), ((player.position.y - 19) + 3))
            
            bullet2.position = CGPointMake(player.position.x + player.frame.width / 2, ((player.position.y - 19) - 3))
            
            let action = SKAction.moveByX(self.size.width + 30, y: self.size.height / 6, duration: bulletActionDuration)
            let actionDone = SKAction.removeFromParent()
            bullet.runAction(SKAction.sequence([action, actionDone]))
            
            let actionBullet2 = SKAction.moveByX(self.size.width + 30, y: -(self.size.height / 6), duration: bulletActionDuration)
            let actionDoneBullet2 = SKAction.removeFromParent()
            bullet2.runAction(SKAction.sequence([actionBullet2, actionDoneBullet2]))
            
            bullet.physicsBody = SKPhysicsBody(rectangleOfSize: bullet.size)
            bullet.physicsBody?.categoryBitMask = PhysicsCategory.Bullet
            bullet.physicsBody?.collisionBitMask = PhysicsCategory.Meteor | PhysicsCategory.Enemy | PhysicsCategory.EnemyBullet
            bullet.physicsBody?.contactTestBitMask = PhysicsCategory.Meteor | PhysicsCategory.Enemy | PhysicsCategory.EnemyBullet
            bullet.physicsBody?.affectedByGravity = false
            bullet.physicsBody?.dynamic = true
            
            bullet2.physicsBody = SKPhysicsBody(rectangleOfSize: bullet.size)
            bullet2.physicsBody?.categoryBitMask = PhysicsCategory.Bullet
            bullet2.physicsBody?.collisionBitMask = PhysicsCategory.Meteor | PhysicsCategory.Enemy | PhysicsCategory.EnemyBullet
            bullet2.physicsBody?.contactTestBitMask = PhysicsCategory.Meteor | PhysicsCategory.Enemy | PhysicsCategory.EnemyBullet
            bullet2.physicsBody?.affectedByGravity = false
            bullet2.physicsBody?.dynamic = true
            addChild(bullet)
            addChild(bullet2)
        
        }
        
    
    }
    /*
    func addShield() {
        shield.position = CGPoint(x: player.position.x, y: player.position.y)
        shield.strokeColor = SKColor.blueColor()
        shield.glowWidth = 1.0
        shield.fillColor = SKColor.cyanColor()
        shield.alpha = 0.2
        addChild(shield)
    }*/
    
    func addPlayer() {
        player = SKSpriteNode(imageNamed: "player")
        //player.name = "PLAYER"
        player.size = CGSize(width: 150, height: 87)
        player.setScale(1)
        player.position = CGPoint(x: 0, y: self.frame.height / 2)
        
        playerTail = SKEmitterNode(fileNamed: "tail")
        playerTail?.position = CGPoint(x: player.position.x - (player.frame.width / 2 - 20), y: player.position.y - 9)
        playerTail.zPosition = 51
        addChild(playerTail!)
        
        player.physicsBody = SKPhysicsBody(rectangleOfSize: player.size)
        player.physicsBody?.categoryBitMask = PhysicsCategory.Player
        player.physicsBody?.collisionBitMask = PhysicsCategory.Meteor | PhysicsCategory.EnemyBullet
        player.physicsBody?.contactTestBitMask = PhysicsCategory.Meteor | PhysicsCategory.EnemyBullet
        player.physicsBody?.affectedByGravity = false
        player.physicsBody?.dynamic = true
        player.physicsBody?.allowsRotation = false
        player.zPosition = 50
        addChild(player)
        actionPlayer = SKAction.moveToX(self.frame.width / 2 - self.frame.width / 2.5, duration: 1)
        player.runAction(actionPlayer)
    }
    
    func spawnMeteor(){
        meteor = SKSpriteNode(imageNamed: "asteroid.png")
        /*let MinValue = self.size.height / 8
        let MaxValue = self.size.height - 100
        let SpawnPoint = UInt32(MaxValue - MinValue)*/
        meteor.name = "METEOR"
        meteor.setScale(1.2)
        
        if player.position.y < self.frame.height / 2{
            meteor.position = CGPoint(x: self.frame.width + self.frame.width / 2, y: self.frame.height / 2 - 200)
            meteorDestroyed = false
        } else if player.position.y > self.frame.height / 2{
            meteor.position = CGPoint(x: self.frame.width + self.frame.width / 2, y: self.frame.height / 2 + 200)
            meteorDestroyed = false
        }
        
        //meteor.position = CGPoint(x: self.size.width + 100, y: CGFloat(arc4random_uniform(SpawnPoint)) + 100)
        meteor.physicsBody = SKPhysicsBody(circleOfRadius: meteor.size.height / 2)
        meteor.physicsBody?.categoryBitMask = PhysicsCategory.Meteor
        meteor.physicsBody?.collisionBitMask = PhysicsCategory.Bullet | PhysicsCategory.Player
        meteor.physicsBody?.contactTestBitMask = PhysicsCategory.Bullet | PhysicsCategory.Player
        meteor.physicsBody?.affectedByGravity = false
        meteor.physicsBody?.dynamic = false
        
        let action = SKAction.moveToX(-70, duration: meteorActionDuration)
        let actionDone = SKAction.removeFromParent()
        meteor.runAction(SKAction.sequence([action, actionDone]))
        //meteor.zPosition = 10
        addChild(meteor)
        //meteorNode.addChild(meteor)
        //addChild(meteorNode)
        
    }
    
    func spawnEnemy() {
        enemy = SKSpriteNode(imageNamed: "enemy")
        enemy.size = CGSize(width: 150, height: 87)
        enemy.setScale(1)
        
        enemyTail = SKEmitterNode(fileNamed: "tail")
        enemyTail?.position = CGPoint(x: enemy.position.x + (enemy.frame.width / 2 - 20), y: enemy.position.y - 9)
        enemyTail.zPosition = 51
        enemyTail.zRotation = CGFloat(M_PI)
        addChild(enemyTail!)
        //enemy.zRotation = CGFloat(M_PI)
        
        enemy.position = CGPoint(x: self.size.width + 200, y: self.frame.height / 2)
        addChild(enemy)
        
        
        
        enemy.physicsBody = SKPhysicsBody(rectangleOfSize: enemy.size)
        enemy.physicsBody?.categoryBitMask = PhysicsCategory.Enemy
        enemy.physicsBody?.collisionBitMask = PhysicsCategory.Meteor | PhysicsCategory.Bullet
        enemy.physicsBody?.contactTestBitMask = PhysicsCategory.Meteor | PhysicsCategory.Bullet
        enemy.physicsBody?.affectedByGravity = false
        enemy.physicsBody?.dynamic = false
        enemy.zPosition = 20
        
    
    }
    
    func spawnEnemyBullets(){
        enemyBullet = SKSpriteNode(imageNamed: "laser_red")
        enemyBullet.zPosition = -6
        enemyBullet.name = "ENEMYBULLET"
        
        
        enemyBullet.position = CGPointMake(enemy.position.x - enemy.frame.width / 2, enemy.position.y - 19)
        
        let actionEnemyBullet = SKAction.moveToX( 0 - 30, duration: enemyBulletActionDuration)
        let actionEnemyBulletDone = SKAction.removeFromParent()
        enemyBullet.runAction(SKAction.sequence([actionEnemyBullet, actionEnemyBulletDone]))
        
        enemyBullet.physicsBody = SKPhysicsBody(rectangleOfSize: bullet.size)
        enemyBullet.physicsBody?.categoryBitMask = PhysicsCategory.EnemyBullet
        enemyBullet.physicsBody?.collisionBitMask = PhysicsCategory.Player | PhysicsCategory.Bullet
        enemyBullet.physicsBody?.contactTestBitMask = PhysicsCategory.Player | PhysicsCategory.Bullet
        enemyBullet.physicsBody?.affectedByGravity = false
        enemyBullet.physicsBody?.dynamic = true
        addChild(enemyBullet)
    }
    
    func continueSpawnEnemyBullets() {
        let spawnEnemyBullet = SKAction.runBlock({
            [weak self] in
            
            self?.spawnEnemyBullets()
            self?.playLaserSound()
            
        })
        
        let delayEnemyBullets = SKAction.waitForDuration(enemyBulletDelayDuration)
        let spawnDelayEnemyBullets = SKAction.sequence([spawnEnemyBullet, delayEnemyBullets])
        let spawnDelayEnemyBulletsForever = SKAction.repeatActionForever(spawnDelayEnemyBullets)
        runAction(spawnDelayEnemyBulletsForever)
    
    }
    
    func playerDestroyed() {

        playerTail.removeFromParent()
        bullet.removeFromParent()
        
        stopScene()
        
        if gameOver == false && addWillLoad == 0{
            playerAlive = (gameVC?.checkRewardedVideo())!
            if (playerAlive == true) {
                backgroundMusicPlayer.stop()
                addWillLoad = 1
                gameShowedAd = true
                askForLoadAdd()
            } else {
                if backgroundMusicPlayer.playing {
                    backgroundMusicPlayer.stop()
                }
                gameOver = true
                creteGameOverScene()
            }
            
        } else if gameOver == false && addWillLoad == 1{
            if backgroundMusicPlayer.playing {
                backgroundMusicPlayer.stop()
            }
            gameOver = true
            creteGameOverScene()
            
        }
    
    }
    
    func enemyRemoved() {
        enemyTail.removeFromParent()
        /*runAction(SKAction.waitForDuration(1)){
            self.enemyBullet.removeFromParent()
        }*/
        if enemyBullet.position.y == 0 {
            enemyBullet.removeFromParent()
        }
        enemyDestroyed = true
    
    }
    
    func playLaserSound() {
        runAction(laserSound)
    }
    
    func playExplodeSound() {
        runAction(explodeSound)
    }
    
    func playTapSound() {
        self.runAction(tapSound)
    }
    
    func gameMenuSound() {
        runAction(menuSound)
    }
    
    /*func goToMenuScene() {
        //let scene = MenuScene(size: CGSize(width: 1024, height: 768))
        removeAllActions()
        removeAllChildren()
        let transitionEffect =
            SKTransition.crossFadeWithDuration(1.5)
        goMenuScene = MenuScene(size: CGSize(width: 1024, height: 768))
        goMenuScene.scaleMode = .AspectFill
        //gameScene!.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        view?.presentScene(goMenuScene! , transition:transitionEffect)
        
    }*/
   
    override func update(currentTime: CFTimeInterval) {
        
        switch gameMenu {
        case false:
            /*switch enemyDestroyed {
            case false:
                if enemy.position.x == self.frame.width / 2 + self.frame.width / 2.5 && meteorDestroyed == true {
                    followPlayer = SKAction.moveToY(player.position.y, duration: 0.5)
                    enemy.runAction(followPlayer)
                } else if enemy.position.x == self.frame.width / 2 + self.frame.width / 2.5 && meteor.position.y < self.frame.height / 2{
                    if player.position.y > self.frame.height / 2 {
                        followPlayer = SKAction.moveToY(player.position.y, duration: 0.5)
                        enemy.runAction(followPlayer)
                    } else {
                        followPlayer = SKAction.moveToY(self.frame.height / 2 + 50, duration: 0.5)
                        enemy.runAction(followPlayer)
                    }
                    
                    
                } else if enemy.position.x == self.frame.width / 2 + self.frame.width / 2.5 && meteor.position.y > self.frame.height / 2 {
                    if player.position.y < self.frame.height / 2 {
                        followPlayer = SKAction.moveToY(player.position.y, duration: 0.5)
                        enemy.runAction(followPlayer)
                    } else {
                        followPlayer = SKAction.moveToY(self.frame.height / 2 - 50, duration: 0.5)
                        enemy.runAction(followPlayer)
                    }
                    
                }
            default:
                break
            }*/
            
            if  player.position.x != self.frame.width / 2 - self.frame.width / 2.5 {
                actionPlayer = SKAction.moveToX(self.frame.width / 2 - self.frame.width / 2.5, duration: 1)
                player.runAction(actionPlayer)
            }
        default:
            break
        }
        
    
        /* Called before each frame is rendered */
        let int: Double = Double(score) / Double(nextIntToRandom)
        if  int >= 1 {
            randomLevel()
            nextIntToRandom += 10
        }
        
        if gameOver == true{
            stopScene()
            if showLevelTitleBool == true {
                showLevel.removeFromParent()
            }
            
        }else if gameOver == false && gameShowedAd == true {
            stopScene()
            if showLevelTitleBool == true {
                showLevel.removeFromParent()
            }
        }
        
        
        enemyTail?.position = CGPoint(x: enemy.position.x + (enemy.frame.width / 2 - 20), y: enemy.position.y - 9)
        playerTail?.position = CGPoint(x: player.position.x - (player.frame.width / 2 - 20), y: player.position.y - 9)
        
        /*if gameMenu == false && enemy.position.x == self.frame.width / 2 + self.frame.width / 2.5 && enemyDestroyed == false && meteorDestroyed == true {
            let followPlayer = SKAction.moveToY(player.position.y, duration: 0.5)
            enemy.runAction(followPlayer)
        } else if gameMenu == false && enemy.position.x == self.frame.width / 2 + self.frame.width / 2.5 && enemyDestroyed == false && meteor.position.y < self.frame.height / 2{
            if player.position.y > self.frame.height / 2 {
                let followPlayer = SKAction.moveToY(player.position.y, duration: 0.5)
                enemy.runAction(followPlayer)
            } else {
                let followPlayer = SKAction.moveToY(self.frame.height / 2 + 50, duration: 0.5)
                enemy.runAction(followPlayer)
            }
            
            
        } else if gameMenu == false && enemy.position.x == self.frame.width / 2 + self.frame.width / 2.5 && enemyDestroyed == false && meteor.position.y > self.frame.height / 2 {
            if player.position.y < self.frame.height / 2 {
                let followPlayer = SKAction.moveToY(player.position.y, duration: 0.5)
                enemy.runAction(followPlayer)
            } else {
                let followPlayer = SKAction.moveToY(self.frame.height / 2 - 50, duration: 0.5)
                enemy.runAction(followPlayer)
            }
            
        }*/
        
        if gameOverBool == true && playedSound == false{
            if (score >= highScore){
                runAction(cheerSound)
                playedSound = true
            } else {
                runAction(gameOverSound)
                playedSound = true
            }
        }
        
        if askLoadAdBool == true && askLoadAdSoundPlayed == 0 {
            gameMenuSound()
            askLoadAdSoundPlayed = 1
        }
        
        
    }
    
    
    func stopScene() {
        enumerateChildNodesWithName("BULLET", usingBlock: ({
            (node, error) in
            node.speed = 0
            self.removeFromParent()
            self.removeAllActions()
        }))
        
        enumerateChildNodesWithName("METEOR", usingBlock: ({
            (node, error) in
            node.speed = 0
            //self.removeFromParent()
            self.removeAllActions()
            
        }))

    }
    
    func goToGameOverScene() {
        loadAddBtn.removeFromParent()
        cancelLoadAddBtn.removeFromParent()
        askMessage.removeFromParent()
        creteGameOverScene()
        gameOver = true
    }
    
    func gameMenuScene() {
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
        
        playBtn = SKSpriteNode(imageNamed: "play")
        playBtn.name = "PLAY"
        playBtn.size = CGSize(width: 110, height: 120)
        playBtn.position = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2)
        playBtn.zPosition = 1
        playBtn.setScale(1)
        addChild(playBtn)
        playBtn.runAction(SKAction.scaleTo(2.0, duration: 0.3))
        
        gameCenterBtn = SKSpriteNode(imageNamed: "leaderboard")
        gameCenterBtn.size = CGSize(width: 110, height: 120)
        gameCenterBtn.position = CGPoint(x: self.frame.width / 2 - self.frame.width / 3, y: self.frame.height / 2)
        gameCenterBtn.zPosition = 1
        addChild(gameCenterBtn)
        
        inAppPurchase = SKSpriteNode(imageNamed: "store")
        inAppPurchase.size = CGSize(width: 110, height: 120)
        inAppPurchase.position = CGPoint(x: self.frame.width / 2 + self.frame.width / 3, y: self.frame.height / 2)
        inAppPurchase.zPosition = 1
        addChild(inAppPurchase)
        
        gameTitle = SKLabelNode(text: "Insane Space")
        gameTitle.text = "Insane Space"
        gameTitle.position = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2 + self.frame.height / 3.5)
        gameTitle.fontName = "Chalkduster"
        gameTitle.fontColor = UIColor(red: 0.027, green: 0.623, blue: 0.631, alpha: 1.0)
        gameTitle.fontSize = 70
        gameTitle.setScale(1)
        addChild(gameTitle)
        
        
        let HighscoreDefault = NSUserDefaults.standardUserDefaults()
        if (HighscoreDefault.valueForKey("Highscore") != nil){
            
            highScore = HighscoreDefault.valueForKey("Highscore") as! NSInteger
        }
        else {
            
            highScore = 0
        }
        
        //gameVC?.saveGameCenterLeaderboard(highScore)
        gameHighScore = SKLabelNode(text: "High Score")
        gameHighScore.text = "Insane Score: \(highScore)"
        gameHighScore.position = CGPoint(x: self.frame.width / 2 + self.frame.width / 3.8, y: self.frame.height / 2 - self.frame.height / 3)
        gameHighScore.fontName = "Chalkduster"
        gameHighScore.fontSize = 25
        gameHighScore.fontColor = UIColor(red: 0.027, green: 0.623, blue: 0.631, alpha: 1.0)
        addChild(gameHighScore)
    
    }
    
    func inAppPurchaseScene() {
        
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
        doubleFireLabel.text = "Double Laser - USD 2.99"
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
    
    func showLevel(number: Int) {
        showLevelTitleBool = true
        showLevel = SKLabelNode()
        showLevel.text = "Level \(number)"
        showLevel.position = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2 + self.frame.height / 3)
        showLevel.fontColor = UIColor(red: 0.027, green: 0.623, blue: 0.631, alpha: 1.0)
        showLevel.fontName = "Chalkduster"
        showLevel.fontSize = 50
        showLevel.zPosition = 100
        showLevel.setScale(2)
        addChild(showLevel)
        showLevel.runAction(SKAction.scaleTo(1.0, duration: 0.3))
        
        runAction(SKAction.waitForDuration(2)){
            self.showLevel.removeFromParent()
            self.showLevelTitleBool = false
        }
    }
    
    func levelProprities(bulletAction: NSTimeInterval, bulletDelay: NSTimeInterval, enemyBulletAction: NSTimeInterval, enemyBulletDelay: NSTimeInterval, meteorAction: NSTimeInterval, meteorDelay: NSTimeInterval, enemyAction: NSTimeInterval, enemyDelay: NSTimeInterval, starVelocity: CGFloat, emitterColorSet: SKColor) {
        bulletActionDuration = bulletAction
        bulletDelayDuration = bulletDelay
        enemyBulletActionDuration = enemyBulletAction
        enemyBulletDelayDuration = enemyBulletDelay
        meteorActionDuration = meteorAction
        meteorDelayDuration = meteorDelay
        enemyActionDuration = enemyAction
        enemyDelayDuration = enemyDelay
        starFieldVelocity = starVelocity
        emitterColor = emitterColorSet
    
    }
    
    func randomLevel() {
        randomInt = random(10) + 1
        //randomInt = 10
        switch randomInt {
        case 1:
            showLevel(randomInt)
            print("Level:\(randomInt)")
            levelProprities(1.5, bulletDelay: 2.0, enemyBulletAction: 1.4, enemyBulletDelay: 1.9, meteorAction: 2.0, meteorDelay: 1.6, enemyAction: 0.6, enemyDelay: 2.0, starVelocity: -50, emitterColorSet: SKColor.clearColor())
        case 2:
            showLevel(randomInt)
            print("Level:\(randomInt)")
            levelProprities(1.6, bulletDelay: 2.05, enemyBulletAction: 1.35, enemyBulletDelay: 1.8, meteorAction: 1.95, meteorDelay: 1.55, enemyAction: 0.6, enemyDelay: 2.0, starVelocity: -60, emitterColorSet: SKColor.clearColor())
        case 3:
            showLevel(randomInt)
            print("Level:\(randomInt)")
            levelProprities(1.7, bulletDelay: 2.1, enemyBulletAction: 1.3, enemyBulletDelay: 1.7, meteorAction: 1.9, meteorDelay: 1.5, enemyAction: 0.6, enemyDelay: 2.0, starVelocity: -65, emitterColorSet: SKColor.clearColor())
        case 4:
            showLevel(randomInt)
            print("Level:\(randomInt)")
            levelProprities(1.8, bulletDelay: 2.15, enemyBulletAction: 1.25, enemyBulletDelay: 1.6, meteorAction: 1.85, meteorDelay: 1.45, enemyAction: 0.6, enemyDelay: 2.0, starVelocity: -70, emitterColorSet: SKColor.yellowColor())
        case 5:
            showLevel(randomInt)
            print("Level:\(randomInt)")
            levelProprities(1.9, bulletDelay: 2.2, enemyBulletAction: 1.2, enemyBulletDelay: 1.5, meteorAction: 1.8, meteorDelay: 1.4, enemyAction: 0.6, enemyDelay: 2.0, starVelocity: -75, emitterColorSet: SKColor.yellowColor())
        case 6:
            showLevel(randomInt)
            print("Level:\(randomInt)")
            levelProprities(2.0, bulletDelay: 2.25, enemyBulletAction: 1.15, enemyBulletDelay: 1.4, meteorAction: 1.75, meteorDelay: 1.35, enemyAction: 0.5, enemyDelay: 2.0, starVelocity: -80, emitterColorSet: SKColor.yellowColor())
        case 7:
            showLevel(randomInt)
            print("Level:\(randomInt)")
            levelProprities(2.1, bulletDelay: 2.3, enemyBulletAction: 1.1, enemyBulletDelay: 1.3, meteorAction: 1.7, meteorDelay: 1.3, enemyAction: 0.5, enemyDelay: 2.0, starVelocity: -85, emitterColorSet: SKColor.orangeColor())
        case 8:
            showLevel(randomInt)
            print("Level:\(randomInt)")
            levelProprities(2.2, bulletDelay: 2.35, enemyBulletAction: 1.05, enemyBulletDelay: 1.2, meteorAction: 1.65, meteorDelay: 1.25, enemyAction: 0.5, enemyDelay: 2.0, starVelocity: -90, emitterColorSet: SKColor.orangeColor())
        case 9:
            showLevel(randomInt)
            print("Level:\(randomInt)")
            levelProprities(2.3, bulletDelay: 2.4, enemyBulletAction: 1.0, enemyBulletDelay: 1.1, meteorAction: 1.6, meteorDelay: 1.2, enemyAction: 0.5, enemyDelay: 2.0, starVelocity: -95, emitterColorSet: SKColor.redColor())
        case 10:
            showLevel(randomInt)
            print("Level:\(randomInt)")
            levelProprities(2.4, bulletDelay: 2.45, enemyBulletAction: 0.95, enemyBulletDelay: 1.0, meteorAction: 1.55, meteorDelay: 1.15, enemyAction: 0.5, enemyDelay: 2.0, starVelocity: -100, emitterColorSet: SKColor.redColor())
        default:
            break
        }
    }
    
    func checkForAchievements() {
        let save = NSUserDefaults.standardUserDefaults()
        if save.valueForKey("UserReviewedThisApp") == nil{
            if numberPlayed == 5 && connectedToNetwork() == true{
                gameVC?.showRateMyApp()
            }
        }
        if GKLocalPlayer.localPlayer().authenticated {
            let normalAchieve = GKAchievement(identifier: "normal_score")
            let lolAchieve = GKAchievement(identifier: "lol_score")
            let goodAchieve = GKAchievement(identifier: "good_score")
            let amazingAchieve = GKAchievement(identifier: "amazing_score")
            let insaneAchieve = GKAchievement(identifier: "insane_score")
            if score >= 50 && normalAchieve.percentComplete != 100 {
                normalAchieve.showsCompletionBanner = true
                normalAchieve.percentComplete = 100
                GKAchievement.reportAchievements([normalAchieve], withCompletionHandler: {(error : ErrorType?) -> Void in if error != nil {print("error")}})
            }
            
            if score == 0 && lolAchieve.percentComplete != 100 {
                lolAchieve.showsCompletionBanner = true
                lolAchieve.percentComplete = 100
                GKAchievement.reportAchievements([lolAchieve], withCompletionHandler: {(error : ErrorType?) -> Void in if error != nil {print("error")}})
            }
            
            if score >= 100 && goodAchieve.percentComplete != 100 {
                goodAchieve.showsCompletionBanner = true
                goodAchieve.percentComplete = 100
                GKAchievement.reportAchievements([goodAchieve], withCompletionHandler: {(error : ErrorType?) -> Void in if error != nil {print("error")}})
            }
            
            if score >= 1000 && amazingAchieve.percentComplete != 100 {
                amazingAchieve.showsCompletionBanner = true
                amazingAchieve.percentComplete = 100
                GKAchievement.reportAchievements([amazingAchieve], withCompletionHandler: {(error : ErrorType?) -> Void in if error != nil {print("error")}})
            }
            
            if score >= 10000 && insaneAchieve.percentComplete != 100 {
                insaneAchieve.showsCompletionBanner = true
                insaneAchieve.percentComplete = 100
                GKAchievement.reportAchievements([insaneAchieve], withCompletionHandler: {(error : ErrorType?) -> Void in if error != nil {print("error")}})
            }
            
            
        
        }
    }

    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: "oneMoreChance", object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: "goToGameOverScene", object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: "purchasedProduct", object: nil)
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}
