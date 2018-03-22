//
//  APIManager.swift
//  sellMyPhone
//
//  Created by Quentin Noblet on 27/02/2018.
//  Copyright © 2018 Quentin Noblet. All rights reserved.
//

import Foundation

// API Usage
class API {
  
  private let buyWebServiceUrl = "..."
  private let productsWebServiceUrl = "..."
  private let checkoutWebServiceUrl = "..."
  private let apiKey = "..."
  private let utmSource = "..."
  private let source = "..."
  
  static let shared = API()
  private init() {}
  
  private func nameToNameUrl (name: String) -> String {
    //Get HTML file if possible
    var nameUrl = name.replacingOccurrences(of: " ", with: "-")
    nameUrl = nameUrl.lowercased()
    return nameUrl
  }
  
  func priceForState (deviceId: Int, deviceState: DeviceState, completion: @escaping (Double) -> ()) {
    
    let apiCallPriceForStateUrl = buyWebServiceUrl + "?apikey=" + apiKey + "&utm_source=" + utmSource
    let productIdParam = "&produit_id=" + String(deviceId)
    let stateScreenParam = "&state_screen=" + deviceState.stateScreen.stateId
    let stateGeneralParam = "&state_general=" + deviceState.stateGeneral.stateId
    let functionalParam = "&functional=" + deviceState.stateFunctional.stateId
    var simlockageParam = "&simlockage="
    
    if deviceState.stateSimlockage == .unlock {
      simlockageParam += deviceState.stateSimlockage.stateId
    } else {
      simlockageParam += deviceState.stateOperator.stateId
    }
    
    let apiCall = apiCallPriceForStateUrl + productIdParam + stateScreenParam + stateGeneralParam + functionalParam + simlockageParam
    
    guard let apiCallUrl = URL(string: apiCall) else {
      print("Error: \(apiCall) doesn't seem to be a valid URL")
      completion(-1)
      return
    }
    let task = URLSession.shared.dataTask(with: apiCallUrl) {(data,response, error) -> Void in
      
      if let urlContent = data {
        do{
          let jsonWithObjectRoot = try JSONSerialization.jsonObject(with: urlContent, options: JSONSerialization.ReadingOptions.mutableContainers)
          
          if let dictionary = jsonWithObjectRoot as? [String: Any] {
            
            for (key, value) in dictionary {
              if key == "price", let price = value as? Double {
                completion(price)
              }
            }
          } else {
            completion(-1)
          }
        } catch let error {
          print("Error: \(error)")
          completion(-1)
          
        }
      } else {
        completion(-1)
      }
    }
    
    task.resume()
  }
  
  func fetchDevicesInfo ( deviceName: String, completion: @escaping ([Int:String]) -> ()) {
    
    var productsId: [Int: String] = [:]
    
    if deviceName != "" {
      
      // From Marketing Name to urlName (lowercase and no space)
      let deviceNameUrl = nameToNameUrl(name: deviceName)
      let apiCallProductsInfoUrl = productsWebServiceUrl + "?apikey=" + apiKey + "&utm_source=" + utmSource
      let researchParam: String = "&slug=" + deviceNameUrl
      let apiCall = apiCallProductsInfoUrl + researchParam
      
      guard let apiCallUrl = URL(string: apiCall) else {
        print("Error: \(apiCall) doesn't seem to be a valid URL")
        completion(productsId)
        return
      }
      let task = URLSession.shared.dataTask(with: apiCallUrl) {(data,response, error) -> Void in
        
        if let urlContent = data {
          do{
            let jsonWithObjectRoot = try JSONSerialization.jsonObject(with: urlContent, options: JSONSerialization.ReadingOptions.mutableContainers)
            
            if let dictionary = jsonWithObjectRoot as? [String: Any] {
              
              for (key, value) in dictionary {
                
                if key == "results", let array = value as? [[String: Any]] {
                  
                  for device in array {
                    
                    var productId: Int? = nil
                    var name: String? = nil
                    
                    for (key,value) in device {
                      
                      if key == "name" {
                        name = value as? String
                      }
                      if key == "product_id" {
                        productId = value as? Int
                      }
                    }
                    if productId != nil, name != nil {
                      productsId[productId!] = name
                    }
                  }
                  completion(productsId)
                }
              }
            } else {
              completion(productsId)
            }
          } catch let error {
            print("Error: \(error)")
            completion(productsId)
            
          }
        } else {
          completion(productsId)
        }
      }
      
      task.resume()
      
    } else {
      print("Error: deviceName is empty")
      completion(productsId)
    }
  }
  
  func preparCheckOutRequest(deviceId: Int,deviceState: DeviceState, completion: @escaping ([String:String]) -> ()) {
    
    let apiCallCheckoutUrl = checkoutWebServiceUrl + "?apikey=" + apiKey + "&source=" + source
    
    let productIdParam = "produit_id=" + String(deviceId)
    let catalogueKeyParam = "&catalogue_key=fr"
    let functionalParam = "&etat_mobile=" + deviceState.stateFunctional.stateId
    let stateScreenParam = "&etat_ecran=" + deviceState.stateScreen.stateId
    let stateGeneralParam = "&etat_general=" + deviceState.stateGeneral.stateId
    let stateSimlockageParam = "&etat_simlock=" + deviceState.stateSimlockage.stateId
    
    var postString = productIdParam + catalogueKeyParam + functionalParam + stateScreenParam + stateGeneralParam + stateSimlockageParam
    
    if deviceState.stateSimlockage == .lock {
      let simlockageParam = "&operateur=" + deviceState.stateOperator.stateId
      postString += simlockageParam
    }
    let data = ["url": apiCallCheckoutUrl, "post": postString]
    completion(data)
  }
}

