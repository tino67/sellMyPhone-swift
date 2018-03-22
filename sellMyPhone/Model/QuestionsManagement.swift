//
//  QuestionsManagement.swift
//  sellMyPhone
//
//  Created by Quentin Noblet on 15/03/2018.
//  Copyright © 2018 Quentin Noblet. All rights reserved.
//

import Foundation

class QuestionsManagement {
  
  static let shared = QuestionsManagement()
  private init() {}
  
  let deviceState = DeviceState.shared
  private var deviceQuestions = [DeviceQuestion]()
  var currentIndex = 0
  
  var state: State = .ongoing
  
  enum State {
    case ongoing, over
  }
  
  var currentQuestion: DeviceQuestion {
    return deviceQuestions[currentIndex]
  }
  
  func getQuestions() {
    
    currentIndex = 0
    state = .ongoing
    
    var screenQuestion = DeviceQuestion()
    screenQuestion.title = " Quel est l'état de l'écran ?"
    screenQuestion.stateType = .screen
    for state in DeviceState.StateScreen.allValues {
      screenQuestion.answers.append(state.stateName)
      screenQuestion.answersInfo.append(state.stateInfo)
    }
    
    var generalQuestion = DeviceQuestion()
    generalQuestion.title = "Quel est l'état de la coque et des contours ?"
    generalQuestion.stateType = .general
    for state in DeviceState.StateGeneral.allValues {
      generalQuestion.answers.append(state.stateName)
      generalQuestion.answersInfo.append(state.stateInfo)
    }
    
    var simlockageQuestion = DeviceQuestion()
    simlockageQuestion.title = "Votre produit est-il bloqué opérateur ?"
    simlockageQuestion.stateType = .simlockage
    for state in DeviceState.StateSimlockage.allValues {
      simlockageQuestion.answers.append(state.stateName)
      simlockageQuestion.answersInfo.append(state.stateInfo)
    }
    
    var simlockageQuestion2 = DeviceQuestion()
    simlockageQuestion2.title = "Par quel opérateur ?"
    simlockageQuestion2.stateType = .operators
    for state in DeviceState.StateOperator.allValues {
      simlockageQuestion2.answers.append(state.stateName)
      simlockageQuestion2.answersInfo.append("")
    }
    
    self.deviceQuestions = [screenQuestion, generalQuestion, simlockageQuestion, simlockageQuestion2]
  }
  
  func answerCurrentQuestion(with answer: Int) {
    
    deviceQuestions[currentIndex].userAnswer = answer
    goToNextQuestion()
  }
  
  private func goToNextQuestion() {
    // Manage lock and unlock mobile
    if currentQuestion.stateType == .simlockage && currentQuestion.userAnswer == 0 {
      finish()
    }
    
    if currentIndex < deviceQuestions.count - 1 {
      currentIndex += 1
    } else {
      finish()
    }
  }
  
  func goToPreviousQuestion() {
    if currentIndex > 0 {
      currentIndex -= 1
    }
  }
  
  private func finish() {
    state = .over
    updateDeviceState()
  }
  
  private func updateDeviceState() {
    let myDeviceSate = DeviceState.shared
    myDeviceSate.updateForQuestions(Questions : self.deviceQuestions)
  }
}

