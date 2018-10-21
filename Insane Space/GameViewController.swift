//
//  GameViewController.swift
//  Insane Space
//
//  Created by Osvaldo on 06/07/17.
//  Copyright (c) 2017 Osvaldo Ikuta. All rights reserved.
//

import UIKit
import SpriteKit
import GameKit
import StoreKit
import UnityAds

//import Firebase

class GameViewController: UIViewController, UnityAdsDelegate,  GameSceneDelegate, GKGameCenterControllerDelegate, SKProductsRequestDelegate, SKPaymentTransactionObserver{

    var list = [SKProduct]()
    var p = SKProduct()
    
    var gcEnabled = Bool()
    var gcDefaultLeaderBoard = String()
    
    func authenticateLocalPlayer() {
        let localPlayer: GKLocalPlayer = GKLocalPlayer.localPlayer()
        
        localPlayer.authenticateHandler = {(ViewController, error) -> Void in
            if((ViewController) != nil) {
                // 1 Show login if player is not logged in
                self.presentViewController(ViewController!, animated: true, completion: nil)
            } else if (localPlayer.authenticated) {
                // 2 Player is already euthenticated & logged in, load game center
                self.gcEnabled = true
                
                // Get the default leaderboard ID
                localPlayer.loadDefaultLeaderboardIdentifierWithCompletionHandler({ (leaderboardIdentifer: String?, error: NSError?) -> Void in
                    if error != nil {
                        print(error)
                    } else {
                        self.gcDefaultLeaderBoard = leaderboardIdentifer!
                    }
                })
                
                
            } else {
                // 3 Game center is not enabled on the users device
                self.gcEnabled = false
                print("Local player could not be authenticated, disabling game center")
                print(error)
            }
            
        }
        
    }
    
    
    
    func gameCenterViewControllerDidFinish(gameCenterViewController: GKGameCenterViewController) {
        gameCenterViewController.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func showLeaderboard() {
        let gcVC: GKGameCenterViewController = GKGameCenterViewController()
        gcVC.gameCenterDelegate = self
        gcVC.viewState = GKGameCenterViewControllerState.Leaderboards
        gcVC.leaderboardIdentifier = "insaneScore"
        self.presentViewController(gcVC, animated: true, completion: nil)
    }
    
    
    func saveGameCenterLeaderboard(highScore: Int) {
        let player = GKLocalPlayer.localPlayer()
        
        //check if user is signed in
        if player.authenticated {
            
            let bestScoreInt = GKScore(leaderboardIdentifier: "insaneScore")
            bestScoreInt.value = Int64(highScore)
            GKScore.reportScores([bestScoreInt]) { (error) in
                if error != nil {
                    print(error!.localizedDescription)
                } else {
                    print("Best Score submitted to your Leaderboard!")
                }
            }
            
        }
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        //canMakePayments()
        //rewardBasedVideo.self
        

        
        self.authenticateLocalPlayer()
        
        UnityAds.initialize("1530175", delegate: self)

        let scene = GameScene(size: CGSize(width: 1024, height: 768))
        //let scene = MenuScene(size: self.size)
            // Configure the view.
            let skView = self.view as! SKView
            skView.showsFPS = false
            skView.showsNodeCount = false
        

        
            
            /* Sprite Kit applies additional optimizations to improve rendering performance */
            skView.ignoresSiblingOrder = true
            
            /* Set the scale mode to scale to fit the window */
            scene.gameVC = self
            if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
                
            } else {
                //scene.scaleMode = .AspectFill
                scene.scaleMode = .AspectFit
            }
            //scene.scaleMode = .AspectFit
            //scene.anchorPoint = CGPoint(x: 0.5, y: 0.5)
            
            skView.presentScene(scene)
        
            //NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(GameViewController.startGame), name: "startGame", object: nil)
        
    }
    
