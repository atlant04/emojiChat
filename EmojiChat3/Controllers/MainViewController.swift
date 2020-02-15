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

    var users: [User] = []
    var lastMessages: [String] = []
    var threads: [String] = []

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
        observeThreads()
    }
}

extension MainViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        users.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "chat", for: indexPath) as! ChatView
        let user = users[indexPath.row]
        cell.nameLabel.text = user.name
        cell.profileImage.fetchCachedImage(for: user)
        cell.messageLabel.text = lastMessages[indexPath.row]
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let chatVC = ChatViewController()
        chatVC.threadId = threads[indexPath.row]
        chatVC.receiver = users[indexPath.row]
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

    func observeThreads() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let database = Database.database().reference()
        let ref = database.child("users").child(uid).child("chats")
        ref.observe(.childAdded) { snap in
            if let thread = snap.value as? String {
                print(thread)
                self.threads.append(thread)
                let threadRef = database.child("threads").child(thread)
                threadRef.observeSingleEvent(of: .childAdded) { snap in
                    if let message = Message(snapshot: snap) {
                        self.observeUser(for: message)
                    }
                }
            }
        }
    }

    func observeUser(for message: Message) {
        guard let toId = message.toId else { return }
        lastMessages.append(message.text!)
        let ref = Database.database().reference().child("users").child(toId)
        ref.observeSingleEvent(of: .value) { snap in
            if let user = User(snapshot: snap) {
                self.users.append(user)
                self.tableView.reloadData()
            }
        }
    }

}

