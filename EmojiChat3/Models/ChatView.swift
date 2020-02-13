//
//  ChatView.swift
//  EmojiChat3
//
//  Created by MacBook on 2/12/20.
//  Copyright © 2020 MT. All rights reserved.
//

import Foundation
import UIKit

class ChatView: UITableViewCell {
    let profileImage: UIImageView = {
        let iv = UIImageView(image: UIImage(named: "elon"))
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.layer.cornerRadius = 32
        iv.contentMode = .scaleAspectFill
        iv.layer.masksToBounds = true
        return iv
    }()

    let mainView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        return view
    }()

    let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Elon Musk"
        label.font = UIFont.systemFont(ofSize: 24)
        return label
    }()

    let messageLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Elon Musk invites you to go work at Tesla as soon as possible"
        return label
    }()

    let dateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Tue"
        return label
    }()

    let separator: UIView = {
        let separator = UIView()
        separator.translatesAutoresizingMaskIntoConstraints = false
        separator.backgroundColor = .lightGray
        return separator
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(profileImage)
        addSubview(mainView)
        addSubview(separator)
        setupConstraints()
        setupMainViewConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupConstraints() {
        NSLayoutConstraint.activate([
            profileImage.widthAnchor.constraint(equalToConstant: 64),
            profileImage.heightAnchor.constraint(equalToConstant: 64),
            profileImage.centerYAnchor.constraint(equalTo: centerYAnchor),
            profileImage.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            mainView.centerYAnchor.constraint(equalTo: centerYAnchor),
            mainView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            mainView.leadingAnchor.constraint(equalTo: profileImage.trailingAnchor, constant: 8),
            mainView.heightAnchor.constraint(equalToConstant: 60),
            separator.leadingAnchor.constraint(equalTo: profileImage.trailingAnchor),
            separator.trailingAnchor.constraint(equalTo: trailingAnchor),
            separator.bottomAnchor.constraint(equalTo: bottomAnchor),
            separator.heightAnchor.constraint(equalToConstant: 1)
        ])
    }

    func setupMainViewConstraints() {
        mainView.addSubview(nameLabel)
        mainView.addSubview(messageLabel)
        mainView.addSubview(dateLabel)
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: mainView.topAnchor),
            nameLabel.leadingAnchor.constraint(equalTo: mainView.leadingAnchor, constant: 8),
            messageLabel.leadingAnchor.constraint(equalTo: mainView.leadingAnchor, constant: 8),
            messageLabel.bottomAnchor.constraint(equalTo: mainView.bottomAnchor),
            messageLabel.trailingAnchor.constraint(equalTo: dateLabel.trailingAnchor, constant: -8),
            dateLabel.trailingAnchor.constraint(equalTo: mainView.trailingAnchor, constant: -8),
            dateLabel.topAnchor.constraint(equalTo: mainView.topAnchor)
        ])
    }

}