    override func viewWillLayoutSubviews() {
        //NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(GameViewController.showRewardVideo), name: "showRewardVideo", object: nil)
    }
    /*
    func startGame(){
        if rewardBasedVideo?.ready == false {
            rewardBasedVideo?.loadRequest(GADRequest(), withAdUnitID: "ca-app-pub-3940256099942544/1712485313")
            //google ad unit id: ca-app-pub-3940256099942544/1712485313
            //my ad unit id: ca-app-pub-9891528850919164/3773338411
        }
    }
    
    func showRewardVideo() {
        if rewardBasedVideo?.ready == true {
            rewardBasedVideo?.presentFromRootViewController(self)
        } else {
            let alert = UIAlertController(title: "Alert", message: "Reward based video ad failed to load. Please, check your internet connection or try later.", preferredStyle: .Alert)
            let action = UIAlertAction(title: "Ok", style: .Default) { action in
                NSNotificationCenter.defaultCenter().postNotificationName("goToGameOverScene", object: nil)
            }
            alert.addAction(action)
            self.presentViewController(alert, animated: true, completion: nil)
        }
    
    }
    
    
    func rewardBasedVideoAd(rewardBasedVideoAd: GADRewardBasedVideoAd, didRewardUserWithReward reward: GADAdReward) {
        //print("Reward is: \(reward)")
        print("Reward received with currency: \(reward.type), amount \(reward.amount).")
        videoAdCompleted = true
        //NSNotificationCenter.defaultCenter().postNotificationName("oneMoreChance", object: nil)
    }
    
    func rewardBasedVideoAdDidReceive(rewardBasedVideoAd:GADRewardBasedVideoAd) {
        print("Reward based video ad is received.")
    }
    
    func rewardBasedVideoAdDidOpen(rewardBasedVideoAd: GADRewardBasedVideoAd) {

    }
    
    func rewardBasedVideoAdDidStartPlaying(rewardBasedVideoAd: GADRewardBasedVideoAd) {
        print("Reward based video ad started playing.")
    }
    
    func rewardBasedVideoAdDidClose(rewardBasedVideoAd: GADRewardBasedVideoAd) {
        if videoAdCompleted == true {
            NSNotificationCenter.defaultCenter().postNotificationName("oneMoreChance", object: nil)
            videoAdCompleted = false
        } else {
            NSNotificationCenter.defaultCenter().postNotificationName("goToGameOverScene", object: nil)
        }
        
    }
    
    func rewardBasedVideoAdWillLeaveApplication(rewardBasedVideoAd: GADRewardBasedVideoAd) {
        print("Reward based video ad will leave application.")
    }
    
    func rewardBasedVideoAd(rewardBasedVideoAd: GADRewardBasedVideoAd, didFailToLoadWithError error: NSError) {
        print("Reward based video ad failed to load.")
    }*/
    
    func showInfo() {
        let myAlert: UIAlertController = UIAlertController(title: "Info!", message: "If you had already bought any product above, and you uninstalled and installed this app, you can restore all purchases you have made. Just tap the (RESTORE) button.", preferredStyle: .Alert)
        myAlert.addAction(UIAlertAction(title: "OK", style: .Cancel, handler: nil))
        presentViewController(myAlert, animated: true, completion: nil)
    
    }
    
    func showRateMyApp() {
        let myAlert: UIAlertController = UIAlertController(title: "Please!!!", message: "⭐️⭐️⭐️ Review This Game ⭐️⭐️⭐️", preferredStyle: .Alert)
        myAlert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
        let action = UIAlertAction(title: "Review", style: .Default) { action in
            let appID = "1263249312"
            let urlStr = "itms-apps://itunes.apple.com/app/viewContentsUserReviews?id=\(appID)" // (Option 2) Open App Review Tab
            UIApplication.sharedApplication().openURL(NSURL(string: urlStr)!)
            let save = NSUserDefaults.standardUserDefaults()
            save.setBool(true, forKey: "UserReviewedThisApp")
            save.synchronize()
        }
        myAlert.addAction(action)
        presentViewController(myAlert, animated: true, completion: nil)
    }
    
    func checkRewardedVideo() -> Bool {
        let placement = "rewardedVideo"
        if (UnityAds.isReady(placement)) {
            return true
        } else {
            return false
        }
    }
    
