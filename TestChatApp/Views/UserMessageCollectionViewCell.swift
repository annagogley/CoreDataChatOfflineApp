//
//  MessageCollectionViewCell.swift
//  TestChatApp
//
//  Created by Аня Воронцова on 17.03.2021.
//

import UIKit

class UserMessageCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var messageBody: UILabel!
    @IBOutlet weak var messageBubble: UIView!
    @IBOutlet weak var leftTime: UILabel!
    @IBOutlet weak var rightTime: UILabel!
    
    @IBOutlet private var maxWidthConstraint: NSLayoutConstraint! {
         didSet {
             maxWidthConstraint.isActive = false
         }
     }
     
     var maxWidth: CGFloat? = nil {
         didSet {
             guard let maxWidth = maxWidth else {
                 return
             }
             maxWidthConstraint.isActive = true
             maxWidthConstraint.constant = maxWidth
         }
     }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        contentView.translatesAutoresizingMaskIntoConstraints = false
             
             NSLayoutConstraint.activate([
                 contentView.leftAnchor.constraint(equalTo: leftAnchor),
                 contentView.rightAnchor.constraint(equalTo: rightAnchor),
                 contentView.topAnchor.constraint(equalTo: topAnchor),
                 contentView.bottomAnchor.constraint(equalTo: bottomAnchor)
             ])
    }
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    func setupCell (message: Messages) {
        self.messageBody.text = message.messageBody
        self.leftTime.text = message.sendTime
        self.rightTime.text = message.sendTime
        self.messageBubble.layer.cornerRadius = 4
        self.messageBubble.dropshadow(color: .black, opacity: 0.5, radius: 4)
    }

}
