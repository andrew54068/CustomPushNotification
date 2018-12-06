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
        guard let payload: [String: AnyObject] = notification.request.content.userInfo as? [String: AnyObject] else { return }
        
        self.label?.text = notification.request.content.body
        
        let session: URLSession = URLSession(configuration: .default)
        if let imageUrl: URL = URL(string: payload["url"] as? String ?? "") {
            let dataTask: URLSessionDataTask = session.dataTask(with: imageUrl) { [weak self] (data, response, error) in
                guard let self = self else { return }
                if error == nil, let imageData: Data = data {
                    DispatchQueue.main.async {
                        self.imageView.image = UIImage(data: imageData as Data)
                    }
                }
            }
            dataTask.resume()
        }
        
    }

}
