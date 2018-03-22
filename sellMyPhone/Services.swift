//
//  Services.swift
//  sellMyPhone
//
//  Created by Quentin Noblet on 13/03/2018.
//  Copyright © 2018 Quentin Noblet. All rights reserved.
//

import UIKit


//Protocol to send Data Backward
protocol MyProtocol {
  func setDataBack( nextSend: Bool)
}


extension UIViewController {
  // Alert function with
  // Parameters: title  and message as String
  public func presentAlert(_ title:String, message:String) {
    let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
    let OKAction = UIAlertAction(title: "OK", style: .default) {
      (action) in
    }
    alertController.addAction(OKAction)
    self.present(alertController, animated: true, completion: nil)
  }
}


extension UIColor {
  
  // UIColor propertie in RGB
  convenience init(red: Int, green: Int, blue: Int) {
    assert(red >= 0 && red <= 255, "Invalid red component")
    assert(green >= 0 && green <= 255, "Invalid green component")
    assert(blue >= 0 && blue <= 255, "Invalid blue component")
    
    self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
  }
  
  // UIColor properties in Hexa
  convenience init(netHex:Int) {
    self.init(red:(netHex >> 16) & 0xff, green:(netHex >> 8) & 0xff, blue:netHex & 0xff)
  }
}


// Clean the decimal if equal to 0
extension Double {
  var clean: String {
    return self.truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.0f", self) : String(self)
  }
}


// Segue following VC from right
class SegueFromRight: UIStoryboardSegue {
  
  override func perform() {
    let src = self.source
    let dst = self.destination
    
    src.view.superview?.insertSubview(dst.view, aboveSubview: src.view)
    dst.view.transform = CGAffineTransform(translationX: src.view.frame.size.width, y: 0)
    
    UIView.animate(withDuration: 0.25,
                   delay: 0.0,
                   options: UIViewAnimationOptions.curveEaseInOut,
                   animations: {
                    dst.view.transform = CGAffineTransform(translationX: 0, y: 0)
    },
                   completion: { finished in
                    src.present(dst, animated: false, completion: nil)
    })
  }
}


// Segue unwind previous VC from right
class UIStoryboardUnwindSegueFromRight: UIStoryboardSegue {
  
  override func perform() {
    let src = self.source as UIViewController
    let dst = self.destination as UIViewController
    
    src.view.superview?.insertSubview(dst.view, belowSubview: src.view)
    src.view.transform = CGAffineTransform(translationX: 0, y: 0)
    
    UIView.animate(withDuration: 0.25,
                   delay: 0.0,
                   options: UIViewAnimationOptions.curveEaseInOut,
                   animations: {
                    src.view.transform = CGAffineTransform(translationX: src.view.frame.size.width, y: 0)
    },
                   completion: { finished in
                    src.dismiss(animated: false, completion: nil)
    })
  }
}

