//
//  SendMessageView.swift
//  EmojiChat3
//
//  Created by MacBook on 2/10/20.
//  Copyright © 2020 MT. All rights reserved.
//

import Foundation
import UIKit

class SendMessageView: UIView {
    let textField: UITextField = {
        let tv = UITextField()
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.placeholder = "Enter message"
        return tv
    }()

    let sendButton: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitle("Send", for: .normal)
        return btn
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .lightGray
        addSubview(textField)
        addSubview(sendButton)
        setupTextView()
        setupSendButton()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    func setupTextView() {
        NSLayoutConstraint.activate([
            textField.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            textField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            textField.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),
            textField.trailingAnchor.constraint(equalTo: sendButton.leadingAnchor, constant: 8)
        ])
    }

    func setupSendButton() {
        NSLayoutConstraint.activate([
            sendButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            sendButton.widthAnchor.constraint(equalToConstant: 50),
            sendButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
        ])
    }

    override var intrinsicContentSize: CGSize {
        let size = CGSize(width: textField.frame.width + 16, height: 75)
        return size
    }
}
