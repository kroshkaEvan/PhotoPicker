//
//  RegistrationViewController.swift
//  PhotoPicker
//
//  Created by Эван Крошкин on 22.03.22.
//

import UIKit

class RegistrationViewController: UIViewController, UITextFieldDelegate {
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = Constants.Image.iconTitle
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var helperLabel: UILabel = {
        let label = UILabel()
        label.text = "Choose a username for your new account."
        label.textAlignment = .center
        label.textColor = .lightGray
        label.numberOfLines = 2
        label.font = .systemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var nameTextField: UITextField = {
        let textField = UITextField()
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        textField.returnKeyType = .next
        textField.layer.borderWidth = 2
        textField.layer.borderColor = UIColor.lightGray.cgColor
        textField.layer.cornerRadius = 5
        textField.attributedPlaceholder = NSAttributedString(
            string: "Name",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray]
        )
        textField.textColor = .label
        textField.leftViewMode = .always
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 8, height: 0))
        textField.backgroundColor = .lightGray.withAlphaComponent(0.2)
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private lazy var emailTextField: UITextField = {
        let textField = UITextField()
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        textField.returnKeyType = .next
        textField.keyboardType = .emailAddress
        textField.layer.borderWidth = 2
        textField.layer.borderColor = UIColor.lightGray.cgColor
        textField.layer.cornerRadius = 5
        textField.attributedPlaceholder = NSAttributedString(
            string: "Email address",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray]
        )
        textField.textColor = .label
        textField.leftViewMode = .always
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 8, height: 0))
        textField.backgroundColor = .lightGray.withAlphaComponent(0.2)
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private lazy var passwordTextField: UITextField = {
        let textField = UITextField()
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        textField.returnKeyType = .done
        textField.keyboardType = .numbersAndPunctuation
        textField.layer.borderWidth = 2
        textField.layer.borderColor = UIColor.lightGray.cgColor
        textField.layer.cornerRadius = 5
        textField.attributedPlaceholder = NSAttributedString(
            string: "Password",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray]
        )
        textField.textColor = .label
        textField.leftViewMode = .always
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 8, height: 0))
        textField.backgroundColor = .lightGray.withAlphaComponent(0.2)
        textField.isSecureTextEntry = true
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private lazy var registrationButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .blue
        button.setTitle("Sign up", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 18)
        button.layer.cornerRadius = 5
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Create new username"
        nameTextField.delegate = self
        emailTextField.delegate = self
        passwordTextField.delegate = self
        registrationButton.addTarget(self,
                                     action: #selector(didTapRegistration),
                                     for: . touchUpInside)
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back",
                                                           style: .done,
                                                           target: self,
                                                           action: #selector(didTapBack))
        navigationItem.leftBarButtonItem?.tintColor = .label
        setupVC()
    }
    
    private func alertLogin(error: String) {
        let alertView = UIAlertController(title: "Uh - oh",
                                          message: error,
                                          preferredStyle: .alert)
        alertView.addAction(UIAlertAction(title: "Dismiss",
                                          style: .cancel,
                                          handler: nil ))
        present(alertView, animated: true)
    }
    
    @objc private func didTapRegistration() {
        guard let username = nameTextField.text,
              let email = emailTextField.text,
              let password = passwordTextField.text else { return }
        let minLength = Constants.String.minLength
        if password.isEmpty || email.isEmpty || username.isEmpty {
            return alertLogin(error: "Fill in all fields")}
        else if password.count < minLength {
            return alertLogin(error: "Lenght of password is less than \(minLength) charcters")
        }
        AuthManager.shared.registrationNewUser(userName: username,
                                               email: email,
                                               password: password) { [weak self] successfulRegistration in
            DispatchQueue.main.async {
                if successfulRegistration {
                    let mainVC = MainViewController()
                    self?.present(mainVC, animated: true)
                } else {
                    self?.alertLogin(error: "The mail is already busy")
                    print("error registration")
                }
            }
        }
    }
    
    @objc private func didTapBack() {
        dismiss(animated: true, completion: nil)
    }
    
    private func setupVC() {
        view.backgroundColor = .systemBackground
        [imageView, helperLabel, nameTextField, emailTextField, passwordTextField, registrationButton].forEach { view.addSubview($0) }
        imageView.topAnchor.constraint(equalToSystemSpacingBelow: view.safeAreaLayoutGuide.topAnchor,
                                       multiplier: 25).isActive = true
        imageView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        imageView.widthAnchor.constraint(equalTo: view.widthAnchor,
                                         multiplier: 0.07).isActive = true
        imageView.heightAnchor.constraint(equalTo: view.heightAnchor,
                                          multiplier: 0.07).isActive = true
        helperLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor,
                                         constant: 30).isActive = true
        helperLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        helperLabel.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor,
                                             multiplier: 0.9).isActive = true
        helperLabel.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor,
                                              multiplier: 0.1).isActive = true
        nameTextField.topAnchor.constraint(equalTo: helperLabel.bottomAnchor,
                                           constant: 5).isActive = true
        nameTextField.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        nameTextField.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor,
                                             multiplier: 0.9).isActive = true
        nameTextField.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor,
                                              multiplier: 0.06).isActive = true
        emailTextField.topAnchor.constraint(equalTo: nameTextField.bottomAnchor,
                                            constant: 5).isActive = true
        emailTextField.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        emailTextField.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor,
                                              multiplier: 0.9).isActive = true
        emailTextField.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor,
                                               multiplier: 0.06).isActive = true
        passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor,
                                               constant: 5).isActive = true
        passwordTextField.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        passwordTextField.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor,
                                                 multiplier: 0.9).isActive = true
        passwordTextField.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor,
                                                  multiplier: 0.06).isActive = true
        registrationButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor,
                                                constant: 30).isActive = true
        registrationButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        registrationButton.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor,
                                                  multiplier: 0.9).isActive = true
        registrationButton.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor,
                                                   multiplier: 0.06).isActive = true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case nameTextField:
            emailTextField.becomeFirstResponder()
            helperLabel.text = "Enter your email"
            self.title = "Enter your email"
        case emailTextField:
            passwordTextField.becomeFirstResponder()
            helperLabel.text = "We can remember the password, so you won't need to enter it on your iCloud devices."
            self.title = "Сreate new password"
        case passwordTextField:
            passwordTextField.resignFirstResponder()
            self.didTapRegistration()
        default:
            passwordTextField.resignFirstResponder()
        }
        return false
    }
}
