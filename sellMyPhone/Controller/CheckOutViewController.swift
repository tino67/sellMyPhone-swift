//
//  CheckOutViewController.swift
//  sellMyPhone
//
//  Created by Quentin Noblet on 20/03/2018.
//  Copyright © 2018 Quentin Noblet. All rights reserved.
//

import UIKit
import WebKit

class CheckOutViewController: UIViewController, WKUIDelegate{
  
  // MARK: Properties
  
  @IBOutlet weak var webViewFrame: UIView!
  @IBOutlet weak var navigationBar: UINavigationBar!
  var webView: WKWebView!
  
  
  // MARK: Actions
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let webConfiguration = WKWebViewConfiguration()
    webView = WKWebView(frame: webViewFrame.frame, configuration: webConfiguration)
    webView.uiDelegate = self
    view.addSubview(webView)
    
    loadWebView()
  }
  
  func loadWebView() {
    // Do any additional setup after loading the view.
    let myDeviceState = DeviceState.shared
    
    if let deviceIdDefault = UserDefaults.standard.string(forKey: "deviceId"), let deviceId = Int(deviceIdDefault) {
      
      API.shared.preparCheckOutRequest(deviceId: deviceId, deviceState: myDeviceState, completion: { (data) in
        var request = URLRequest(url: URL(string: data["url"]!)!)
        let postString = data["post"]!
        request.httpMethod = "POST"
        
        request.httpBody = postString.data(using: String.Encoding.utf8)
        self.webView.load(request)
      })
    }
  }
  
  func issueOnWebview() {
    presentAlert("Désolé...", message: "il y a un problème, veuillez réessayer plus tard ou passer directement via le site web")
  }
  
  @IBAction func didTapPrevious(_ sender: Any) {
    if webView.canGoBack {
      webView.goBack()
    } else {
      performSegue(withIdentifier: "toPriceViewUnwind", sender: self)
    }
  }
  
  @IBAction func didTapClose(_ sender: Any) {
    performSegue(withIdentifier: "toPriceViewUnwind", sender: self)
  }
}

