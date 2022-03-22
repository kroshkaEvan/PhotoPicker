//
//  SettingsViewController.swift
//  PhotoPicker
//
//  Created by Эван Крошкин on 22.03.22.
//

import UIKit
import SafariServices

class SettingsViewController: UIViewController {
    private let identifier = "cell"
    private var data = [[SettingsCellModel]]()
    private lazy var tableView: UITableView = {
        var tableView = UITableView(frame: .zero,
                                    style: .grouped)
        tableView.register(UITableViewCell.self,
                           forCellReuseIdentifier: self.identifier)
        tableView.backgroundColor = Constants.Colors.appMainColor
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        configModel()
        setupVC()
    }
    
    private func setupVC() {
        view.addSubview(tableView)
        tableView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        tableView.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
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
                    
                }
            }
        }
    }
    
    private func didTapAccount() {
//        let vc = EditProfileViewController()
//        let navigationVC = UINavigationController(rootViewController: vc)
//        navigationVC.modalPresentationStyle = .fullScreen
//        present(navigationVC, animated: true)
    }
        
    enum SettingsURLType {
        case terms, help
    }
    
    private func openURL(_ type: SettingsURLType) {
        let urlString: String
        switch type {
        case .terms : urlString = "https://help.instagram.com/1215086795543252?helpref=page_content"
        case .help : urlString = "https://help.instagram.com"
        }
        guard let url = URL(string: urlString) else {
            return
        }
        
        let safaryVC = SFSafariViewController(url: url)
        present(safaryVC, animated: true)
    }
    
    
    
    private func configModel() {
        let sectionLogOut = [SettingsCellModel(title: "Log out") { [weak self] in
            self?.didTapLogOut()
        }]
        
        let sectionAccount = [
            SettingsCellModel(title: "My account") { [weak self] in
                self?.didTapAccount()
            }]
        
        let sectionInfo = [
            SettingsCellModel(title: "Info") { [weak self] in
                self?.openURL(.terms)
            },
            SettingsCellModel(title: "Help") { [weak self] in
                self?.openURL(.help)
            }]
        
        [sectionLogOut, sectionAccount, sectionInfo].forEach { data.append($0) }
    }
}

extension SettingsViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell",
                                                 for: indexPath)
        
        cell.textLabel?.text = data[indexPath.section][indexPath.row].title
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath,
                              animated: true)
        data[indexPath.section][indexPath.row].handler()
    }
    
    
}
