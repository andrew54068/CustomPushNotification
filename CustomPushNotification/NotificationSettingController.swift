//
//  NotificationSettingController.swift
//  CustomPushNotification
//
//  Created by kidnapper on 2018/11/25.
//  Copyright © 2018 kidnapper. All rights reserved.
//

import UIKit

class NotificationSettingController: UITableViewController {
    
    private let labelTexts: [String] = ["公告推播", "最新消息", "優惠通知", "成交通知"]

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 4
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "settingCell", for: indexPath) as! NotificationSettingCell
        cell.settingLabel.text = labelTexts[indexPath.row]
        return cell
    }
    
}
