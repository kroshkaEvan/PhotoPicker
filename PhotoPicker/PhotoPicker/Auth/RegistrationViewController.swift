//
//  RegistrationViewController.swift
//  PhotoPicker
//
//  Created by Эван Крошкин on 22.03.22.
//

import UIKit

class RegistrationViewController: UIViewController, UITextFieldDelegate {
    private lazy var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.alwaysBounceVertical = true
        view.backgroundColor = .clear
        view.bounces = false
        view.showsVerticalScrollIndicator = false
        return view
    }()
    
    private lazy var contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = Constants.Image.iconTitle
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var helperLabel: UILabel = {
        let label = UILabel()
        label.text = Constants.Strings.chooseName
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
        textField.keyboardType = .default
        textField.layer.borderWidth = 2
        textField.layer.borderColor = UIColor.lightGray.cgColor
        textField.layer.cornerRadius = 5
        textField.attributedPlaceholder = NSAttributedString(
            string: Constants.Strings.name,
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
            string: Constants.Strings.email,
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
            string: Constants.Strings.passwordPlaceholder,
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
        button.setTitle(Constants.Strings.signUp, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 18)
        button.layer.cornerRadius = 5
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    var activeTextField: UITextField?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = Constants.Strings.newUser
        registrationButton.addTarget(self,
                                     action: #selector(didTapRegistration),
                                     for: . touchUpInside)
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: Constants.Strings.back,
                                                           style: .done,
                                                           target: self,
                                                           action: #selector(didTapBack))
        navigationItem.leftBarButtonItem?.tintColor = .darkGray
        let tap = UITapGestureRecognizer(target: self,
                                         action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
        setupVC()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        nameTextField.delegate = self
        emailTextField.delegate = self
        passwordTextField.delegate = self
        let center = NotificationCenter.default
        center.addObserver(self,
                           selector: #selector(willShowKeyboard),
                           name: UIResponder.keyboardWillShowNotification,
                           object: nil)
        center.addObserver(self,
                           selector: #selector(willHideKeyboard),
                           name: UIResponder.keyboardWillHideNotification,
                           object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        let center = NotificationCenter.default
        center.removeObserver(self,
                              name: UIResponder.keyboardWillShowNotification,
                              object: nil)
        center.removeObserver(self,
                              name: UIResponder.keyboardWillHideNotification,
                              object: nil)
    }
    
    @objc func willShowKeyboard(notification: Notification) {
        guard let keyboard = notification.userInfo else {return}
        if let keyboardSize = (keyboard[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.size {
            let hiegth = keyboardSize.height - (view.frame.height / 5)
            let contentInsets = UIEdgeInsets(top: 0,
                                             left: 0,
                                             bottom: hiegth,
                                             right: 0)
            self.scrollView.contentInset = contentInsets
            let view = self.view.frame
            guard let activeTextField = self.activeTextField else {return}
            if (view.contains(activeTextField.frame.origin)) {
                let scrollPoint = CGPoint(x: 0,
                                          y: activeTextField.frame.origin.y + hiegth)
                self.scrollView.setContentOffset(scrollPoint, animated: true)
            }
        }
    }
    
    @objc func willHideKeyboard(notification: Notification) {
        let contentInsets = UIEdgeInsets.zero
        scrollView.contentInset = contentInsets
    }
    
    @objc private func dismissKeyboard() {
        self.view.endEditing(true)
    }
    
    private func alertLogin(error: String) {
        let alertView = UIAlertController(title: Constants.Strings.uhOh,
                                          message: error,
                                          preferredStyle: .alert)
        alertView.addAction(UIAlertAction(title: Constants.Strings.cancel,
                                          style: .cancel,
                                          handler: nil ))
        present(alertView, animated: true)
    }
    
    @objc private func didTapRegistration() {
        guard let username = nameTextField.text,
              let email = emailTextField.text,
              let password = passwordTextField.text else { return }
        let minLength = Constants.Strings.minLength
        if password.isEmpty || email.isEmpty || username.isEmpty {
            return alertLogin(error: Constants.Strings.errorAllFields)}
        else if password.count < minLength {
            return alertLogin(error: Constants.Strings.errorPassword)
        }
        AuthManager.shared.registrationNewUser(userName: username,
                                               email: email,
                                               password: password) { [weak self] successfulRegistration in
            let mainVC = MainViewController()
            mainVC.modalPresentationStyle = .fullScreen
            self?.present(mainVC, animated: true)
        }
    }
    
    @objc private func didTapBack() {
        dismiss(animated: true, completion: nil)
    }
    
    private func setupVC() {
        view.backgroundColor = .white
        view.addSubview(scrollView)
        self.activeTextField = UITextField()
        scrollView.addSubview(contentView)
        [imageView, helperLabel, nameTextField, emailTextField, passwordTextField, registrationButton].forEach { contentView.addSubview($0) }
        scrollView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        scrollView.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor).isActive = true
        scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        contentView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        contentView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
        contentView.heightAnchor.constraint(equalTo: scrollView.heightAnchor).isActive = true
        imageView.topAnchor.constraint(equalToSystemSpacingBelow: contentView.topAnchor,
                                       multiplier: 5).isActive = true
        imageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 180).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 180).isActive = true
        helperLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor,
                                         constant: 5).isActive = true
        helperLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        helperLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor,
                                           multiplier: 0.9).isActive = true
        helperLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        nameTextField.topAnchor.constraint(equalTo: helperLabel.bottomAnchor,
                                           constant: 5).isActive = true
        nameTextField.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        nameTextField.widthAnchor.constraint(equalTo: contentView.widthAnchor,
                                             multiplier: 0.9).isActive = true
        nameTextField.heightAnchor.constraint(equalToConstant: 44).isActive = true
        emailTextField.topAnchor.constraint(equalTo: nameTextField.bottomAnchor,
                                            constant: 5).isActive = true
        emailTextField.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        emailTextField.widthAnchor.constraint(equalTo: contentView.widthAnchor,
                                              multiplier: 0.9).isActive = true
        emailTextField.heightAnchor.constraint(equalToConstant: 44).isActive = true
        passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor,
                                               constant: 5).isActive = true
        passwordTextField.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        passwordTextField.widthAnchor.constraint(equalTo: contentView.widthAnchor,
                                                 multiplier: 0.9).isActive = true
        passwordTextField.heightAnchor.constraint(equalToConstant: 44).isActive = true
        registrationButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor,
                                                constant: 30).isActive = true
        registrationButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        registrationButton.widthAnchor.constraint(equalTo: contentView.widthAnchor,
                                                  multiplier: 0.9).isActive = true
        registrationButton.heightAnchor.constraint(equalToConstant: 44).isActive = true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case nameTextField:
            emailTextField.becomeFirstResponder()
            helperLabel.text = Constants.Strings.email
            self.title = Constants.Strings.email
        case emailTextField:
            passwordTextField.becomeFirstResponder()
            helperLabel.text = Constants.Strings.newPassword
            self.title = Constants.Strings.newPassword
        case passwordTextField:
            passwordTextField.resignFirstResponder()
            self.didTapRegistration()
            self.activeTextField = nil
        default:
            passwordTextField.resignFirstResponder()
        }
        return false
    }
}
