//
//  DeviceTest.swift
//  sellMyPhone
//
//  Created by Quentin Noblet on 28/02/2018.
//  Copyright © 2018 Quentin Noblet. All rights reserved.
//

import Foundation


import Foundation

class DeviceTest {
  
  var state: State = .ongoing {
    didSet {
      updateDeviceState()
      //sendTestResult(with: state)
    }
  }
  
  enum State {
    case ongoing, correct, incorrect
  }
  
  var stateType: StateType = .unknow
  
  enum StateType {
    case unknow, functional, screen, general, simlockage, operators
  }
  
  private func updateDeviceState() {
    let myDeviceSate = DeviceState.shared
    myDeviceSate.updateForFail(deviceTest: self)
  }
  
  private func sendTestResult(with state: State) {
    switch state {
    case .correct:
      let name = Notification.Name(rawValue: "TestCorrect")
      let notification = Notification(name: name)
      NotificationCenter.default.post(notification)
    case .incorrect:
      let name = Notification.Name(rawValue: "TestIncorret")
      let notification = Notification(name: name)
      NotificationCenter.default.post(notification)
    case .ongoing:
      let name = Notification.Name(rawValue: "TestOngoing")
      let notification = Notification(name: name)
      NotificationCenter.default.post(notification)
    }
  }
}
