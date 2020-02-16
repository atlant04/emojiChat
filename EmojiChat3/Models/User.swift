//
//  User.swift
//  EmojiChat3
//
//  Created by MacBook on 2/11/20.
//  Copyright © 2020 MT. All rights reserved.
//

import Foundation
import FirebaseDatabase
import FirebaseAuth

struct User: Codable {
    var uid: String?
    var email: String?
    var name: String?

    init(uid: String, email: String, name: String) {
        self.uid = uid
        self.email = email
        self.name = name
    }

    init?(snapshot: DataSnapshot) {
        guard let values = snapshot.value as? [String: Any] else { return nil }
        uid = snapshot.key
        email = values["email"] as? String
        name = values["name"] as? String
    }

//    static func authUser() -> User? {
//        guard let FIRUser = Auth.auth().currentUser else { return nil }
//        let uid = FIRUser.uid
//        let email = FIRUser.email
//    }

    static func save(_ user: User) {
        UserDefaults.standard.set(try? PropertyListEncoder().encode(user), forKey: "currentUser")
    }

    static func get() -> User? {
        let user: User?
        if let data = UserDefaults.standard.object(forKey: "currentUser") as? Data {
            user = try? PropertyListDecoder().decode(User.self, from: data)
            return user
        } else {
            return nil
        }
    }
}
