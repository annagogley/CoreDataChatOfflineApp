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
    
    var messages = [Messages]()
    var selectedChat: ChatPreview? {
        didSet {
            loadMessages()
        }
    }
    let fetchRequest : NSFetchRequest<ChatPreview> = ChatPreview.fetchRequest()
    var createdChat = [ChatPreview]()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        //        navigationController?.navigationBar.
        chatCollectionView.dataSource = self
        chatCollectionView.delegate = self
        chatCollectionView.collectionViewLayout = UICollectionViewFlowLayout()
        
        
    }
    
    //MARK: - Data Manipulation
    
    func loadMessages(with request: NSFetchRequest<Messages> = Messages.fetchRequest(), predicate: NSPredicate? = nil) {
        //fetch the data from Core Data to display in table view
        let categoryPredicate = NSPredicate(format: "parentChat.id MATCHES %@", selectedChat!.id!)
        
        if let additionalPredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])
        } else {
            request.predicate = categoryPredicate
        }
        
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
            DispatchQueue.main.async {
                self.chatCollectionView.reloadData()
            }
            
        }
        catch {
            print("Couldn't save data due to error \(error)")
        }
    }
    
    func updateChats(message: String, sendTime: String) -> Bool {
        var success = false
        
        do {
            let testing = try context.fetch(fetchRequest)
            fetchRequest.predicate = NSPredicate(format: "parentChat.id MATCHES %@", createdChat[0].id!)
            if testing.count == 1{
                let messageToUpdate = testing[0]
                messageToUpdate.body = message
                messageToUpdate.time = sendTime
                try context.save()
                success = true
                print("it's allright")
            }
        } catch {
            print("couldn't save chats due to \(error)")
        }
        return success
    }
    
    
    //MARK: - send button pressed
    
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
        newMessage.isSender = Bool.random()
        newMessage.parentCategory = selectedChat
        messages.append(newMessage)
        //        selectedChat?.body = newMessage.messageBody
        //        selectedChat?.time = newMessage.sendTime
        
        //saving a message object
        //        saveMessages()
        saveMessages()
        
        let newChat = ChatPreview(context: context)
        let uuid = UUID().uuidString
        newChat.body = newMessage.messageBody
        newChat.time = newMessage.sendTime
        newChat.id = uuid
        if createdChat.count == 0 {
            createdChat.append(newChat)
            print("appending message to new chat")
        }
        else {
            updateChats(message: newMessage.messageBody!, sendTime: newMessage.sendTime!)
            print("updated")
        }
        
    }
    
}

//MARK: - CollectionView methods

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
        
        //if user is the sender or not
        if message.isSender {
            cell.leftTime.isHidden = false
            cell.rightTime.isHidden = true
            cell.leftTime.textAlignment = .right
            cell.messageBubble.backgroundColor = UIColor(named: K.brandColors.messageColor)
            cell.messageBody.textAlignment = .right
            cell.messageBody.font = .italicSystemFont(ofSize: 15)
            cell.messageBody.textColor = .white
        } else {
            cell.messageBody.textAlignment = .left
            cell.leftTime.isHidden = true
            cell.rightTime.isHidden = false
            cell.rightTime.textAlignment = .left
            cell.messageBubble.backgroundColor = .white
            cell.messageBody.font = .systemFont(ofSize: 15)
            cell.messageBody.textColor = .black
        }
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cell = chatCollectionView.dequeueReusableCell(withReuseIdentifier: K.messageCollCell, for: indexPath) as! UserMessageCollectionViewCell
        let message = messages[indexPath.row]
        cell.setupCell(message: message)
        return CGSize(width: collectionView.bounds.width - 32, height: cell.messageBubble.frame.height)
    }
    
    
}

//extension ChatViewController: UITextFieldDelegate {
//
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//
//        if let txt = textField.text, txt.count >= 1 {
//            textField.resignFirstResponder()
//            return true
//        }
//        return false
//    }
//
//    func textFieldDidEndEditing(_ textField: UITextField) {
//
//        textField.resignFirstResponder()
//    }
//}
