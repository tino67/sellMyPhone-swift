//
//  DeviceState.swift
//  sellMyPhone
//
//  Created by Quentin Noblet on 27/02/2018.
//  Copyright © 2018 Quentin Noblet. All rights reserved.
//

import Foundation

class DeviceState {
  
  static let shared = DeviceState()
  private init() {}
  
  // StateFunctional
  var stateFunctional: StateFunctional = .fonctionnel
  
  enum StateFunctional {
    case fonctionnel, non_fonctionnel
    
    var stateId: String {
      switch self {
      case .fonctionnel: return "fonctionnel"
      case .non_fonctionnel: return "non_fonctionnel"
      }
    }
    var stateName: String {
      switch self {
      case .fonctionnel: return "Fonctionnel"
      case .non_fonctionnel: return "Non fonctionnel"
      }
    }
    static let allValues = [fonctionnel, non_fonctionnel]
  }
  
  // StateScreen
  var stateScreen: StateScreen = .intact
  
  enum StateScreen {
    case intact, micro_rayure, raye, hs
    var stateId: String {
      switch self {
      case .intact: return "intact"
      case .micro_rayure: return "micro_rayure"
      case .raye: return "raye"
      case .hs: return "hs"
      }
    }
    var stateName: String {
      switch self {
      case .intact: return "Intact"
      case .micro_rayure: return "Micro Rayure"
      case .raye: return "Rayé"
      case .hs: return "Fissuré / Cassé"
      }
    }
    var stateInfo: String {
      switch self {
      case .intact: return "Ne comporte aucune rayure ni micro-rayure"
      case .micro_rayure: return "Micro-rayures très légères et difficiles à percevoir"
      case .raye: return "Rayures visibles l'écran éteint"
      case .hs: return "Rayures non superficielles visibles l'écran allumé ou présence de fissures / éclats / abrasions / tâches"
      }
    }
    static let allValues = [intact, micro_rayure, raye, hs]
  }
  
  // StateGeneral
  var stateGeneral: StateGeneral = .comme_neuf
  
  enum StateGeneral {
    case comme_neuf, tres_bon, bon, abime, correct
    var stateId: String {
      switch self {
      case .comme_neuf: return "comme_neuf"
      case .tres_bon: return "tres_bon"
      case .bon: return "bon"
      case .abime: return "abime"
      case .correct: return "correct"
      }
    }
    var stateName: String {
      switch self {
      case .comme_neuf: return "Intact"
      case .tres_bon: return "Micro Rayures"
      case .bon: return "Rayé"
      case .abime: return "Abimé"
      case .correct: return "Fissuré / Cassé"
      }
    }
    var stateInfo: String {
      switch self {
      case .comme_neuf: return "Ne comporte aucune rayure, traces d'utilisation ou choc."
      case .tres_bon: return "Micro-rayures très légères et difficiles à percevoir"
      case .bon: return "Fines Rayures ou micro-impacts"
      case .abime: return "Rayures marquées, impacts ou éclats de peinture apparents"
      case .correct: return "Coque déformée / fissurée / cassée ou choc / éclats importants"
      }
    }
    static let allValues = [comme_neuf, tres_bon, bon, abime, correct]
  }
  
  // StateSimlockage
  var stateSimlockage: StateSimlockage = .unlock
  enum StateSimlockage {
    case unlock, lock
    var stateId: String {
      switch self {
      case .unlock: return "unlock"
      case .lock: return "lock"
      }
    }
    var stateName: String {
      switch self {
      case .unlock: return "Débloqué"
      case .lock: return "Bloqué"
      }
    }
    var stateInfo: String {
      switch self {
      case .unlock: return "Votre téléphone est utilisable sur n'importe quel opérateur réseau français"
      case .lock: return "Votre produit est utilisable uniquement sur un opérateur spécifique (Orange, SFR...)"
      }
    }
    static let allValues = [unlock, lock]
  }
  
  // Simlockage
  var stateOperator: StateOperator = .autre
  
  enum StateOperator: String {
    case orange, bouygues, sfr, virgin, autre
    var stateId: String {
      switch self {
      case .orange: return "orange"
      case .bouygues: return "bouygues"
      case .sfr: return "sfr"
      case .virgin: return "virgin"
      case .autre: return "autre"
      }
    }
    var stateName: String {
      switch self {
      case .orange: return "Orange"
      case .bouygues: return "Bouygues"
      case .sfr: return "SFR"
      case .virgin: return "Virgin"
      case .autre: return "Autre"
      }
    }
    static let allValues = [orange, bouygues, sfr, virgin, autre]
  }
  
  
  func restartState() {
    self.stateFunctional = .fonctionnel
    self.stateScreen = .intact
    self.stateGeneral = .comme_neuf
    self.stateSimlockage = .unlock
  }
  
  func updateForFail(deviceTest: DeviceTest) {
    if deviceTest.state == .incorrect {
      switch deviceTest.stateType {
      case .functional:
        self.stateFunctional = .non_fonctionnel
      case .general:
        self.stateGeneral = .abime
      case.screen:
        self.stateScreen = .hs
      case .simlockage:
        self.stateSimlockage = .lock
      default: break
      }
    }
  }
  
  func updateForQuestions(Questions : [DeviceQuestion]) {
    
    for deviceQuestion in Questions {
      
      
      switch deviceQuestion.stateType {
      case .functional:
        let states = StateFunctional.allValues
        // If state decrease we update the state
        if let actualStateInt = states.index(of: self.stateFunctional), let newStateInt = deviceQuestion.userAnswer, actualStateInt < newStateInt {
          self.stateFunctional = states[newStateInt]
        }
        
      case .general:
        let states = StateGeneral.allValues
        // If state decrease we update the state
        if let actualStateInt = states.index(of: self.stateGeneral), let newStateInt = deviceQuestion.userAnswer, actualStateInt < newStateInt {
          self.stateGeneral = states[newStateInt]
        }
      case.screen:
        let states = StateScreen.allValues
        // If state decrease we update the state
        if let actualStateInt = states.index(of: self.stateScreen), let newStateInt = deviceQuestion.userAnswer, actualStateInt < newStateInt {
          self.stateScreen = states[newStateInt]
        }
      case .simlockage:
        let states = StateSimlockage.allValues
        if let newStateInt = deviceQuestion.userAnswer {
          self.stateSimlockage = states[newStateInt]
        }
      case .operators:
        let states = StateOperator.allValues
        if let newStateInt = deviceQuestion.userAnswer {
          self.stateOperator = states[newStateInt]
        }
      default: break
      }
    }
  }
}

