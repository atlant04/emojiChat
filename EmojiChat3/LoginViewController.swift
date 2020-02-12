//
//  LoginViewController.swift
//  EmojiChat3
//
//  Created by MacBook on 2/11/20.
//  Copyright © 2020 MT. All rights reserved.
//

import Foundation
import UIKit
import FirebaseAuth
import FirebaseDatabase

class LoginViewController: UIViewController {

    let entryView = EntryView()
    var entryViewHeightConstraint: NSLayoutConstraint!

    override func viewDidLoad() {
        super.viewDidLoad()

        entryView.segmentedControl.addTarget(self, action: #selector(handleSegmentedControl), for: .valueChanged)
        entryView.button.addTarget(self, action: #selector(handleLoginSingUp), for: .touchUpInside)

        view.backgroundColor = .purple
        entryView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(entryView)
        setupSubviews()
    }

    @objc func handleLoginSingUp(sender: UIButton) {
        if entryView.segmentedControl.selectedSegmentIndex == 1 {
            signUp()
        } else {
            login()
        }
    }

    func signUp() {
        guard let name = entryView.nameTextField.text,
            let email = entryView.emailTextField.text,
            let password = entryView.passwordTextField.text
            else { return }
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error = error { print(error) } //present alert that user already exists
            guard let uid = result?.user.uid else { return }
            let ref = Database.database().reference().child("users").child(uid)
            ref.setValue(["name": name, "email": email])
            let user = User(uid: uid, email: email, name: name)
            self.presentViewController(with: user )
        }

    }

    func login() {
        guard let email = entryView.emailTextField.text,
            let password = entryView.passwordTextField.text
        else { return }
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let error = error { print(error) }
            if let uid = result?.user.uid {
                let ref = Database.database().reference().child("users").child(uid)
                ref.observeSingleEvent(of: .value) { snap in
                    if let user = User(snapshot: snap) {
                        self.presentViewController(with: user)
                    }
                }
            }
        }
    }

    @objc func handleSegmentedControl(sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 1 {
            entryView.stackView.arrangedSubviews[0].isHidden = false
            entryViewHeightConstraint.constant = 300
            entryView.button.setTitle("Sign up", for: .normal)
        } else {
            entryView.stackView.arrangedSubviews[0].isHidden = true
            entryViewHeightConstraint.constant = 250
            entryView.button.setTitle("Login", for: .normal)
        }
    }

    func presentViewController(with user: User) {
        let vc = ViewController()
        vc.user = user
        let navigationVC = UINavigationController(rootViewController: vc)
        navigationVC.modalPresentationStyle = .fullScreen
        self.present(navigationVC, animated: true)
    }

}

extension LoginViewController {

    func setupSubviews() {
        entryViewHeightConstraint = entryView.heightAnchor.constraint(equalToConstant: 300)
        entryViewHeightConstraint.isActive = true
        NSLayoutConstraint.activate([
            entryView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -100),
            entryView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            entryView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width * 0.75)
        ])
    }
}
