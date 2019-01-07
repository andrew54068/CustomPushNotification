//
//  AppDelegate.swift
//  CustomPushNotification
//
//  Created by kidnapper on 2018/11/25.
//  Copyright © 2018 kidnapper. All rights reserved.
//

import UIKit
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        UNUserNotificationCenter.current().delegate = self
        requestAuthorization()
        return true
    }
    
    @objc func requestAuthorization() {
//        if #available(iOS 12.0, *) {
//            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge, .provisional, .providesAppNotificationSettings]) { (granted, error) in
//                print(granted)
//                guard granted else { return }
//                self.getNotificationSettings()
//            }
//        } else {
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { (granted, error) in
                print(granted)
                guard granted else { return }
                self.getNotificationSettings()
            }
//        }
    }
    
    func getNotificationSettings() {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
//            if #available(iOS 12.0, *) {
//                guard settings.authorizationStatus == .provisional else { return }
//                DispatchQueue.main.async {
//                    UIApplication.shared.registerForRemoteNotifications()
//                }
//                return
//            }
            guard settings.authorizationStatus == .authorized else { return }
            DispatchQueue.main.async {
                UIApplication.shared.registerForRemoteNotifications()
            }
        }
    }

    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let token = deviceToken.map { String(format: "%02.2hhx", arguments: [$0]) }.joined(separator: "")
        print(token)
        sendPushTokenToServer(token: token)
    }
    
    private func sendPushTokenToServer(token: String) {
        let endPoint = "http://localhost:8080\(UITestingConstants.pushEndpoint)"
        
        guard let endpointUrl = URL(string: endPoint) else { return }
        
        var json: [String: Any] = [:]
        json[UITestingConstants.pushTokenKey] = token
        
        guard let data = try? JSONSerialization.data(withJSONObject: json, options: []) else { return }
        
        var request: URLRequest = URLRequest(url: endpointUrl)
        request.httpMethod = "POST"
        request.httpBody = data
        
        let task: URLSessionTask = URLSession.shared.dataTask(with: request)
        task.resume()
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        // The token is not currently available.
        print("Remote notification support is unavailable due to error: \(error.localizedDescription)")
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
        
    }

}


extension AppDelegate: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, openSettingsFor notification: UNNotification?) {
        guard let navController = window?.rootViewController as? UINavigationController else { return }
        let settingVC: NotificationSettingController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "NotificationSettingController") as! NotificationSettingController
        navController.pushViewController(settingVC, animated: true)
        
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        completionHandler()
    }
    
    
}
