//
//  NotificationViewController.swift
//  CustomNotificationContent
//
//  Created by kidnapper on 2018/11/25.
//  Copyright © 2018 kidnapper. All rights reserved.
//

import UIKit
import UserNotifications
import UserNotificationsUI
import SpriteKit
import GameplayKit

class NotificationViewController: UIViewController, UNNotificationContentExtension {
    
    @IBOutlet weak var gameView: SKView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let view = gameView {
            // Load the SKScene from 'GameScene.sks'
            if let scene = SKScene(fileNamed: "GameScene") {
                // Set the scale mode to scale to fit the window
                scene.scaleMode = .aspectFit
                
                // Present the scene
                view.presentScene(scene)
            }
            
            view.ignoresSiblingOrder = true
            
            view.showsFPS = true
            view.showsNodeCount = true
        }
    }
    
    func didReceive(_ notification: UNNotification) {
        
    }

}
