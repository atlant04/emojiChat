//
//  User.swift
//  EmojiChat3
//
//  Created by MacBook on 2/11/20.
//  Copyright © 2020 MT. All rights reserved.
//

import Foundation
import FirebaseDatabase

struct User {
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
}
