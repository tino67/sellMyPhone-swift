//
//  DeviceListViewController.swift
//  sellMyPhone
//
//  Created by Quentin Noblet on 12/03/2018.
//  Copyright © 2018 Quentin Noblet. All rights reserved.
//

import UIKit
import DeviceKit

class DeviceListViewController: UIViewController {
  
  // MARK: Properties
  
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var deviceListTableView: UITableView!
  
  var titleView = "Sélection de l'appareil"
  var deviceList: [(deviceId: Int, deviceName: String)] = []
  
  
  // MARK: Actions
  
  override func viewDidLoad() {
    super.viewDidLoad()
    titleLabel.text = titleView
  }
  
  func moveToNextTest() {
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
}


//MARK: - TableView

extension DeviceListViewController: UITableViewDelegate, UITableViewDataSource {
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return deviceList.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let myCell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! DeviceTableViewCell
    
    myCell.textLabel?.text = deviceList[indexPath.row].deviceName
    
    return myCell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let deviceId = deviceList[indexPath.row].deviceId
    let deviceName = deviceList[indexPath.row].deviceName
    
    UserDefaults.standard.set(deviceId, forKey: "deviceId")
    UserDefaults.standard.set(deviceName, forKey: "deviceName")
    
    moveToNextTest()
  }
}
