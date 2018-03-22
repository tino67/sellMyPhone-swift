//
//  ScreenUpViewController.swift
//  sellMyPhone
//
//  Created by Quentin Noblet on 13/03/2018.
//  Copyright © 2018 Quentin Noblet. All rights reserved.
//

import UIKit

class ScreenUpViewController: UIViewController {
  
  // MARK: Properties
  
  @IBOutlet weak var explanationView: ExplanationView!
  @IBOutlet weak var escapeButton: secondaryActionButton!
  @IBOutlet weak var explanationLabel: UILabel!
  @IBOutlet weak var titleExplanationLabel: UILabel!
  @IBOutlet weak var screenTestCollectionView: UICollectionView!
  
  let deviceTest = DeviceTest()
  
  let titleExplanation = "2ÈRE PARTIE"
  let explanation = "Glissez votre doigt sur la partie jaune afin de la faire disparaître"
  let escapeButtonTitle = "Échouer à ce test"
  
  var numberOfCell: Int = 0
  var selectedIndexes: [Int] = []
  let cellByLine: CGFloat = 10
  let cellByColumn: CGFloat = 10
  
  var statusBarShouldBeHidden = false
  var myDeviceOrientation: UIInterfaceOrientation = .portrait
  
  
  // MARK: Actions
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    titleExplanationLabel.text = titleExplanation
    explanationLabel.text = explanation
    escapeButton.setTitle(escapeButtonTitle, for: .normal)
    
    deviceTest.stateType = .screen
    deviceTest.state = .ongoing
    
    screenTestCollectionView.isHidden = false
    addPanGesture(to: screenTestCollectionView)
    
    // Force orientation
    UIDevice.current.setValue(myDeviceOrientation.rawValue, forKey: "orientation")
  }
  
  override func viewWillAppear(_ animated: Bool) {
    // Hidde the statur bar
    statusBarShouldBeHidden = true
    UIView.animate(withDuration: 0.25) {
      self.setNeedsStatusBarAppearanceUpdate()
    }
  }
  
  // Force Orientation
  override var shouldAutorotate: Bool {
    return false
  }
  
  // Status bar hidden for top Screen test
  override var prefersStatusBarHidden: Bool {
    return statusBarShouldBeHidden
  }
  
  override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
    return .slide
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    screenTestCollectionView.collectionViewLayout.invalidateLayout()
  }
  
  @IBAction func didTapEscapeTest(_ sender: Any) {
    didEscapeTheTest()
  }
  
  
  // MARK: - Test Result Managment
  
  func didPassTheTest() {
    screenTestCollectionView.isHidden = true
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


extension ScreenUpViewController: UIGestureRecognizerDelegate {
  
  func addPanGesture(to collectionView: UICollectionView) {
    let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
    panGesture.delegate = self
    collectionView.addGestureRecognizer(panGesture)
  }
  
  @objc func handlePan(recognizer:UIPanGestureRecognizer) {
    let location = recognizer.location(in: screenTestCollectionView)
    if let indexPath: IndexPath = screenTestCollectionView.indexPathForItem(at: location) {
      
      if !selectedIndexes.contains((indexPath.row)) {
        // highlight the cell using a method
        self.collectionView(screenTestCollectionView, didSelectItemAt: indexPath)
      }
    }
  }
}


extension ScreenUpViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    
    numberOfCell = Int(cellByLine * cellByColumn)
    return numberOfCell
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
    cell.alpha = 1.0
    
    return cell
  }
  
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      sizeForItemAt indexPath: IndexPath) -> CGSize {
    let collectionViewHeight = screenTestCollectionView.frame.height
    let collectionViewWidth = screenTestCollectionView.frame.width
    
    let cellSize = CGSize(width: (collectionViewWidth - cellByLine + 1.0)/cellByLine, height: (collectionViewHeight - cellByColumn + 1.0)/cellByColumn)
    return cellSize
  }
  
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
    return 1.0
  }
  
  func collectionView(_ collectionView: UICollectionView, layout
    collectionViewLayout: UICollectionViewLayout,
                      minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    return 1.0
  }
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    let cell = collectionView.cellForItem(at: indexPath)!
    
    if !selectedIndexes.contains((indexPath.row)) {
      cell.alpha = 0.0
      selectedIndexes.append(indexPath.row)
      if selectedIndexes.count == numberOfCell {
        didPassTheTest()
      }
    }
  }
}


extension ScreenUpViewController: MyProtocol {
  //Implement MyProtocol's function to make FirstViewContoller conform to MyProtocol
  // MARK: MyProtocol functions
  func setDataBack( nextSend: Bool) {
    if nextSend {
      moveToNextTest()
    }
  }
}

