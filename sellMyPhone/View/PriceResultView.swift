//
//  PriceResultView.swift
//  sellMyPhone
//
//  Created by Quentin Noblet on 19/03/2018.
//  Copyright © 2018 Quentin Noblet. All rights reserved.
//

import UIKit

class PriceResultView: UIView {
  
  @IBOutlet private var label: UILabel!
  @IBOutlet private var priceLabel: UILabel!
  @IBOutlet private var secondaryPriceLabel: UILabel!
  @IBOutlet private var retryButton: UIButton!
  @IBOutlet private var loader: UIActivityIndicatorView! {
    didSet {
      loader.startAnimating()
    }
  }
  
  var info = "Recherche du meilleur prix" {
    didSet {
      label.text = info
    }
  }
  
  var phonePrice = 0.0 {
    didSet {
      priceLabel.text = String(phonePrice.clean) + "€"
    }
  }
  
  var secondaryPriceInfo = "TTC" {
    didSet {
      secondaryPriceLabel.text = secondaryPriceInfo
    }
  }
  
  enum Style {
    case ongoing, priceFound, noPriceFound
  }
  
  var style: Style = .ongoing {
    didSet {
      setStyle(style)
    }
  }
  
  private func setStyle(_ style: Style) {
    // UI Generic
    // self.layer.borderWidth = 2.0
    // self.layer.borderColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
    self.layer.cornerRadius = C.Ui.cornerRadius
    self.clipsToBounds = true
    retryButton.layer.borderWidth = 1.0
    retryButton.layer.borderColor = C.Ui.callToAction2BorderColor
    retryButton.layer.cornerRadius = C.Ui.cornerRadius
    retryButton.clipsToBounds = true
    
    // UI Specific
    switch style {
    case .priceFound:
      priceLabel.isHidden = false
      secondaryPriceLabel.isHidden = false
      loader.isHidden = true
      label.isHidden = true
      retryButton.isHidden = true
    case .noPriceFound:
      priceLabel.isHidden = true
      secondaryPriceLabel.isHidden = true
      loader.isHidden = true
      info = "Oups, il y a un problème de connexion"
      label.isHidden = false
      retryButton.isHidden = false
    case .ongoing:
      priceLabel.isHidden = true
      secondaryPriceLabel.isHidden = true
      loader.isHidden = false
      info = "Recherche du meilleur prix"
      label.isHidden = false
      retryButton.isHidden = true
    }
  }
}