    func showRewardVideo() {
        let placement = "rewardedVideo"
        if (UnityAds.isReady(placement)) {
            //a video is ready & placement is valid
            UnityAds.show(self, placementId: placement)
        } else{
            let alert = UIAlertController(title: "Alert", message: "Reward based video ad failed to load. Please, check your internet connection or try later.", preferredStyle: .Alert)
            let action = UIAlertAction(title: "Ok", style: .Default) { action in
                NSNotificationCenter.defaultCenter().postNotificationName("goToGameOverScene", object: nil)
            }
            alert.addAction(action)
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    func unityAdsDidFinish(placementId: String, withFinishState state: UnityAdsFinishState) {
        if state != .Skipped{
            //Add code to reward the player here
            NSNotificationCenter.defaultCenter().postNotificationName("oneMoreChance", object: nil)
        } else {
            NSNotificationCenter.defaultCenter().postNotificationName("goToGameOverScene", object: nil)
        }
    }
    func unityAdsReady(placementId: String) {
        print("Reward based video ad is ready.")
    }
    
    func unityAdsDidStart(placementId: String) {
        print("Reward based video ad started playing.")
    }
    
    func unityAdsDidError(error: UnityAdsError, withMessage message: String) {
        print("Reward based video ad error.")
    }
    
    
    func canMakePayments() {
        if(SKPaymentQueue.canMakePayments()) {
            let productID: NSSet = NSSet(objects: "com.osvaldoikuta.insaneSpace.threeLives", "com.osvaldoikuta.insaneSpace.doubleLaser")
            let request: SKProductsRequest = SKProductsRequest(productIdentifiers: productID as! Set<String>)
            request.delegate = self
            request.start()
        } else {
            let myAlert: UIAlertController = UIAlertController(title: "Please!", message: "Turn on In-App Purchases in Settings.", preferredStyle: .Alert)
            myAlert.addAction(UIAlertAction(title: "OK", style: .Cancel, handler: nil))
            presentViewController(myAlert, animated: true, completion: nil)
        }
    }
    
    func purchaseDoubleFire() {
        print("call double fire")
        if connectedToNetwork() == true {
            let saveD = NSUserDefaults.standardUserDefaults()
            if saveD.valueForKey("DoubleFire") == nil {
                let alert = UIAlertController(title: "Remember!", message: "Double Laser is non-consumable product, which means, you purchase just once and it NEVER expires.", preferredStyle: .Alert)
                let action = UIAlertAction(title: "Ok", style: .Default) { action in
                    for product in self.list {
                        let prodID = product.productIdentifier
                        if(prodID == "com.osvaldoikuta.insaneSpace.doubleLaser") {
                            self.p = product
                            self.buyProduct()
                        }
                    }
                }
                alert.addAction(action)
                self.presentViewController(alert, animated: true, completion: nil)
                
            } else {
                let myAlert: UIAlertController = UIAlertController(title: "Alert!", message: "You've already purchased this item and you can not purchase again.", preferredStyle: .Alert)
                myAlert.addAction(UIAlertAction(title: "OK", style: .Cancel, handler: nil))
                presentViewController(myAlert, animated: true, completion: nil)
            }
        }else {
            let myAlert: UIAlertController = UIAlertController(title: "Alert!", message: "Check your internet connection or try again later.", preferredStyle: .Alert)
            myAlert.addAction(UIAlertAction(title: "OK", style: .Cancel, handler: nil))
            presentViewController(myAlert, animated: true, completion: nil)
        }
    }
    
    func purchaseThreeLives() {
        print("call three lives 2")
        if connectedToNetwork() == true {
            let save = NSUserDefaults.standardUserDefaults()
            if save.valueForKey("ThreeLives") == nil {
                let alert = UIAlertController(title: "Remember!", message: "3 Lives is non-consumable product, which means, you purchase just once and it NEVER expires.", preferredStyle: .Alert)
                let action = UIAlertAction(title: "Ok", style: .Default) { action in
                    for product in self.list {
                        let prodID = product.productIdentifier
                        if(prodID == "com.osvaldoikuta.insaneSpace.threeLives") {
                            self.p = product
                            self.buyProduct()
                        }
                    }
                }
                alert.addAction(action)
                self.presentViewController(alert, animated: true, completion: nil)
                
            } else {
                let myAlert: UIAlertController = UIAlertController(title: "Alert!", message: "You've already purchased this item and you can not purchase again.", preferredStyle: .Alert)
                myAlert.addAction(UIAlertAction(title: "OK", style: .Cancel, handler: nil))
                presentViewController(myAlert, animated: true, completion: nil)
            }
        } else {
            let myAlert: UIAlertController = UIAlertController(title: "Alert!", message: "Check your internet connection or try again later.", preferredStyle: .Alert)
            myAlert.addAction(UIAlertAction(title: "OK", style: .Cancel, handler: nil))
            presentViewController(myAlert, animated: true, completion: nil)
        }
    }
    
    func backPurchase() {
        if connectedToNetwork() == true {
            SKPaymentQueue.defaultQueue().addTransactionObserver(self)
            SKPaymentQueue.defaultQueue().restoreCompletedTransactions()
        } else {
            let myAlert: UIAlertController = UIAlertController(title: "Alert!", message: "Check your internet connection or try again later.", preferredStyle: .Alert)
            let action = UIAlertAction(title: "Ok", style: .Cancel) { action in
                NSNotificationCenter.defaultCenter().postNotificationName("purchasedProduct", object: nil)
            }
            myAlert.addAction(action)
            presentViewController(myAlert, animated: true, completion: nil)
        }
    }
    
    func buyProduct() {
        print("buy " + p.productIdentifier)
        let pay = SKPayment(product: p)
        SKPaymentQueue.defaultQueue().addTransactionObserver(self)
        SKPaymentQueue.defaultQueue().addPayment(pay as SKPayment)
    }
    
    func threeLives() {
        let save = NSUserDefaults.standardUserDefaults()
        save.setBool(true, forKey: "ThreeLives")
        save.synchronize()
        NSNotificationCenter.defaultCenter().postNotificationName("purchasedProduct", object: nil)
    }
    
    func doubleFire() {
        let save = NSUserDefaults.standardUserDefaults()
        save.setBool(true, forKey: "DoubleFire")
        save.synchronize()
        NSNotificationCenter.defaultCenter().postNotificationName("purchasedProduct", object: nil)
    }
    
    
    func productsRequest(request: SKProductsRequest, didReceiveResponse response: SKProductsResponse) {
        print("product request")
        /*let myProduct = response.products
         for product in myProduct {
         print("product added")
         print(product.productIdentifier)
         print(product.localizedTitle)
         print(product.localizedDescription)
         print(product.price)
         
         list.append(product)
         }
        */
        
        if response.products.count != 0 {
            for product in response.products {
                list.append(product)
            }
            
            
        }
        else {
            print("There are no products.")
        }
        
    }
    
    func paymentQueue(queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        print("add payment")
        
        for transaction: AnyObject in transactions {
            let trans = transaction as! SKPaymentTransaction
            print(trans.error)
            
            switch trans.transactionState {
            case .Purchased:
                let prodID = p.productIdentifier
                switch prodID {
                case "com.osvaldoikuta.insaneSpace.threeLives":
                    let myAlert: UIAlertController = UIAlertController(title: "Thank you!", message: "Purchase completed.", preferredStyle: .Alert)
                    myAlert.addAction(UIAlertAction(title: "OK", style: .Cancel, handler: nil))
                    presentViewController(myAlert, animated: true, completion: nil)
                    threeLives()
                case "com.osvaldoikuta.insaneSpace.doubleLaser":
                    let myAlert: UIAlertController = UIAlertController(title: "Thank you!", message: "Purchase completed.", preferredStyle: .Alert)
                    myAlert.addAction(UIAlertAction(title: "OK", style: .Cancel, handler: nil))
                    presentViewController(myAlert, animated: true, completion: nil)
                    doubleFire()
                default:
                    print("IAP not found")
                }
                queue.finishTransaction(trans)
            case .Failed:
                let myAlert: UIAlertController = UIAlertController(title: "Purchase Failed!", message: "Unknown Error. Please Contact Support", preferredStyle: .Alert)
                myAlert.addAction(UIAlertAction(title: "OK", style: .Cancel, handler: nil))
                presentViewController(myAlert, animated: true, completion: nil)
                queue.finishTransaction(trans)
                break
            default:
                break
            }
        }
    }
    
    
    
    func paymentQueueRestoreCompletedTransactionsFinished(queue: SKPaymentQueue) {
        if queue.transactions.count == 0 {
            let myAlert: UIAlertController = UIAlertController(title: "Oops", message: "There are no purchases to restore, please buy one.", preferredStyle: .Alert)
            let action = UIAlertAction(title: "Ok", style: .Cancel) { action in
                NSNotificationCenter.defaultCenter().postNotificationName("purchasedProduct", object: nil)
            }
            myAlert.addAction(action)
            presentViewController(myAlert, animated: true, completion: nil)
        } else if queue.transactions.count > 0{
            for transaction in queue.transactions {
                let t: SKPaymentTransaction = transaction
                let prodID = t.payment.productIdentifier as String
            
                switch prodID {
                case "com.osvaldoikuta.insaneSpace.threeLives":
                    print("Three Lives")
                    threeLives()
                case "com.osvaldoikuta.insaneSpace.doubleLaser":
                    print("Double Fire")
                    doubleFire()
                default:
                    break
                }
            }
            let myAlert: UIAlertController = UIAlertController(title: "Purchases Restored!", message: "All purchases have been restored.", preferredStyle: .Alert)
            myAlert.addAction(UIAlertAction(title: "OK", style: .Cancel, handler: nil))
            presentViewController(myAlert, animated: true, completion: nil)
        }
    }

    override func shouldAutorotate() -> Bool {
        return true
    }

    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            return .Landscape
        } else {
            return .Landscape
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
        
    
    
}
