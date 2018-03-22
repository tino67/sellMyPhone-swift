//
//  TestResultView.swift
//  sellMyPhone
//
//  Created by Quentin Noblet on 27/02/2018.
//  Copyright © 2018 Quentin Noblet. All rights reserved.
//

import UIKit

class TestResultView: UIView {
  @IBOutlet private var label: UILabel!
  @IBOutlet private var icon: UIImageView!
  
  var title = "" {
    didSet {
      label.text = title
    }
  }
  
  enum Style {
    case correct, incorrect, ongoing
  }
  
  var style: Style = .ongoing {
    didSet {
      setStyle(style)
    }
  }
  
  private func setStyle(_ style: Style) {
    // UI Generic
    self.layer.borderWidth = 2.0
    self.layer.borderColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
    self.layer.cornerRadius = C.Ui.cornerRadius
    self.clipsToBounds = true
    
    // UI Specific
    switch style {
    case .correct:
      title = "TEST REUSSI"
      backgroundColor =  #colorLiteral(red: 0, green: 0.7254901961, blue: 0.5529411765, alpha: 1) // Vert
      icon.image = #imageLiteral(resourceName: "TestValidate")
      icon.isHidden = false
      self.isHidden = false
    case .incorrect:
      title = "ÉCHEC"
      backgroundColor = #colorLiteral(red: 1, green: 0.3300932944, blue: 0.2421161532, alpha: 1) // Rouge
      icon.image = #imageLiteral(resourceName: "TestFail")
      icon.isHidden = false
      self.isHidden = false
    case .ongoing:
      backgroundColor = UIColor(red: 191.0/255.0, green: 196.0/255.0, blue: 201.0/255.0, alpha: 1) // Gris
      self.isHidden = true
    }
  }
}

