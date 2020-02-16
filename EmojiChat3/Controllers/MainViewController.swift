//
//  ViewController.swift
//  EmojiChat3
//
//  Created by MacBook on 2/10/20.
//  Copyright © 2020 MT. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class MainViewController: UITableViewController {

    var currentUser: User!
    var chats: [Chat] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.backgroundColor = .white
        tableView.separatorStyle = .none
        tableView.register(ChatView.self, forCellReuseIdentifier: "chat")
        let barBtn = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(newChatButtonTapped))
        let logoutBtn = UIBarButtonItem(title: "Log out", style: .plain, target: self, action: #selector(logout))
        navigationItem.rightBarButtonItem = barBtn
        navigationItem.leftBarButtonItem = logoutBtn
        navigationItem.title = "Chats"
        navigationController?.navigationBar.prefersLargeTitles = true
        if (currentUser == nil) {
             currentUser = User.get()
        }
        if currentUser == nil {
            let loginVC = LoginViewController()
            loginVC.modalPresentationStyle = .fullScreen
            self.present(loginVC, animated: true, completion: nil)
        } else {
             fetchChats()
        }
    }
}

extension MainViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        chats.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "chat", for: indexPath) as! ChatView
        let chat = chats[indexPath.row]
        guard let name = chat.user?.name, let text = chat.messages.first?.text, let user = chat.user else { return cell }
        cell.nameLabel.text = name
        cell.profileImage.fetchCachedImage(for: user)
        cell.messageLabel.text = text
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let chatVC = ChatViewController()
        chatVC.threadId = chats[indexPath.row].thread
        chatVC.receiver = chats[indexPath.row].user
        self.navigationController?.pushViewController(chatVC, animated: true)
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }

    @objc func newChatButtonTapped(sender: UIBarButtonItem) {
        let usersVC = FetchUsersViewController()
        navigationController?.pushViewController(usersVC, animated: true)
    }

    @objc func logout(sender: UIBarButtonItem) {
        if let _ = try? Auth.auth().signOut() {
            let loginVC = LoginViewController()
            loginVC.modalPresentationStyle = .fullScreen
            self.present(loginVC, animated: true, completion: nil)
        }
    }

    //    func observeThreads() {
    //        guard let uid = Auth.auth().currentUser?.uid else { return }
    //        let database = Database.database().reference()
    //        let ref = database.child("users").child(uid).child("chats")
    //        ref.observe(.childAdded) { snap in
    //            if let thread = snap.value as? String {
    //                self.threads.append(thread)
    //                let threadRef = database.child("threads").child(thread)
    //                threadRef.observeSingleEvent(of: .childAdded) { snap in
    //                    if let message = Message(snapshot: snap) {
    //                        self.observeUser(for: message)
    //                    }
    //                }
    //            }
    //        }
    //    }

    func fetchChats() {
        DispatchQueue.global(qos: .background).async { [weak self] in
            DB.observeThread(for: self!.currentUser) { thread, error in
                guard let thread = thread else { return }
                let chat = Chat()
                chat.thread = thread
                self?.fetchMessages(for: chat)
                self?.chats.append(chat)
            }
        }
    }

    func fetchMessages(for chat: Chat) {
        DB.observeMessage(for: chat.thread!) { [weak self] (message, eror) in
            guard let message = message else { return }
            chat.messages.append(message)
            if (chat.messages.count == 1) {
                guard let toId = message.toId else { return }
                DB.observeUser(id: toId) { user, error in
                    chat.user = user
                    DispatchQueue.main.async {
                        self?.tableView.reloadData()
                    }
                }
            }
        }
    }

    //    func observeUser(for message: Message, chat: inout Chat) {
    //        guard let toId = message.toId else { return }
    //        let ref = Database.database().reference().child("users").child(toId)
    //        ref.observeSingleEvent(of: .value) { snap in
    //            if let user = User(snapshot: snap) {
    //                chat.user = user
    //                self.tableView.reloadData()
    //            }
    //        }
    //    }

}

