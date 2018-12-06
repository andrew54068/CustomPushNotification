//
//  ViewController.swift
//  CustomPushNotification
//
//  Created by kidnapper on 2018/11/25.
//  Copyright © 2018 kidnapper. All rights reserved.
//

import UIKit
import UserNotifications

class ViewController: UIViewController {
    @IBAction func sendAction(_ sender: Any) {
        sendLocalNotify()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @objc func sendLocalNotify() {
        let content = UNMutableNotificationContent()
        content.body = "this is body"
        content.title = "this is title"
        content.threadIdentifier = "threadIdentifier"
        content.categoryIdentifier = "categoryIdentifier"
        content.userInfo = ["url": "https://avatars0.githubusercontent.com/u/11587708?s=400&v=4"]
        
        guard let image = Bundle.main.url(forResource: "mario", withExtension: "png") else { return }
        let attachment = try! UNNotificationAttachment(identifier: "image", url: image, options: nil)
        
        content.attachments = [attachment]
        sendNotification(with: content)
    }
    
    func sendNotification(with content: UNNotificationContent) {
        let uuid = UUID().uuidString
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 3, repeats: false)
        let request = UNNotificationRequest(identifier: uuid, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }
}

