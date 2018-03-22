//
//  PriceResultViewController.swift
//  sellMyPhone
//
//  Created by Quentin Noblet on 19/03/2018.
//  Copyright © 2018 Quentin Noblet. All rights reserved.
//

import UIKit

class PriceResultViewController: UIViewController {
  
  // MARK: Properties
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var phoneNameLabel: UILabel!
  @IBOutlet weak var startButton: mainActionButton!
  @IBOutlet weak var escapeButton: secondaryActionButton!
  @IBOutlet weak var explanationText: UITextView!
  @IBOutlet weak var priceView: PriceResultView!
  
  
  // MARK: Actions
  override func viewDidLoad() {
    super.viewDidLoad()
    
    startButton.style = .alternative
    priceView.style = .ongoing
    startButton.isEnabled = false
    preparePriceForState()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    let screenSize: CGRect = UIScreen.main.bounds
    let screenHeight = screenSize.height
    
    if screenHeight < 550.0 {
      explanationText.isHidden = true
    }
  }
  
  func preparePriceForState() {
    if let deviceNameDefault = UserDefaults.standard.string(forKey: "deviceName"), let deviceIdDefault = UserDefaults.standard.string(forKey: "deviceId"), let deviceId = Int(deviceIdDefault) {
      phoneNameLabel.text = deviceNameDefault
      let myDeviceSate = DeviceState.shared
      priceForState(deviceId: deviceId, deviceState : myDeviceSate)
    } else {
      manageNoPriceReturn()
    }
  }
  
  @IBAction func didTapSale(_ sender: Any) {
    DispatchQueue.main.async(execute: {
      self.performSegue(withIdentifier: "toCheckOut", sender: self)
    })
  }
  
  @IBAction func didTapRetryAllTest(_ sender: Any) {
    restartAllTest()
  }
  
  @IBAction func didTapRetryPriceForState(_ sender: Any) {
    preparePriceForState()
  }
  
  func restartAllTest() {
    DispatchQueue.main.async(execute: {
      self.performSegue(withIdentifier: "toFirstViewUnwind", sender: self)
    })
  }
  
  func priceForState(deviceId: Int, deviceState: DeviceState){
    API.shared.priceForState(deviceId: deviceId, deviceState: deviceState, completion: { (price) in
      guard price >= 0 else {
        print("Error: No price return")
        // Manage price request fail
        self.manageNoPriceReturn()
        return
      }
      self.updatePriceUI(price: price)
    })
  }
  
  func manageNoPriceReturn() {
    DispatchQueue.main.async {
      self.priceView.style = .noPriceFound
      self.startButton.isEnabled = false
    }
  }
  
  func updatePriceUI(price: Double) {
    DispatchQueue.main.async {
      // Update UI
      self.priceView.phonePrice = price
      self.priceView.style = .priceFound
      self.startButton.isEnabled = true
    }
  }
  
  
  // MARK: - Navigation
  // Unwind Action
  @IBAction func unwindToPriceViewController (sender: UIStoryboardSegue){
  }
  // SegueBack transition
  override func segueForUnwinding(to toViewController: UIViewController, from fromViewController: UIViewController, identifier: String?) -> UIStoryboardSegue {
    
    if let id = identifier {
      if id == "toPriceViewUnwind" {
        let unwindSegue = UIStoryboardUnwindSegueFromRight(identifier: id, source: fromViewController, destination: toViewController)
        return unwindSegue
      }
    }
    return super.segueForUnwinding(to: toViewController, from:  fromViewController, identifier: identifier)!
  }
}

