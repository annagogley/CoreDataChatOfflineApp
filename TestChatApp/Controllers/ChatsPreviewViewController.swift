//
//  ChatsPreviewViewController.swift
//  TestChatApp
//
//  Created by Аня Воронцова on 15.03.2021.
//

import UIKit
import SwipeCellKit
import CoreData

class ChatsPreviewViewController: UIViewController, SwipeTableViewCellDelegate {
    
    @IBOutlet weak var chatTableView: UITableView!
    
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
            
        }
        chatTableView.dataSource = self
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
        cell.delegate = self
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }

        let deleteAction = SwipeAction(style: .destructive, title: "") { action, indexPath in
            // handle action by updating model with deletion
            self.updateModel(at: indexPath)
        }

        // customize the action appearance
        deleteAction.image = UIImage(named: "iconDelete")?.tint(with: .white)
        

        return [deleteAction]
    }
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeOptions()
        options.expansionStyle = .destructive
        //        options.transitionStyle = .border
        return options
    }
    
    func updateModel(at indexPath: IndexPath) {
        // Update our datamodel
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: K.toChatSegue, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ChatViewController
        
        //set certain chat was selected 
    }
    
}
