//
//  LoadingView.swift
//  sellMyPhone
//
//  Created by Quentin Noblet on 28/02/2018.
//  Copyright © 2018 Quentin Noblet. All rights reserved.
//

import UIKit

class LoadingView: UIView {
  @IBOutlet private var label: UILabel!
  @IBOutlet private var loader: UIActivityIndicatorView! {
    didSet {
        loader.startAnimating()
    }
  }
  
  var info = "Nous analysons votre appareil, vérifiez que vous êtes bien connecté au réseau" {
    didSet {
      label.text = info
    }
  }
}
