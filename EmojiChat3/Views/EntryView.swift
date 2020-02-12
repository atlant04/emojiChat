//
//  EntryView.swift
//  EmojiChat3
//
//  Created by MacBook on 2/11/20.
//  Copyright © 2020 MT. All rights reserved.
//

import Foundation
import UIKit

class EntryView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(segmentedControl)
        addSubview(stackView)
        addSubview(button)
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    lazy var stackView: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.distribution = .fillEqually
        stack.spacing = 1
        stack.alignment = .fill
        stack.axis = .vertical
        stack.addArrangedSubview(self.nameTextField)
        stack.addArrangedSubview(self.emailTextField)
        stack.addArrangedSubview(self.passwordTextField)
        return stack
    }()

    var button: UIButton = {
        let btn = UIButton()
        btn.backgroundColor = .white
        btn.layer.cornerRadius = 16
        btn.backgroundColor = (btn.state == .normal) ? .white : .purple
        btn.setTitleColor(.purple, for: .normal)
        btn.setTitleColor(.white, for: .highlighted)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitle("Sign up", for: .normal)
        return btn
    }()

    lazy var segmentedControl: UISegmentedControl = {
        let sc = UISegmentedControl(items: ["Login", "Sign Up"])
        sc.translatesAutoresizingMaskIntoConstraints = false
        sc.backgroundColor = .white
        sc.selectedSegmentTintColor = .purple
        sc.selectedSegmentIndex = 1
        return sc
    }()

    var emailTextField: UITextField = {
        let tf = UITextField()
        tf.backgroundColor = .white
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.placeholder = "Enter email"
        return tf
    }()

    var passwordTextField: UITextField = {
        let tf = UITextField()
        tf.backgroundColor = .white
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.placeholder = "Enter Password"
        return tf
    }()

    var nameTextField: UITextField = {
        let tf = UITextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.backgroundColor = .white
        tf.placeholder = "Enter your name"
        return tf
    }()

    func setupConstraints() {
        NSLayoutConstraint.activate([
            segmentedControl.topAnchor.constraint(equalTo: topAnchor),
            segmentedControl.leadingAnchor.constraint(equalTo: leadingAnchor),
            segmentedControl.trailingAnchor.constraint(equalTo: trailingAnchor),
            segmentedControl.bottomAnchor.constraint(equalTo: stackView.topAnchor, constant: -16),
            segmentedControl.heightAnchor.constraint(equalToConstant: 50),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: button.topAnchor, constant: -16),
            button.leadingAnchor.constraint(equalTo: leadingAnchor),
            button.trailingAnchor.constraint(equalTo: trailingAnchor),
            button.bottomAnchor.constraint(equalTo: bottomAnchor),
            button.heightAnchor.constraint(equalToConstant: 50)
        ])
    }

}
