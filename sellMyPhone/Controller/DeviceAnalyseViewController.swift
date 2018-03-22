//
//  DeviceAnalyseViewController.swift
//  sellMyPhone
//
//  Created by Quentin Noblet on 28/02/2018.
//  Copyright © 2018 Quentin Noblet. All rights reserved.
//

import UIKit
import DeviceKit

class DeviceAnalyseViewController: UIViewController {

  // MARK: Properties
  
  @IBOutlet weak var loadingView: LoadingView!
  @IBOutlet weak var errorMessageLabel: UILabel!
  @IBOutlet weak var retryButton: UIButton!
  
  var retryButtonLabel = "Réessayer"
  var errorMessage = "Oups.. Il y a un problème, veuillez vérifier que vous êtes bien connecté au réseau"
  
  var deviceDetected = false
  var deviceList: [Int: String] = [:]
  
  
  // MARK: Actions
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    retryButton.setTitle(retryButtonLabel, for: .normal)
    errorMessageLabel.text = errorMessage
  }
  
  override func viewDidAppear(_ animated: Bool) {
    deviceAnalyse()
    let myDeviceState = DeviceState.shared
    myDeviceState.restartState()
  }
  
  private func deviceAnalyse () {
    
    
    
    //I havent let the access to the API in demo Mode in github
    //
    //
    sleep(2)
    let deviceId = 269
    let device = Device()
    let deviceName = device.model
    UserDefaults.standard.set(deviceId, forKey: "deviceId")
    UserDefaults.standard.set(deviceName, forKey: "deviceName")
    self.deviceDetected = true
    self.moveToNextTest()
    
    
    
//    DeviceListeManager.shared.getDeviceList { (deviceList) in
//      switch deviceList.count {
//      case 1:
//        let deviceId = deviceList.first?.key
//        let deviceName = deviceList.first?.value
//        UserDefaults.standard.set(deviceId, forKey: "deviceId")
//        UserDefaults.standard.set(deviceName, forKey: "deviceName")
//
//        self.deviceDetected = true
//        self.moveToNextTest()
//      case 0:
//        let device = Device()
//        DispatchQueue.main.async(execute: {
//          self.loadingView.isHidden = true
//        })
//        guard device.isPhone || device.isPad else {
//          self.noDeviceFound()
//          return
//        }
//      // case of several answer
//      default:
//        self.severalDeviceFound(list: deviceList)
//      }
//    }
  }
  
  private func noDeviceFound() {
    let alertController = UIAlertController(title: "Désolé...", message: "Il semblerait que nous ne reprenions pas encore ce type d'appareil. Rendez-vous sur notre site web pour plus d'information", preferredStyle: .alert)
    let defaultAction = UIAlertAction(title: "OK", style: .default, handler: { (alert) in
    })
    alertController.addAction(defaultAction)
    present(alertController, animated: true, completion: nil)
  }

  @IBAction func didTapRestart(_ sender: Any) {
    loadingView.isHidden = false
    deviceAnalyse()
  }
  
  private func severalDeviceFound(list: [Int: String]) {
    deviceList = list
    moveToDeviceList()
  }
  
  private func moveToNextTest() {
    let device = Device()
    if device.hasTouchId {
      DispatchQueue.main.async(execute: {
        self.performSegue(withIdentifier: "touchIDSegue", sender: nil)
      })
    } else {
      DispatchQueue.main.async(execute: {
        self.performSegue(withIdentifier: "noTouchIDSegue", sender: nil)
      })
    }
  }
  
  private func moveToDeviceList() {
    DispatchQueue.main.async(execute: {
      self.performSegue(withIdentifier: "deviceListSegue", sender: nil)
    })
  }
  
  private func prepareDeviceList(listOflist: [[Int: String]]) -> [(deviceId: Int, deviceName: String)]{
    var deviceList: [(deviceId: Int, deviceName: String)] = []
    for dictionary in listOflist {
      for (key,value) in dictionary {
        deviceList.append((deviceId: key, deviceName: value))
      }
    }
    return deviceList
  }
  
  
  // MARK: - Navigation
  
  // Unwind Action
  @IBAction func unwindToFirstViewController (sender: UIStoryboardSegue){
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "deviceListSegue" {
      let displayViewController = segue.destination as! DeviceListViewController
      var deviceListToSend = prepareDeviceList(listOflist: [deviceList])
      deviceListToSend.sort(by: {$0.deviceName > $1.deviceName})
      displayViewController.deviceList = deviceListToSend
    }
  }
}
