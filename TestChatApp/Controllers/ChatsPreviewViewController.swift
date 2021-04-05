//
//  ChatsPreviewViewController.swift
//  TestChatApp
//
//  Created by Аня Воронцова on 15.03.2021.
//

import UIKit
import CoreData

class ChatsPreviewViewController: UIViewController {
    
    @IBOutlet weak var chatTableView: UITableView!
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var chatPreview = [ChatPreview]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        chatTableView.rowHeight = 68
        chatTableView.separatorStyle = .none
        chatTableView.register(UINib(nibName: K.cellNibName, bundle: nil), forCellReuseIdentifier: K.cellIdentifier)
        
        if let navBar = navigationController?.navigationBar {
            navBar.isHidden = false
//            navBar.dropshadow(color: UIColor.black, opacity: 0.38, radius: 7)
//            navBar.layer.shadowPath = UIBezierPath(rect: navBar.bounds).cgPath
        }
        
        chatTableView.dataSource = self
        chatTableView.delegate = self
        loadChats()
        print(chatPreview.count)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        loadChats()
    }
    
    override func viewWillDisappear(_ animated: Bool) {

    }
    
//MARK: - data manipulation
    
    func loadChats() {
        //fetch the data from Core Data to display in table view
        let request : NSFetchRequest<ChatPreview> = ChatPreview.fetchRequest()
        
        let sort = NSSortDescriptor(key: "date", ascending: false)
        request.sortDescriptors = [sort]
        
        do {
            chatPreview = try context.fetch(request)
        }
        catch {
            print("Couldn't fetch data due to error: \(error)")
        }
        chatTableView.reloadData()
    }
    
    func saveChats() {
        do {
            try context.save()
        }
        catch {
            print("Couldn't save data due to error \(error)")
        }
        print("savingChats")
        chatTableView.reloadData()
    }
    
    
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        let newChat = ChatPreview(context: context)
        //генерируем id
        let uuid = UUID().uuidString
        //генерируем время
        let date = Date()
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: date)
        let minutes = calendar.component(.minute, from: date)
        var minutesStr = "\(minutes)"
        if minutes - 10 < 0 {
            minutesStr = "0\(minutes)"
        }
        
        //creating chat preview
        newChat.date = date
        newChat.id = uuid
        newChat.body = "New chat"
        newChat.time = "\(hour):\(minutesStr)"
        chatPreview.append(newChat)
        chatTableView.reloadData()
        
        saveChats()
        loadChats()

    }
    

}

//MARK: - extension Data Source

extension ChatsPreviewViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chatPreview.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.cellIdentifier, for: indexPath) as! ChatPreviewTableViewCell
        cell.chatPreviewLabel.text = chatPreview[indexPath.row].body!
        cell.timeLabel.text = chatPreview[indexPath.row].time!
        
        return cell
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("chat \(chatPreview[indexPath.row].id ?? "1") was selected")
        print("row \(indexPath) was selected")
        performSegue(withIdentifier: "goToChat", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ChatViewController
        
        //set certain chat was selected
        if let indexPath = chatTableView.indexPathForSelectedRow {
            destinationVC.selectedChat = chatPreview[indexPath.row]
        } 
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        //create swipe action
        let action = UIContextualAction(style: .destructive, title: "") { (action, view, completionHandler) in
            
            //which chat to remove
            let chatToRemove = self.chatPreview[indexPath.row]
            
            //remove the chat
            self.context.delete(chatToRemove)
            
            //save the data
            self.saveChats()
        }
        action.backgroundColor = UIColor(patternImage: UIImage(named: K.deleteIcon)!)
        
        return UISwipeActionsConfiguration(actions: [action])
    }
    
}
