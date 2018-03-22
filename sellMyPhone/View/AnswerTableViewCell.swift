//
//  AnswerTableViewCell.swift
//  sellMyPhone
//
//  Created by Quentin Noblet on 16/03/2018.
//  Copyright © 2018 Quentin Noblet. All rights reserved.
//

import UIKit

class AnswerTableViewCell: UITableViewCell {
  
  @IBOutlet weak var cardView: UIView!
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var secondaryLabel: UILabel!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    self.selectionStyle = UITableViewCellSelectionStyle.none
    self.backgroundColor = .clear
    self.selectedBackgroundView = .none
    
    self.secondaryLabel.sizeToFit()
    self.secondaryLabel.numberOfLines = 0
    self.secondaryLabel.lineBreakMode = .byWordWrapping
    
    // UI update
    self.cardView.layer.borderWidth = 1.0
    self.cardView.layer.borderColor = C.Ui.viewLightBorderColor
    self.cardView.layer.cornerRadius = C.Ui.cornerRadius
    self.cardView.clipsToBounds = true
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    if selected {
      self.cardView.backgroundColor = C.Ui.selectedCellBackgroundColor
      self.titleLabel.textColor = C.Ui.selectedCellMainLabelColor
      self.secondaryLabel.textColor = C.Ui.selectedCellSecondaryLabelColor
    } else {
      self.cardView.backgroundColor = C.Ui.unSelectedCellBackgroundColor
      self.titleLabel.textColor = C.Ui.unSelectedCellMainLabelColor
      self.secondaryLabel.textColor = C.Ui.unSelectedCellSecondaryLabelColor
    }
  }
}

