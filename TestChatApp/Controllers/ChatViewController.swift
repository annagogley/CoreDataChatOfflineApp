//
//  ChatViewController.swift
//  TestChatApp
//
//  Created by Аня Воронцова on 16.03.2021.
//

import UIKit

class ChatViewController: UIViewController {

    @IBOutlet weak var chatCollectionView: UICollectionView!
    @IBOutlet weak var messageTextField: UITextField!
    
    var messages : [Message] =
        [
            Message(body: "Hello, neighbour!", time: "19:27", sender: "self"),
            Message(body: "Somethibg long it's a big message way a as as ", time: "09:27", sender: "other"),
            Message(body: "It's test chat", time: "13:06", sender: "self"),
        ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func sendButtonPressed(_ sender: UIButton) {
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension ChatViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: K.messageCollCell, for: indexPath)
        
        
        
        
        return cell
    }
    
    
}
