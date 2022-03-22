//
//  ProfileViewController.swift
//  PhotoPicker
//
//  Created by Эван Крошкин on 22.03.22.
//

import UIKit
import SafariServices

class ProfileViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationItem()
    }
    
    private func setupNavigationItem() {
        let rightBarButtonItemSettings = UIBarButtonItem(image: Constants.Image.infoImage,
                                                         style: .done,
                                                         target: self,
                                                         action: #selector(presentActionSheet))
        rightBarButtonItemSettings.tintColor = .label
        navigationItem.setRightBarButtonItems([rightBarButtonItemSettings],
                                              animated: true)
    }
    
    @objc private func presentActionSheet() {
        let actionSheet = UIAlertController(title: "Settings",
                                            message: "",
                                            preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Help",
                                            style: .default,
                                            handler: { [weak self] _ in self?.openURL(.help)}))
        actionSheet.addAction(UIAlertAction(title: "Web page",
                                            style: .default,
                                            handler: { [weak self] _ in self?.openURL(.webVersion)}))
        actionSheet.addAction(UIAlertAction(title: "Log Out",
                                            style: .destructive,
                                            handler: { [weak self] _ in self?.alertLogOut()}))
        actionSheet.addAction(UIAlertAction(title: "Back",
                                            style: .cancel,
                                            handler: nil))
        actionSheet.modalPresentationStyle = .currentContext
        present(actionSheet, animated: true)
    }
    
    private func alertLogOut() {
        let alertLogOut = UIAlertController(title: "Log out of your account?",
                                            message: "",
                                            preferredStyle: .alert)
        alertLogOut.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alertLogOut.addAction(UIAlertAction(title: "Log out",
                                            style: .destructive,
                                            handler: { [weak self] _ in self?.didTapLogOut()}))
        present(alertLogOut, animated: true)
    }
    
    private func didTapLogOut(){
        AuthManager.shared.getLogOut { [weak self] successLogOut in
            DispatchQueue.main.async {
                if successLogOut {
                    let loginVC = LoginViewController()
                    loginVC.modalPresentationStyle = .fullScreen
                    self?.present(loginVC, animated: true) {
                        self?.navigationController?.popToRootViewController(animated: true)
                        self?.tabBarController?.selectedIndex = 0
                    }
                } else {
                    print("User don't log out")
                }
            }
        }
    }

    enum SettingsURLType {
        case webVersion, help
    }
    
    private func openURL(_ type: SettingsURLType) {
        let urlString: String
        switch type {
        case .webVersion : urlString = "https://photoeditorpro.com/"
        case .help : urlString = "https://www.linkedin.com/in/ivan-tsvetkov-44a25a233/"
        }
        guard let url = URL(string: urlString) else {
            return
        }
        let safaryVC = SFSafariViewController(url: url)
        present(safaryVC, animated: true)
    }
}
