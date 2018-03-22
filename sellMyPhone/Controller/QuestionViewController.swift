//
//  QuestionViewController.swift
//  sellMyPhone
//
//  Created by Quentin Noblet on 15/03/2018.
//  Copyright © 2018 Quentin Noblet. All rights reserved.
//

import UIKit

class QuestionViewController: UIViewController {
  
  // MARK: Properties
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var answersTableView: UITableView!
  @IBOutlet weak var previousButton: UIButton!
  
  let questions = QuestionsManagement.shared
  
  
  // MARK: Actions
  
  override func viewDidLoad() {
    super.viewDidLoad()
    start()
  }
  
  private func start() {
    previousButton.isHidden = true
    questions.getQuestions()
    titleLabel.text = questions.currentQuestion.title
  }
  
  @IBAction func didTapPrevious(_ sender: Any) {
    questions.goToPreviousQuestion()
    hideActualQuestion()
  }
  
  private func managePreviousButton() {
    if questions.currentIndex == 0 {
      previousButton.isHidden = true
    } else {
      previousButton.isHidden = false
    }
  }
  
  func hideActualQuestion() {
    answersTableView.alpha = 1
    titleLabel.alpha = 1
    
    UIView.animate(withDuration: 0.4, delay: 0.0, options: [], animations: {
      self.answersTableView.alpha = 0
      self.titleLabel.alpha = 0
    }) { (success) in
      if success {
        self.answersTableView.reloadData()
        self.titleLabel.text = self.questions.currentQuestion.title
        self.managePreviousButton()
        self.showNextQuestion()
      }
    }
  }
  
  func showNextQuestion() {
    switch questions.state {
    case .ongoing:
      answersTableView.alpha = 1
      titleLabel.alpha = 1
      answersTableView.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
      titleLabel.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
      
      UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: [], animations: {
        self.answersTableView.transform = .identity
        self.titleLabel.transform = .identity
      }, completion:nil)
    case .over:
      moveToNextTest()
    }
  }
  
  
  // MARK: - Navigation
  func moveToNextTest() {
    performSegue(withIdentifier: "nextTest", sender: self)
  }
}

extension QuestionViewController: UITableViewDelegate, UITableViewDataSource {
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return questions.currentQuestion.answers.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let myCell = tableView.dequeueReusableCell(withIdentifier: "TextCell", for: indexPath) as! AnswerTableViewCell
    myCell.titleLabel.text = questions.currentQuestion.answers[indexPath.row]
    myCell.secondaryLabel.text = questions.currentQuestion.answersInfo[indexPath.row]
    
    if questions.currentQuestion.userAnswer == indexPath.row {
      tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
    }
    
    return myCell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let myCell = tableView.cellForRow(at: indexPath) as! AnswerTableViewCell
    
    if myCell.reuseIdentifier == "TextCell" {
      questions.answerCurrentQuestion(with: indexPath.row)
      hideActualQuestion()
    }
  }
}

