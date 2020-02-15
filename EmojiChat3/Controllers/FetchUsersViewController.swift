//
//  UsersTableViewController.swift
//  EmojiChat3
//
//  Created by MacBook on 2/12/20.
//  Copyright © 2020 MT. All rights reserved.
//

import Foundation
import UIKit
import FirebaseDatabase

class FetchUsersViewController: UITableViewController {

    var users: [User] = []

    override func viewDidLoad() {
        tableView.register(UserView.self, forCellReuseIdentifier: "user")
        navigationItem.title = "Users"
        tableView.separatorStyle = .none
        fetchUsers()
        tableView.reloadData()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
}

extension FetchUsersViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        users.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "user", for: indexPath) as! UserView
        let user = users[indexPath.row]
        cell.textLabel?.text = user.name
        cell.detailTextLabel?.text = user.email
        cell.profileImage.fetchCachedImage(for: user)
        return cell
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let chatVC = ChatViewController()
        chatVC.receiver = users[indexPath.row]
        navigationController?.pushViewController(chatVC, animated: true)
    }

    func fetchUsers() {
        Database.database().reference().child("users").observe(.childAdded) { snap in
            if let user = User(snapshot: snap) {
                self.users.append(user)
                self.tableView.reloadData()
            }
        }
    }
}
