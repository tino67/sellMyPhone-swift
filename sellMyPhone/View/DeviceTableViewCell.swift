//
//  DeviceTableViewCell.swift
//  sellMyPhone
//
//  Created by Quentin Noblet on 12/03/2018.
//  Copyright © 2018 Quentin Noblet. All rights reserved.
//

import UIKit

class DeviceTableViewCell: UITableViewCell {
  
  override func awakeFromNib() {
    super.awakeFromNib()
    self.backgroundColor = .clear
    self.textLabel?.textColor = C.Ui.bodyClearColor
    
    //change backgroundColor of selected Cell
    let backgroundColorView = UIView.init()
    backgroundColorView.backgroundColor = C.Ui.selectedCellBackgroundColor
    self.selectedBackgroundView = backgroundColorView
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
  }
}

