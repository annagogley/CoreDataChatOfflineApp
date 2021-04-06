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
    @IBOutlet weak var messageView: UIView!
    @IBOutlet weak var messageViewBottomConstraint: NSLayoutConstraint!
    
    var messages = [Messages]()
    var selectedChat: ChatPreview? {
        didSet {
            loadMessages()
        }
    }
    
    
    
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
        chatCollectionView.dataSource = self
        chatCollectionView.delegate = self
        chatCollectionView.collectionViewLayout = UICollectionViewFlowLayout()
        
        if let navBar = navigationController?.navigationBar {
            navBar.isHidden = false
            navbarView(height: Int(navigationController!.navigationBar.bounds.height))
        }
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(ChatViewController.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ChatViewController.keyboardWillShow), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        
    }
   
    //MARK: - Textfield above the keyboard
    
    @objc func keyboardWillShow(notification: NSNotification) {
        
        if let userInfo = notification.userInfo {
            let keyboardSize = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
            let isKeyboardIsShowing = notification.name == UIResponder.keyboardWillShowNotification
            print(isKeyboardIsShowing)
            if #available(iOS 11.0, *) {
                let window = UIApplication.shared.keyWindow
                let bottomPadding = window?.safeAreaInsets.bottom
                messageViewBottomConstraint.constant = isKeyboardIsShowing ? (keyboardSize!.height - bottomPadding!) : 0
            } else {
                messageViewBottomConstraint.constant = isKeyboardIsShowing ? keyboardSize!.height : 0
            }
            
            UIView.animate(withDuration: 0, delay: 0, options: UIView.AnimationOptions.curveEaseOut) {
                self.view.layoutIfNeeded()
            } completion: { (completed) in }

        }
    }
    
   
    
    //MARK: - Data Manipulation
    
    func loadMessages(with request: NSFetchRequest<Messages> = Messages.fetchRequest(), predicate: NSPredicate? = nil) {
        //fetch the data from Core Data to display in table view
        guard selectedChat != nil else {
            return
        }
        let categoryPredicate = NSPredicate(format: "parentCategory.id MATCHES %@", selectedChat!.id!)
        
        if let additionalPredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])
        } else {
            request.predicate = categoryPredicate
        }
        
        DispatchQueue.main.async {
            let indexPath = IndexPath(row: self.messages.count - 1, section: 0)
            self.chatCollectionView.scrollToItem(at: indexPath, at: .top, animated: true)
        }
        
        
        do {
            messages = try context.fetch(request)
        }
        catch {
            print("Couldn't fetch data due to error: \(error)")
        }
        
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
    
    //MARK: - send button pressed
    
    @IBAction func sendButtonPressed(_ sender: UIButton) {
        guard let text = messageTextField.text, !text.isEmpty  else {
            return
        }
        let date = Date()
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: date)
        let minutes = calendar.component(.minute, from: date)
        var minutesStr = "\(minutes)"
        if minutes - 10 < 0 {
            minutesStr = "0\(minutes)"
        }
        
        //creating a message object
        let newMessage = Messages(context: context)
        newMessage.messageBody = messageTextField.text
        newMessage.sendTime = "\(hour):\(minutesStr)"
        newMessage.isSender = Bool.random()
        newMessage.parentCategory = selectedChat
        messages.append(newMessage)
        selectedChat?.body = newMessage.messageBody
        selectedChat?.time = newMessage.sendTime
        selectedChat?.date = date
   
        saveMessages()
        messageTextField.text = ""
        DispatchQueue.main.async {
            let indexPath = IndexPath(row: self.messages.count - 1, section: 0)
            self.chatCollectionView.scrollToItem(at: indexPath, at: .top, animated: true)
            
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        messageTextField.endEditing(true)
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
        
        return CGSize(width: collectionView.bounds.width - 32, height: collectionView.bounds.height/8)
    }
    
    
}


