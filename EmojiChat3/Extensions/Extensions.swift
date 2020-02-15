//
//  Extensions.swift
//  EmojiChat3
//
//  Created by MacBook on 2/10/20.
//  Copyright © 2020 MT. All rights reserved.
//

import Foundation
import UIKit
import FirebaseStorage

let cache = NSCache<Key, AnyObject>()

extension UIImageView{
    func fetchCachedImage(for user: User) {
        guard let uid = user.uid else { return }
        let key = Key(string: uid)
        if let image = cache.object(forKey: key) as? UIImage {
            self.image = image
            return
        }

        let ref = Storage.storage().reference(withPath: uid)
        DispatchQueue.main.async {
            ref.getData(maxSize: 1024 * 1024) { data, error in
                if let err = error { print(err); return }

                guard let image = UIImage(data: data!) else { return }
                cache.setObject(image, forKey: key)
                self.image = image
            }
        }
    }

}


class Key: NSObject {
    let string: String

    init(string: String) {
        self.string = string
    }

    override func isEqual(_ object: Any?) -> Bool {
        guard let other = object as? Key else { return false}
        return string == other.string
    }

    override var hash: Int {
        return string.hashValue
    }
}
