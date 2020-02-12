//
//  Bubble.swift
//  EmojiChat3
//
//  Created by MacBook on 2/10/20.
//  Copyright © 2020 MT. All rights reserved.
//

import Foundation
import UIKit

class Bubble: UITableViewCell {

    var leftConstraint: NSLayoutConstraint!
    var rightConstraint: NSLayoutConstraint!

    var bgView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 16
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    var message: Message! {
        didSet {
            label.text = message.text
            isSender = message.isSender
        }
    }

    var isSender: Bool! {
        didSet {
            if isSender {
                rightConstraint.isActive = true
                bgView.backgroundColor = .blue
                label.textColor = .white
            } else {
                leftConstraint.isActive = true
                bgView.backgroundColor = .white
                label.textColor = .black
            }
        }
    }

    var label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .clear
        label.textColor = .black
        label.numberOfLines = 0
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        bgView.addSubview(label)
        addSubview(bgView)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupLayout() {
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: bgView.topAnchor, constant: 4),
            label.bottomAnchor.constraint(equalTo: bgView.bottomAnchor, constant: -4),
            label.leadingAnchor.constraint(equalTo: bgView.leadingAnchor, constant: 8),
            label.trailingAnchor.constraint(equalTo: bgView.trailingAnchor, constant: -8),

            bgView.topAnchor.constraint(equalTo: topAnchor, constant: 4),
            bgView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -4),
            bgView.widthAnchor.constraint(lessThanOrEqualToConstant: UIScreen.main.bounds.width * 2 / 3)
        ])

        leftConstraint = bgView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8)
        rightConstraint = bgView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8)
    }
}
