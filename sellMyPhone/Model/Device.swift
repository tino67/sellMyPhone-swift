//
//  Device.swift
//  sellMyPhone
//
//  Created by Quentin Noblet on 27/02/2018.
//  Copyright © 2018 Quentin Noblet. All rights reserved.
//

import Foundation
import DeviceKit

extension Device {
  
  public var hasTouchId: Bool {
    
    switch self {
    case .iPhoneX: return false
    case .iPodTouch5: return false
    case .iPodTouch6: return false
    case .iPhone4: return false
    case .iPhone4s: return false
    case .iPhone5: return false
    case .iPhone5c: return false
    case .iPad2: return false
    case .iPad3: return false
    case .iPad4: return false
    case .iPadAir: return false
    case .iPadMini: return false
    case .iPadMini2: return false
    case .simulator( _): return false
    case .unknown: return false
    default: return true
    }
  }
  
  public var memoryCapacity: Int {
    if let capacity = getTotalSizeInGo() {
      switch capacity {
      //4 Go
      case 2...5,9:
        return 4
      //8 Go
      case 6...11:
        return 8
      //16 Go
      case 12...19:
        return 16
      //32 Go
      case 26...36:
        return 32
      //64 Go
      case 58...66:
        return 64
      //128 Go
      case 118...140:
        return 128
      //256 Go
      case 240...270:
        return 256
      //512 Go
      case 490...530:
        return 512
      //1 To
      case 800...1200:
        return 1000
      //1,5 To
      case 1250...1700:
        return 1500
      //2 To
      case 1750...2200:
        return 2000
      //2,5 To
      case 2250...2700:
        return 2500
      //3 To
      case 2750...3200:
        return 3000
      //3,5 To
      case 3250...3700:
        return 3500
      default:
        print("Error Converting to Commercial System Memory Info:")
        return 0
      }
    }
    print("Error Converting to Commercial System Memory Info:")
    return 0
  }
  
  
  // Convert to Go
  private func getTotalSizeInGo() -> Int? {
    
    if let totalSizeInByte = getTotalSize() {
      let totalSizeInGo = Int((Float(totalSizeInByte) / pow(10, 9)).rounded(.awayFromZero))
      return totalSizeInGo
    }
    return nil
  }
  
  
  // Return Total size
  private func getTotalSize() -> Int64?{
    let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
    if let dictionary = try? FileManager.default.attributesOfFileSystem(forPath: paths.last!) {
      if let freeSize = dictionary[FileAttributeKey.systemSize] as? NSNumber {
        return freeSize.int64Value
      }
    }else{
      print("Error Obtaining System Memory Info:")
    }
    return nil
  }
  
  // Return free size available
  private func getFreeSize() -> Int64? {
    let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
    if let dictionary = try? FileManager.default.attributesOfFileSystem(forPath: paths.last!) {
      if let freeSize = dictionary[FileAttributeKey.systemFreeSize] as? NSNumber {
        return freeSize.int64Value
      }
    }else{
      print("Error Obtaining System Memory Info:")
    }
    return nil
  }
}

