//
//  LoginViewController.swift
//  PhotoPicker
//
//  Created by Эван Крошкин on 22.03.22.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = Constants.Image.darkTitle
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var emailOrNameTextField: UITextField = {
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
    
    private lazy var loginButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .blue
        button.setTitle("Log In", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 18)
        button.layer.cornerRadius = 5
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var sectionLabel: UILabel = {
        let label = UILabel()
        label.text = "----------------    OR    ----------------"
        label.textAlignment = .center
        label.textColor = .secondaryLabel
        label.font = .systemFont(ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var registrationLabel: UILabel = {
        let label = UILabel()
        label.text = "Don't have an account?"
        label.textAlignment = .center
        label.textColor = .lightGray
        label.font = .systemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var registrationButton: UIButton = {
        let button = UIButton()
        button.setTitle("Sign up.", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 14)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.isUserInteractionEnabled = true
        sectionLabel.isUserInteractionEnabled = true
        registrationLabel.isUserInteractionEnabled = true
        emailOrNameTextField.delegate = self
        passwordTextField.delegate = self
        loginButton.addTarget(self,
                              action: #selector(didTapLoginButton),
                              for: . touchUpInside)
        registrationButton.addTarget(self,
                              action: #selector(didTapRegistration),
                              for: . touchUpInside)
        setupVC()
    }
    
    @objc private func didTapLoginButton() {
        let minLength = Constants.String.minLength
        guard let emailName = emailOrNameTextField.text,
              let password = passwordTextField.text else { return }
        if password.isEmpty || emailName.isEmpty {
            return alertLogin(error: "Fill in all fields")}
        else if password.count < minLength {
            return alertLogin(error: "Lenght of password is less than \(minLength) charcters")
        }
        var userName: String?
        var email: String?
        if emailName.contains("@"), emailName.contains(".") {
            email = emailName
        } else {
            userName = emailName
        }
        AuthManager.shared.loginUser(userName: userName,
                                     email: email,
                                     password: password) { success in
            DispatchQueue.main.async {
                if success {
                    self.dismiss(animated: true, completion: nil)
                } else {
                    self.alertLogin(error: "You couldn't log in, check your password or create an account")
                }
            }
        }
    }
    
    private func alertLogin(error: String) {
        let alertView = UIAlertController(title: "Oops",
                                          message: error,
                                          preferredStyle: .alert)
        alertView.addAction(UIAlertAction(title: "Dismiss",
                                          style: .cancel,
                                          handler: nil ))
        present(alertView, animated: true)
    }
    
    @objc private func didTapRegistration() {
        let registrVC = RegistrationViewController()
        let navigationVC = UINavigationController(rootViewController: registrVC)
        navigationVC.modalPresentationStyle = .fullScreen
        present(navigationVC, animated: true)
    }
    
    private func setupVC() {
        view.backgroundColor = .systemBackground
        [imageView, emailOrNameTextField, passwordTextField, loginButton, sectionLabel, stackView].forEach { view.addSubview($0) }
        [registrationLabel, registrationButton].forEach { stackView.addSubview($0) }

        imageView.topAnchor.constraint(equalToSystemSpacingBelow: view.safeAreaLayoutGuide.topAnchor,
                                       multiplier: 25).isActive = true
        imageView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        imageView.widthAnchor.constraint(equalTo: view.widthAnchor,
                                         multiplier: 0.07).isActive = true
        imageView.heightAnchor.constraint(equalTo: view.heightAnchor,
                                          multiplier: 0.07).isActive = true
        emailOrNameTextField.topAnchor.constraint(equalTo: imageView.bottomAnchor,
                                            constant: 30).isActive = true
        emailOrNameTextField.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        emailOrNameTextField.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor,
                                              multiplier: 0.9).isActive = true
        emailOrNameTextField.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor,
                                               multiplier: 0.06).isActive = true
        passwordTextField.topAnchor.constraint(equalTo: emailOrNameTextField.bottomAnchor,
                                            constant: 5).isActive = true
        passwordTextField.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        passwordTextField.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor,
                                              multiplier: 0.9).isActive = true
        passwordTextField.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor,
                                               multiplier: 0.06).isActive = true
        loginButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor,
                                            constant: 30).isActive = true
        loginButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        loginButton.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor,
                                              multiplier: 0.9).isActive = true
        loginButton.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor,
                                               multiplier: 0.06).isActive = true
        sectionLabel.topAnchor.constraint(equalTo: loginButton.bottomAnchor,
                                            constant: 15).isActive = true
        sectionLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        sectionLabel.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor,
                                              multiplier: 0.9).isActive = true
        sectionLabel.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor,
                                               multiplier: 0.06).isActive = true
        stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor,
                                            constant: -30).isActive = true
        stackView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        stackView.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor,
                                               multiplier: 0.08).isActive = true
        stackView.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor,
                                              multiplier: 0.6).isActive = true
        registrationLabel.bottomAnchor.constraint(equalTo: stackView.bottomAnchor).isActive = true
        registrationLabel.heightAnchor.constraint(equalTo: stackView.safeAreaLayoutGuide.heightAnchor,
                                               multiplier: 1).isActive = true
        registrationButton.leadingAnchor.constraint(equalTo: registrationLabel.trailingAnchor,
                                                    constant: 5).isActive = true
        registrationButton.bottomAnchor.constraint(equalTo: stackView.bottomAnchor).isActive = true
        registrationButton.heightAnchor.constraint(equalTo: stackView.safeAreaLayoutGuide.heightAnchor,
                                               multiplier: 1).isActive = true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case emailOrNameTextField:
            passwordTextField.becomeFirstResponder()
        case passwordTextField:
            passwordTextField.resignFirstResponder()
            self.didTapLoginButton()
        default:
            passwordTextField.resignFirstResponder()
        }
        return false
    }

}
