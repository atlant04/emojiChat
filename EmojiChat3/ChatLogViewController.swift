//
//  ChatLogViewController.swift
//  EmojiChat3
//
//  Created by MacBook on 2/10/20.
//  Copyright © 2020 MT. All rights reserved.
//
import UIKit
import FirebaseDatabase
import FirebaseAuth

class ChatLogViewController: UITableViewController {
    var user: User?
    var messages: [Message] = []

    var accessory = SendMessageView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 75))

    override var inputAccessoryView: UIView? {
        get {
            return accessory
        }
    }

    override var canBecomeFirstResponder: Bool {
        get {
            return true
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(Bubble.self, forCellReuseIdentifier: "bubble")
        tableView.separatorStyle = .none
        tableView.keyboardDismissMode = .interactive
        tableView.backgroundColor = UIColor(white: 0.95, alpha: 1)
        tableView.allowsSelection = false
        becomeFirstResponder()
        accessory.sendButton.addTarget(self, action: #selector(handleSend), for: .touchUpInside)
        observeMessages()
    }

}

extension ChatLogViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        messages.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "bubble", for: indexPath) as! Bubble
        cell.message = messages[indexPath.row]
        return cell
    }

    @objc func handleSend() {
        guard let text = self.accessory.textField.text,
            let senderId = Auth.auth().currentUser?.uid,
            let user = self.user
            else { return }

        let ref = Database.database().reference().child("messages")
        let childRef = ref.childByAutoId()
        let timestamp = Date().description
        let values = ["text": text, "toId": user.uid, "fromId": senderId, "timestamp": timestamp]
        childRef.updateChildValues(values)
    }

    func observeMessages() {
        Database.database().reference().child("messages").observe(.childAdded) { snap in
            if let message = Message(snapshot: snap) {
                self.messages.append(message)
                self.tableView.reloadData()
            }
        }
    }
}
