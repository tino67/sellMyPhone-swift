//
//  mainActionButton.swift
//  sellMyPhone
//
//  Created by Quentin Noblet on 12/03/2018.
//  Copyright © 2018 Quentin Noblet. All rights reserved.
//

import UIKit

class mainActionButton: UIButton {
  
  override func awakeFromNib() {
    super.awakeFromNib()
    
    self.layer.borderWidth = 1.0
    self.layer.cornerRadius = C.Ui.cornerRadius
    self.clipsToBounds = true
    self.setStyle(self.style)
    
    if self.isEnabled {
      self.alpha = 1
    } else {
      self.alpha = 0.5
    }
  }
  
  enum Style {
    case standard, alternative, issue
  }
  
  var style: Style = .standard {
    didSet {
      setStyle(style)
    }
  }
  
  private func setStyle(_ style: Style) {
    // UI Specific
    switch style {
    case .standard:
      self.backgroundColor = #colorLiteral(red: 0.9352465272, green: 0.4308905005, blue: 0.2685489058, alpha: 1)
      self.layer.borderColor = C.Ui.callToActionBorderColor
    case .alternative:
      self.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
      self.layer.borderColor = C.Ui.callToAction2BorderColor
    case .issue:
      self.backgroundColor = #colorLiteral(red: 0.721488893, green: 0.7216146588, blue: 0.7214810252, alpha: 1)
      self.layer.borderColor = C.Ui.viewLightBorderColor
    }
  }
  
  override var isEnabled: Bool {
    didSet {
      if self.isEnabled {
        self.alpha = 1
      } else {
        self.alpha = 0.5
      }
    }
  }
}

