//
//  secondaryActionButton.swift
//  sellMyPhone
//
//  Created by Quentin Noblet on 06/03/2018.
//  Copyright © 2018 Quentin Noblet. All rights reserved.
//

import UIKit

class secondaryActionButton: UIButton {
  
  override func awakeFromNib() {
    super.awakeFromNib()
    self.layer.borderWidth = 1.0
    self.layer.borderColor = C.Ui.escapeButtonBorderColor
    self.layer.cornerRadius = C.Ui.cornerRadius
    self.clipsToBounds = true
  }
}
