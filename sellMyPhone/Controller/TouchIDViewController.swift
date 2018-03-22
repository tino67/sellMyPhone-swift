//
//  TouchIDViewController.swift
//  sellMyPhone
//
//  Created by Quentin Noblet on 12/03/2018.
//  Copyright © 2018 Quentin Noblet. All rights reserved.
//

import UIKit
import LocalAuthentication

class TouchIDViewController: UIViewController {
  
  // MARK: Properties
  
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var explanationView: ExplanationView!
  @IBOutlet weak var startButton: mainActionButton!
  @IBOutlet weak var escapeButton: secondaryActionButton!
  @IBOutlet weak var explanationLabel: UILabel!
  
  let deviceTest = DeviceTest()
  let touchIdReason = "Veuillez valider votre empreinte"
  let explanation = "Nous allons d'abord vérifier votre Touch ID, une fois prêt, veuillez commencer le test"
  let startButtonTitle = "Démarrer le TEST"
  let escapeButtonTitle = "Échouer à ce test"
  let titleView = "Touch ID"
  var nextIdentifier: String?
  
  
  // MARK: Actions
  
  override func viewDidLoad() {
    super.viewDidLoad()
    titleLabel.text = titleView
    explanationLabel.text = explanation
    startButton.setTitle(startButtonTitle, for: .normal)
    escapeButton.setTitle(escapeButtonTitle, for: .normal)
    
    deviceTest.stateType = .functional
    deviceTest.state = .ongoing
  }
  
  @IBAction func didTapStartButton(_ sender: Any) {
    startTest()
  }
  
  private func startTest() {
    // 1. Create a authentication context
    let authenticationContext = LAContext()
    var error:NSError?
    // 2. Check if the device has a fingerprint sensor
    // If not, show the user an alert view and bail out!
    guard authenticationContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) else {
      showAlertViewIfNoBiometricSensorHasBeenDetected()
      return
    }
    
    // 3. Check the fingerprint
    authenticationContext.evaluatePolicy(
      .deviceOwnerAuthenticationWithBiometrics,
      localizedReason: touchIdReason,
      reply: { [unowned self] (success, error) -> Void in
        
        if( success ) {
          // Fingerprint recognized
          DispatchQueue.main.async {
            self.didPassTheTest()
          }
        }else {
          // Check if there is an error
          if let error = error {
            let message = self.errorMessageForLAError(error: error)
            //  self.showAlertViewAfterEvaluatingPolicyWithMessage(message: message)
            print("Error TouchID: \(message)")
          }
        }
    })
  }
  
  func errorMessageForLAError( error: Error) -> String{
    var message = ""
    switch error {
    case LAError.appCancel:
      message = "Authentication was cancelled by application"
      
    case LAError.authenticationFailed:
      message = "The user failed to provide valid credentials"
      
    case LAError.invalidContext:
      message = "The context is invalid"
      
    case LAError.passcodeNotSet:
      message = "Passcode is not set on the device"
      
    case LAError.systemCancel:
      message = "Authentication was cancelled by the system"
      
    case LAError.touchIDLockout:
      message = "Too many failed attempts."
      
    case LAError.touchIDNotAvailable:
      message = "TouchID is not available on the device"
      
    case LAError.userCancel:
      message = "The user did cancel"
      
    case LAError.userFallback:
      message = "The user chose to use the fallback"
      
    default:
      message = "Did not find error code on LAError object"
    }
    return message
  }
  
  func showAlertViewIfNoBiometricSensorHasBeenDetected(){
    presentAlert("Erreur", message: "Cette appareil n'a pas de TouchId ou le nombre de tentative est dépassé. Veuillez réessayer plus tard")
  }
  
  func showAlertViewAfterEvaluatingPolicyWithMessage(message: String) {
    presentAlert("Error", message: message)
  }
  
  @IBAction func didTapEscapeTest(_ sender: secondaryActionButton) {
    didEscapeTheTest()
  }
  
  
  // MARK: - Test Result Managment
  
  func didPassTheTest() {
    deviceTest.state = .correct
    nextIdentifier = "nextTest"
    showPopUpResult(result : true)
  }
  
  func didFailTheTest() {
    deviceTest.state = .incorrect
    nextIdentifier = "toPriceResultViewSegue"
    showPopUpResult(result : false)
  }
  
  func didEscapeTheTest() {
    deviceTest.state = .incorrect
    nextIdentifier = "toPriceResultViewSegue"
    showPopUpResult(result : false)
  }
  
  func showPopUpResult (result: Bool) {
    let popOverVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TestResultViewController") as! TestResultViewController
    
    // Transfert Data
    popOverVC.testResult = result
    popOverVC.myProtocol = self
    
    // Show View
    self.addChildViewController(popOverVC)
    popOverVC.view.frame = self.view.frame
    self.view.addSubview(popOverVC.view)
    popOverVC.didMove(toParentViewController: self)
  }
  
  
  // MARK: - Navigation
  func moveToNextTest() {
    if nextIdentifier != nil {
      performSegue(withIdentifier: nextIdentifier!, sender: self)
    }
  }
}


extension TouchIDViewController: MyProtocol {
  //Implement MyProtocol's function to make FirstViewContoller conform to MyProtocol
  // MARK: MyProtocol functions
  func setDataBack( nextSend: Bool) {
    if nextSend {
      moveToNextTest()
    }
  }
}
