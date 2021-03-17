//
//  ChatPreviewTableViewCell.swift
//  TestChatApp
//
//  Created by Аня Воронцова on 15.03.2021.
//

import UIKit
import SwipeCellKit

class ChatPreviewTableViewCell: SwipeTableViewCell {

    @IBOutlet weak var chatPreviewLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var messageBubble: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        chatPreviewLabel.font = .systemFont(ofSize: 18, weight: .bold)
        chatPreviewLabel.textColor = .white
        
        timeLabel.font = .systemFont(ofSize: 13, weight: .regular)
        timeLabel.textColor = .white
        
        messageBubble.layer.backgroundColor = UIColor.black.cgColor
        messageBubble.layer.cornerRadius = 8
        
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    

    
}
