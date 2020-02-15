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

class ChatViewController: UITableViewController {
    var receiver: User?
    var messages: [Message] = []
    var threadId: String? {
        didSet {
              observeMessages()
        }
    }

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
        if threadId == nil {
            threadId = setupOneToOneChat()
        }
    }

}

extension ChatViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        messages.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "bubble", for: indexPath) as! Bubble
        cell.message = messages[indexPath.row]
        return cell
    }
}

extension ChatViewController {
    func setupOneToOneChat() -> String? {
        guard let senderId = Auth.auth().currentUser?.uid, let receiverId = receiver?.uid else { return nil }
        return (senderId < receiverId) ? senderId + receiverId : receiverId + senderId
    }

    @objc func handleSend() {
        guard let text = self.accessory.textField.text,
            let senderId = Auth.auth().currentUser?.uid,
            let receiverID = receiver?.uid,
            let threadId = self.threadId
        else { return }

        let database = Database.database().reference()
        let thread = database.child("threads").child(threadId).childByAutoId()
        let timestamp = Date().description
        let values = ["text": text, "toId": receiverID, "fromId": senderId, "timestamp": timestamp]
        thread.updateChildValues(values)
    }

    func observeMessages() {
        guard let threadId = self.threadId else { return }
        let ref = Database.database().reference().child("threads").child(threadId)
        ref.observe(.childAdded) { snap in
            if let message = Message(snapshot: snap) {
                self.messages.append(message)
                self.tableView.reloadData()
            }
        }
    }

}
