//
//  PushNotificationPayload.swift
//  CustomPushNotificationUITests
//
//  Created by kidnapper on 2019/1/7.
//  Copyright © 2019 kidnapper. All rights reserved.
//

import Foundation

enum PushNotificationPayload: String {
    
    // rawValue of case below will appeared in push notification
    case pushType = "This is one type of push notification"
    
    var apnsPayload: String {
        return "{\"aps\":{\"alert\":\"" + self.rawValue + "\", \"badge\":1}}"
    }
}
