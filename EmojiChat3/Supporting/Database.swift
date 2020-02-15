//
//  Database.swift
//  EmojiChat3
//
//  Created by MacBook on 2/15/20.
//  Copyright © 2020 MT. All rights reserved.
//

import Foundation
import FirebaseDatabase


class DB {
    private static let mainRef = Database.database().reference()

    static func observeThread(for user: User, completionHandler handler: @escaping (String?, DatabaseError?) -> Void)  {
        guard let uid = user.uid else {  handler(nil, .UserUnwrapingFailture); return }
        let ref = mainRef.child(Children.users.rawValue).child(uid).child(Children.chats.rawValue)
        ref.observe(.childAdded) { snap in
            guard let thread = snap.value as? String else { handler(nil, .FailedToFetchThread); return}
            handler(thread, nil)
        }
    }

    static func observeMessage(for thread: String, completionHandler handler: @escaping (Message?, DatabaseError?) -> Void) {
        let ref = mainRef.child(Children.threads.rawValue).child(thread)
        ref.observe(.childAdded) { snap in
            guard let message = Message(snapshot: snap) else { handler(nil, .FailedToFetchMessageFromThread); return }
            handler(message, nil)
        }
    }

    static func observeUser(id: String, completionHandler handler: @escaping (User?, DatabaseError?) -> Void) {
        let ref = mainRef.child(Children.users.rawValue).child(id)
        ref.observeSingleEvent(of: .value) { snap in
            guard let user = User(snapshot: snap) else { handler(nil, .FailedToFetchUser); return }
            handler(user, nil)
        }
    }
}

enum Children: String {
    case users = "users"
    case threads = "threads"
    case chats = "chats"

}

enum DatabaseError: Error {
    case UserUnwrapingFailture
    case FailedToFetchThread
    case FailedToFetchMessageFromThread
    case FailedToFetchUser
}
