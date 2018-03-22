//
//  MultiTouchViewController.swift
//  sellMyPhone
//
//  Created by Quentin Noblet on 13/03/2018.
//  Copyright © 2018 Quentin Noblet. All rights reserved.
//

import UIKit

class MultiTouchViewController: UIViewController {
  
  // MARK: Properties
  
  @IBOutlet weak var explanationView: ExplanationView!
  @IBOutlet weak var escapeButton: secondaryActionButton!
  @IBOutlet weak var explanationLabel: UILabel!
  @IBOutlet weak var titleLabel: UILabel!
  
  let deviceTest = DeviceTest()
  
  let explanation = "Nous allons d'abord vérifier votre Touch ID, une fois prêt, veuillez commencer le test"
  let escapeButtonTitle = "Échouer à ce test"
  let titleView = "Multi-touch"
  
  
  // MARK: Actions
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    titleLabel.text = titleView
    explanationLabel.text = explanation
    escapeButton.setTitle(escapeButtonTitle, for: .normal)
    
    deviceTest.stateType = .screen
    deviceTest.state = .ongoing
  }
  
  var touchCount = 0
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    for _ in touches {
      touchCount += 1
      if touchCount > 2 && touchCount < 5 {
        didPassTheTest()
      }
    }
  }
  
  override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    for _ in touches {
      touchCount -= 1
    }
  }
  
  @IBAction func didTapEscapeTest(_ sender: Any) {
    didEscapeTheTest()
  }
  
  // MARK: - Test Result Managment
  
  func didPassTheTest() {
    deviceTest.state = .correct
    showPopUpResult(result : true)
  }
  
  func didFailTheTest() {
    deviceTest.state = .incorrect
    showPopUpResult(result : false)
  }
  
  func didEscapeTheTest() {
    deviceTest.state = .incorrect
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
    performSegue(withIdentifier: "nextTest", sender: self)
  }
}

extension MultiTouchViewController: MyProtocol {
  //Implement MyProtocol's function to make FirstViewContoller conform to MyProtocol
  // MARK: MyProtocol functions
  func setDataBack( nextSend: Bool) {
    if nextSend {
      moveToNextTest()
    }
  }
}

