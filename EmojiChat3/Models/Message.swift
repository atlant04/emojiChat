//
//  Message.swift
//  EmojiChat3
//
//  Created by MacBook on 2/11/20.
//  Copyright © 2020 MT. All rights reserved.
//

import Foundation
import FirebaseDatabase

struct Message {
    var text: String?
    var isSender: Bool?
    var toId: String?
    var fromId: String?
    var timestamp: String?

    init?(snapshot: DataSnapshot) {
        guard let data = snapshot.value as? [String: String] else { return nil}
        self.text = data["text"]
        self.toId = data["toId"]
        self.fromId = data["fromId"]
        self.timestamp = data["timestamp"]
        self.isSender = true
    }
}
