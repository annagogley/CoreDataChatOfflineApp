//
//  ChatViewController.swift
//  TestChatApp
//
//  Created by Аня Воронцова on 16.03.2021.
//

import UIKit
import CoreData

class ChatViewController: UIViewController {

    @IBOutlet weak var chatCollectionView: UICollectionView!
    @IBOutlet weak var messageTextField: UITextField!
    @IBOutlet weak var collectionLayout: UICollectionViewFlowLayout! {
        didSet {
            collectionLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        }
    }
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var messages = [Messages]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        chatCollectionView.dataSource = self
        
        //get items from Core Data
        loadMessages()
    }
    
    func loadMessages() {
        //fetch the data from Core Data to display in table view
        let request : NSFetchRequest<Messages> = Messages.fetchRequest()
        do {
            messages = try context.fetch(request)
        }
        catch {
            print("Couldn't fetch data due to error: \(error)")
        }
        chatCollectionView.reloadData()
    }
    
    func saveMessages() {
        do {
            try context.save()
        }
        catch {
            print("Couldn't save data due to error \(error)")
        }
        chatCollectionView.reloadData()
    }
    
    @IBAction func sendButtonPressed(_ sender: UIButton) {
        guard messageTextField.text != nil else {
            return
        }
        let date = Date()
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: date)
        let minutes = calendar.component(.minute, from: date)
        
        //creating a message object
        let newMessage = Messages(context: context)
        newMessage.messageBody = messageTextField.text
        newMessage.sendTime = "\(hour):\(minutes)"
        newMessage.messageSender = Bool.random()
        
        //saving a message object
        saveMessages()
        
        //refetch data
        
        
    }

}

extension ChatViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = chatCollectionView.dequeueReusableCell(withReuseIdentifier: K.messageCollCell, for: indexPath) as! UserMessageCollectionViewCell
        let message = messages[indexPath.row]
        cell.setupCell(message: message)
        if message.messageSender {
            cell.leftTime.isHidden = false
            cell.rightTime.isHidden = true
            cell.messageBubble.backgroundColor = UIColor(named: K.brandColors.messageColor)
            cell.messageBody.font = .italicSystemFont(ofSize: 15)
            cell.messageBody.textColor = .white
        } else {
            cell.leftTime.isHidden = true
            cell.rightTime.isHidden = false
            cell.messageBubble.backgroundColor = .white
            cell.messageBody.font = .systemFont(ofSize: 15)
            cell.messageBody.textColor = .black
        }
        cell.maxWidth = collectionView.bounds.width  - CGFloat(74)
        
        
        return cell
    }
    
    
}
