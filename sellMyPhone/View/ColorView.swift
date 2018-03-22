//
//  colorView.swift
//  sellMyPhone
//
//  Created by Quentin Noblet on 13/03/2018.
//  Copyright © 2018 Quentin Noblet. All rights reserved.
//

import UIKit

class ColorView: UIView {
  
  override init(frame: CGRect) {
    super.init(frame: CGRect(x: 0.0, y: 0.0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height))
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  enum Style {
    case hidden, red, green, blue, white, black
  }
  
  var style: Style = .hidden {
    didSet {
      setStyle(style)
    }
  }
  
  private func setStyle(_ style: Style) {
    // UI Specific
    switch style {
    case .hidden:
      self.isHidden = true
    case .green:
      backgroundColor = #colorLiteral(red: 0, green: 0.7254901961, blue: 0.5529411765, alpha: 1) // green
      self.isHidden = false
    case .red:
      backgroundColor = #colorLiteral(red: 1, green: 0.3300932944, blue: 0.2421161532, alpha: 1) // red
      self.isHidden = false
    case .blue:
      backgroundColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1) // blue
      self.isHidden = false
    case .white:
      backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1) // white
      self.isHidden = false
    case .black:
      backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1) // black
      self.isHidden = false
    }
  }
}

