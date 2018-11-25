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

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let button: UIButton = UIButton(frame: CGRect(x: 300, y: 300, width: 150, height: 50))
        button.backgroundColor = .red
        button.setTitle("ask for permission", for: .normal)
        button.addTarget(self, action: #selector(requestAuthorization), for: .touchUpInside)
        view.addSubview(button)
    }


    @objc func requestAuthorization() {
        if #available(iOS 12.0, *) {
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge, .provisional]) { (granted, error) in
                print(granted)
                guard granted else { return }
                self.getNotificationSettings()
            }
        } else {
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { (granted, error) in
                print(granted)
                guard granted else { return }
                self.getNotificationSettings()
            }
        }
    }
    
    func getNotificationSettings() {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            if #available(iOS 12.0, *) {
                guard settings.authorizationStatus == .provisional else { return }
                DispatchQueue.main.async {
                    UIApplication.shared.registerForRemoteNotifications()
                }
                return
            }
            guard settings.authorizationStatus == .authorized else { return }
            DispatchQueue.main.async {
                UIApplication.shared.registerForRemoteNotifications()
            }
        }
    }
    
}

