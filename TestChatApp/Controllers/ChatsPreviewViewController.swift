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
    var chatPreview : [ChatPreview]?
    
    var messages : [Message] =
        [
            Message(body: "Hello, neighbour!", time: "19:27"),
            Message(body: "Somethibg long it's a big message way a as as ", time: "09:27"),
            Message(body: "It's test chat", time: "13:06"),
        ]
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        chatTableView.rowHeight = 68
        chatTableView.separatorStyle = .none
        chatTableView.register(UINib(nibName: K.cellNibName, bundle: nil), forCellReuseIdentifier: K.cellIdentifier)
        
        if let navBar = navigationController?.navigationBar {
            navBar.isHidden = false
            navBar.backgroundColor = .white
            navBar.dropshadow(color: UIColor.black, opacity: 0.38, radius: 7)
            navBar.layer.shadowPath = UIBezierPath(rect: navBar.bounds).cgPath
            
        }
        chatTableView.dataSource = self
        fetchChats()
    }
    
    func fetchChats() {
        //fetch the data from Core Data to display in table view
        do {
            try context.fetch(ChatPreview.fetchRequest())
            DispatchQueue.main.async {
                self.chatTableView.reloadData()
            }
        }
        catch {
            print("Couldn't fetch data due to error: \(error)")
        }
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
    }
    

}



//MARK: - extension Data Source

extension ChatsPreviewViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = messages[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: K.cellIdentifier, for: indexPath) as! ChatPreviewTableViewCell
        cell.chatPreviewLabel.text = message.body
        cell.timeLabel.text = message.time
//        cell.delegate = self
        
        return cell
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: K.toChatSegue, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ChatViewController
        
        //set certain chat was selected 
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        //create swipe action
        let action = UIContextualAction(style: .destructive, title: "") { (action, view, completionHandler) in
            
            //which chat to remove
            let chatToRemove = self.chatPreview![indexPath.row]
            
            //remove the chat
            self.context.delete(chatToRemove)
            
            //save the data
            do {
                try self.context.save()
            }
            catch {
                print("Couldn't remove data due to: \(error)")
            }
            
            //refecth the data
            self.fetchChats()
        }
        action.backgroundColor = UIColor(patternImage: UIImage(named: K.deleteIcon)!)
        
        return UISwipeActionsConfiguration(actions: [action])
    }
    
}
