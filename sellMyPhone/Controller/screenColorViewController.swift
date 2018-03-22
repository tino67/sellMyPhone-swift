//
//  screenColorViewController.swift
//  sellMyPhone
//
//  Created by Quentin Noblet on 13/03/2018.
//  Copyright © 2018 Quentin Noblet. All rights reserved.
//

import UIKit

class screenColorViewController: UIViewController {
  
  // MARK: Properties
  
  @IBOutlet weak var resultView: ExplanationView!
  @IBOutlet weak var explanationView: ExplanationView!
  @IBOutlet weak var explanationLabel: UILabel!
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var titleExplanationLabel: UILabel!
  @IBOutlet weak var explanationImage: UIImageView!
  @IBOutlet weak var escapeButton: secondaryActionButton!
  @IBOutlet weak var startButton: mainActionButton!
  
  @IBOutlet weak var titleResultLabel: UILabel!
  @IBOutlet weak var question1ResultLabel: UILabel!
  @IBOutlet weak var question2ResultLabel: UILabel!
  @IBOutlet weak var okResultButton: mainActionButton!
  @IBOutlet weak var failResultButton: mainActionButton!
  @IBOutlet weak var detailResultLabel: UILabel!
  @IBOutlet weak var illustrationResultView: UIView!
  
  let colorView = ColorView()
  let deviceTest = DeviceTest()
  var statusBarShouldBeHidden = false
  
  let titleExplanation = "À vous de jouer !"
  let explanation = "Ce test vous aide à repérer les éventuels pixels morts, tâches ou autres dégradations de l'écran LCD"
  let escapeButtonTitle = "Recommencer le test"
  let titleView = "Pixels morts & tâches"
  let startButtonTitle = "Démarrer le TEST"
  let titleResult = "Test Terminé"
  let question1 = "Durant le test,"
  let question2 = "Avez-vous vu un problème ?"
  let detail = "( pixels défectueux, tâches, bande blanches...)"
  let okButtonTitle = "Tout est OK !"
  let failButtonTitle = "Problèmes(s)"
  
  
  // MARK: Actions
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    titleLabel.text = titleView
    titleExplanationLabel.text = titleExplanation
    explanationLabel.text = explanation
    escapeButton.setTitle(escapeButtonTitle, for: .normal)
    
    titleResultLabel.text = titleResult
    question1ResultLabel.text = question1
    question2ResultLabel.text = question2
    detailResultLabel.text = detail
    okResultButton.setTitle(okButtonTitle, for: .normal)
    failResultButton.setTitle(failButtonTitle, for: .normal)
    failResultButton.style = .issue
    
    deviceTest.stateType = .screen
    deviceTest.state = .ongoing
    
    viewMode(explanationMode: true)
  }
  
  override func viewWillAppear(_ animated: Bool) {
    
    let screenSize: CGRect = UIScreen.main.bounds
    let screenHeight = screenSize.height
    
    if screenHeight < 550.0 {
      illustrationResultView.isHidden = true
    }
  }
  
  // Status bar hidden during colorView
  override var prefersStatusBarHidden: Bool {
    return statusBarShouldBeHidden
  }
  
  
  override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
    return .slide
  }
  
  private func statusBarAnimate(hidden: Bool) {
    statusBarShouldBeHidden = hidden
    UIView.animate(withDuration: 0.25) {
      self.setNeedsStatusBarAppearanceUpdate()
    }
  }
  
  @IBAction func didTapStartTest(_ sender: Any) {
    startColorTest()
  }
  
  @IBAction func didTapOk(_ sender: Any) {
    didPassTheTest()
  }
  
  @IBAction func didTapFail(_ sender: Any) {
    didFailTheTest()
  }
  
  @IBAction func didTapRestart(_ sender: Any) {
    startColorTest()
  }
  
  private func viewMode(explanationMode:Bool) {
    if explanationMode {
      explanationView.isHidden = false
      escapeButton.isHidden = true
      resultView.isHidden = true
    } else {
      explanationView.isHidden = true
      escapeButton.isHidden = false
      resultView.isHidden = false
    }
  }
  
  private func startColorTest() {
    let timeByView = 2.0
    
    // Hidde the statur bar
    statusBarAnimate(hidden: true)
    
    self.view.addSubview(colorView)
    DispatchQueue.main.asyncAfter(deadline: .now(), execute: {
      self.showColorView()
    })
    DispatchQueue.main.asyncAfter(deadline: .now() + timeByView, execute: {
      self.colorView.style = .green
    })
    DispatchQueue.main.asyncAfter(deadline: .now() + 2 * timeByView, execute: {
      self.colorView.style = .blue
    })
    DispatchQueue.main.asyncAfter(deadline: .now() + 3 * timeByView, execute: {
      self.colorView.style = .white
    })
    DispatchQueue.main.asyncAfter(deadline: .now() + 4 * timeByView, execute: {
      self.colorView.style = .black
    })
    
    DispatchQueue.main.asyncAfter(deadline: .now() + 5 * timeByView, execute: {
      self.hideColorView()
    })
  }
  
  private func showColorView() {
    colorView.transform = .identity
    colorView.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
    self.colorView.style = .red
    
    UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0.5, options: [], animations: {
      self.colorView.transform = .identity
    }, completion:nil)
  }
  
  private func hideColorView() {
    colorView.transform = .identity
    
    UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0.5, options: [], animations: {
      self.colorView.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
    }, completion: {(finished: Bool) in
      self.colorView.style = .hidden
      self.colorView.transform = .identity
      self.handleEndTest()
    })
  }
  
  private func handleEndTest() {
    colorView.removeFromSuperview()
    // Hidde the statur bar
    statusBarAnimate(hidden: false)
    viewMode(explanationMode: false)
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


extension screenColorViewController: MyProtocol {
  //Implement MyProtocol's function to make FirstViewContoller conform to MyProtocol
  // MARK: MyProtocol functions
  func setDataBack( nextSend: Bool) {
    if nextSend {
      moveToNextTest()
    }
  }
}

