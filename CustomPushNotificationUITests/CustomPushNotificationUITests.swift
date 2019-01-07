//
//  CustomPushNotificationUITests.swift
//  CustomPushNotificationUITests
//
//  Created by kidnapper on 2019/1/7.
//  Copyright © 2019 kidnapper. All rights reserved.
//

import XCTest
import Swifter
import NWPusher

class CustomPushNotificationUITests: XCTestCase {
    
    let mockServer: MockServer = MockServer()
    let app = XCUIApplication()

    override func setUp() {
        super.setUp()
        mockServer.setUp()

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        app.launch()
        allowPushNotificationsIfNeeded()
    }

    override func tearDown() {
        super.tearDown()
        mockServer.tearDown()
    }
    
    // Handle the alertView the system required to confirm
    private func allowPushNotificationsIfNeeded() {
        addUIInterruptionMonitor(withDescription: "Push Notification Monitor") { alertView -> Bool in
            if alertView.buttons["Allow"].exists {
                alertView.buttons["Allow"].tap()
            } else {
                print("Push Notification Authorization had been asked")
            }
            return true
         }
        app.swipeUp()
    }

    func testPush() {
        // Test if the app been opened successfully.
        waitForElementToAppear(object: app.buttons["send local notify"])
        
        // Tap the home button
        XCUIDevice.shared.press(XCUIDevice.Button.home)
        
        // Trigger a push notification
        triggerPushNotification(withPayload: .pushType)
        
        // Tap the notification when it appears
        let springBoard: XCUIApplication = XCUIApplication(bundleIdentifier: "com.apple.springboard")
        let springBoardNotification: XCUIElement = springBoard.otherElements["NotificationShortLookView"]
        waitForElementToAppear(object: springBoardNotification)
        springBoardNotification.tap()
        
        // Test if the app shows the correct view
        waitForElementToAppear(object: app.buttons["send local notify"])
    }
    
    private func waitForElementToAppear(object: Any) {
        let exists: NSPredicate = NSPredicate(format: "exists == true")
        expectation(for: exists, evaluatedWith: object, handler: nil)
        waitForExpectations(timeout: 5, handler: { error in
            if error != nil {
                XCTFail("\(object) not exists")
            }
        })
    }
    
    private func triggerPushNotification(withPayload payload: PushNotificationPayload) {
        let uiTestBundle = Bundle(for: CustomPushNotificationUITests.self)
        guard let url = uiTestBundle.url(forResource: "CustomPushNotification", withExtension: "p12") else {
            XCTFail("Couldn't get push key!")
            return
        }
        
        guard let deviceToken: String = mockServer.pushToken else {
            XCTFail("Couldn't find device token!")
            return
        }
        
        do {
            let data: Data = try Data(contentsOf: url)
            let pusher: NWPusher = try NWPusher.connect(withPKCS12Data: data,
                                                        password: "password",
                                                        environment: .sandbox)
            
            try pusher.pushPayload(payload.apnsPayload,
                                   token: deviceToken,
                                   identifier: UInt(arc4random_uniform(UInt32(999))))
        } catch {
            XCTFail("Error connecting to push server.  Check to see if the push certificate is expired or the password is correct!")
            print(error)
        }
        
    }
    
    

}
