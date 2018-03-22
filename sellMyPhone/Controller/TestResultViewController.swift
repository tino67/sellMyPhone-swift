//
//  TestResultViewController.swift
//  sellMyPhone
//
//  Created by Quentin Noblet on 27/02/2018.
//  Copyright © 2018 Quentin Noblet. All rights reserved.
//

import UIKit

class TestResultViewController: UIViewController {
  
  //MARK: Properties
  
  @IBOutlet weak var resultView: TestResultView!
  
  var testResult = false
  let delayViewShow = 2.0
  var timer = Timer()
  
  //Protocol to send Data Backward
  var myProtocol: MyProtocol?
  
  
  //MARK: Actions
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    if testResult {
      resultView.style = .correct
    } else {
      resultView.style = .incorrect
    }
    self.showAnimateTestResultView()
    
    // Tap to Close Gesture
    let gesture = UITapGestureRecognizer(target: self, action: #selector(closeTestResultView))
    self.view.addGestureRecognizer(gesture)
  }
  
  override func viewDidAppear(_ animated: Bool) {
    
    timer = Timer.scheduledTimer(timeInterval: delayViewShow, target: self, selector: #selector(closeTestResultView), userInfo: nil, repeats: false)
  }
  
  @objc private func closeTestResultView() {
    timer.invalidate()
    hideAnimateTestResultView()
    myProtocol?.setDataBack(nextSend: true)
  }
  
  private func showAnimateTestResultView() {
    resultView.transform = .identity
    resultView.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
    resultView.alpha = 0.0
    
    UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: [], animations: {
      self.resultView.alpha = 1.0
      self.resultView.transform = .identity
    }, completion:nil)
  }
  
  private func hideAnimateTestResultView() {
    resultView.transform = .identity
    resultView.alpha = 1.0
    
    UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: [], animations: {
      self.resultView.alpha = 0.0
      self.resultView.transform = .identity
      self.resultView.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
    }, completion: {(finished: Bool) in
      if finished{
        self.view.removeFromSuperview()
        
      }
    })
  }
}

