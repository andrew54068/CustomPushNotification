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

class NotificationViewController: UIViewController, UNNotificationContentExtension {

    @IBOutlet weak var label: UILabel?
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var button: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any required interface initialization here.
    }
    
    func didReceive(_ notification: UNNotification) {
        self.label?.text = notification.request.content.body
        
        let imageAttachment = notification.request.content.attachments[0]
        
        guard let imageData = NSData(contentsOf: imageAttachment.url) else { return }
        imageView.image = UIImage(data: imageData as Data)
        
    }


}
