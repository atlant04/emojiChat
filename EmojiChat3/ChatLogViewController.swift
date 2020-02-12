//
//  ChatLogViewController.swift
//  EmojiChat3
//
//  Created by MacBook on 2/10/20.
//  Copyright © 2020 MT. All rights reserved.
//
import UIKit

class ChatLogViewController: UITableViewController {


    var messages: [Message] = [
        Message(text: "Hi my name is Maksim and I have been trying to build this fucking app for so long I had to restart twice", isSender: false),
        Message(text: "Hey, Maksim, don't worry, dawg, you got it ", isSender: true),
        Message(text: "Hi my name is Maksim and I have been trying to build this fucking app for so long I had to restart twice", isSender: false),
        Message(text: "Hey, Maksim, don't worry, dawg, you got it ", isSender: true),
        Message(text: "Hi my name is Maksim and I have been trying to build this fucking app for so long I had to restart twice", isSender: false),
        Message(text: "Hey, Maksim, don't worry, dawg, you got it ", isSender: true),
        Message(text: "Hi my name is Maksim and I have been trying to build this fucking app for so long I had to restart twice", isSender: false),
        Message(text: "Hey, Maksim, don't worry, dawg, you got it ", isSender: true),
        Message(text: "Hi my name is Maksim and I have been trying to build this fucking app for so long I had to restart twice", isSender: false),
        Message(text: "Hey, Maksim, don't worry, dawg, you got it ", isSender: true),
        Message(text: "Hi my name is Maksim and I have been trying to build this fucking app for so long I had to restart twice", isSender: false),
        Message(text: "Hey, Maksim, don't worry, dawg, you got it ", isSender: true)
    ]

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
}
