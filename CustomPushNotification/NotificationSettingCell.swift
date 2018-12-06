//
//  NotificationSettingCell.swift
//  CustomPushNotification
//
//  Created by kidnapper on 2018/11/25.
//  Copyright © 2018 kidnapper. All rights reserved.
//

import UIKit

class NotificationSettingCell: UITableViewCell {
    
    @IBOutlet weak var settingLabel: UILabel!
    @IBOutlet weak var settingSwitch: UISwitch!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
