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

class ViewController: UITableViewController {

    var people: [String] = ["Friend 1", "Friend 2", "Friend 3"]
    var user: User? {
        didSet {
            if let name = user?.name {
                navigationItem.title = "Welcome, \(name)"
            }
        }
    }

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
    }
}

extension ViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        people.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "chat", for: indexPath) as! ChatView
//        cell.textLabel?.text = people[indexPath.row]
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.navigationController?.pushViewController(ChatLogViewController(), animated: true)
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }

    @objc func newChatButtonTapped(sender: UIBarButtonItem) {
        let usersVC = UsersTableViewController()
        navigationController?.pushViewController(usersVC, animated: true)
    }

    @objc func logout(sender: UIBarButtonItem) {
        if let _ = try? Auth.auth().signOut() {
            let loginVC = LoginViewController()
            loginVC.modalPresentationStyle = .fullScreen
            self.present(loginVC, animated: true, completion: nil)
        }
    }
}

