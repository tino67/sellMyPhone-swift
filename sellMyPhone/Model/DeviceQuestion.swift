//
//  DeviceQuestion.swift
//  sellMyPhone
//
//  Created by Quentin Noblet on 15/03/2018.
//  Copyright © 2018 Quentin Noblet. All rights reserved.
//

import Foundation


struct DeviceQuestion {
  
  var title = ""
  var answers: [String] = []
  var answersInfo: [String] = []
  var userAnswer: Int?
  var stateType: DeviceTest.StateType = .unknow
}
