//
//  DeviceListManager.swift
//  sellMyPhone
//
//  Created by Quentin Noblet on 06/03/2018.
//  Copyright © 2018 Quentin Noblet. All rights reserved.
//

import Foundation
import DeviceKit

class DeviceListeManager {
  
  static let shared = DeviceListeManager()
  private init() {}
  
  
  func getDeviceList(completionHandler: @escaping ([Int:String]) -> ()) {
    // Device Name
    let device = Device()
    let deviceName = String(describing: device)
    
    // Get device memory
    var deviceCapacity = ""
    if device.memoryCapacity != 0 {
      deviceCapacity = String(device.memoryCapacity) + "Go"
    }
    
    let deviceFullName = "\(deviceName) \(deviceCapacity)"
    
    API.shared.fetchDevicesInfo(deviceName: deviceFullName) { (devicesId) in
      
      if devicesId.count == 0 {
        // no device found
        self.deviceNotFound(completionHandler: { (deviceList) in
          completionHandler(deviceList)
        })
      } else {
        completionHandler(devicesId)
      }
    }
  }
  
  
  private func deviceNotFound(completionHandler: @escaping ([Int:String]) -> ()) {
    
    // Device Name
    let device = Device()
    
    if device.isPad {
      API.shared.fetchDevicesInfo(deviceName: "iPad") { (deviceList) in
        completionHandler(deviceList)
      }
    } else if device.isPhone {
      API.shared.fetchDevicesInfo(deviceName: "iPhone") { (deviceList) in
        completionHandler(deviceList)
      }
    } else if device.isPod {
      completionHandler([:])
    } else {
      API.shared.fetchDevicesInfo(deviceName: "iPad") { (deviceList) in
        var allDevices = deviceList
        API.shared.fetchDevicesInfo(deviceName: "iPhone") { (deviceList) in
          allDevices.merge(deviceList, uniquingKeysWith: { (current, _) -> String in
            current })
          completionHandler(allDevices)
        }
      }
    }
  }
}

