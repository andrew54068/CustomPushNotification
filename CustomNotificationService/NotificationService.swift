//
//  NotificationService.swift
//  CustomNotificationService
//
//  Created by kidnapper on 2018/12/5.
//  Copyright © 2018 kidnapper. All rights reserved.
//

import UserNotifications

class NotificationService: UNNotificationServiceExtension {

    var contentHandler: ((UNNotificationContent) -> Void)?
    var bestAttemptContent: UNMutableNotificationContent?

    override func didReceive(_ request: UNNotificationRequest, withContentHandler contentHandler: @escaping (UNNotificationContent) -> Void) {
        guard let payload: [String: AnyObject] = request.content.userInfo as? [String: AnyObject] else { return }
        
        self.contentHandler = contentHandler
        bestAttemptContent = (request.content.mutableCopy() as? UNMutableNotificationContent)
        
        // reference: https://medium.com/@zhgchgli/ios-10-notification-service-extension-%E6%87%89%E7%94%A8-swift-cb6eba52a342
        if let bestAttemptContent = bestAttemptContent {
            
            guard let imageURLString = payload["url"] as? String, let imageURL = URL(string: imageURLString) else {
                contentHandler(bestAttemptContent)
                return
                //若無附圖片，則不用特別處理
            }
            // Modify the notification content here...
            bestAttemptContent.title = "\(bestAttemptContent.title) [modified]"
            bestAttemptContent.subtitle = "@@"
            
            let dataTask = URLSession.shared.dataTask(with: imageURL) { (data, response, error) in
                guard let fileURL = NSURL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(imageURL.lastPathComponent) else {
                    contentHandler(bestAttemptContent)
                    return
                }
                guard (try? data?.write(to: fileURL)) != nil else {
                    contentHandler(bestAttemptContent)
                    return
                }
                
                guard let attachment = try? UNNotificationAttachment(identifier: "image", url: fileURL, options: nil) else {
                    contentHandler(bestAttemptContent)
                    return
                }
                //以上為讀取圖片連結並下載到手機並放入建立UNNotificationAttachment
                
                bestAttemptContent.categoryIdentifier = "categoryIdentifier"
                bestAttemptContent.attachments = [attachment]
                //為推播添加附件圖片
                
                bestAttemptContent.body = (bestAttemptContent.body == "") ? ("立即查看") : (bestAttemptContent.body)
                //如果body為空，則用預設內容"立即查看"
                contentHandler(bestAttemptContent)
            }
            
            DispatchQueue.global().asyncAfter(deadline: .now() + 15) {
                dataTask.resume()
            }
            
        }
        
    }
    
    override func serviceExtensionTimeWillExpire() {
        // Called just before the extension will be terminated by the system.
        // Use this as an opportunity to deliver your "best attempt" at modified content, otherwise the original push payload will be used.
        if let contentHandler = contentHandler, let bestAttemptContent =  bestAttemptContent {
            contentHandler(bestAttemptContent)
        }
    }

}
