//
//  SettingViewController.swift
//  WebsocketProject
//
//  Created by 宇宣 Chen on 2022/2/27.
//

import UIKit
import MaterialComponents.MaterialSnackbar

class SettingViewController: UIViewController {
 
    var countries = [Country]() //passed data
    let tableView = UITableView()
    let snackMessage = MDCSnackbarMessage()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(countries.count)
        setup()
    }
    
    func setup(){
        view.addSubview(tableView)
        tableView.pin(to: view)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.allowsMultipleSelection = true
        
        
        //nav bar
        navigationItem.rightBarButtonItem =
            UIBarButtonItem(title: "Done",
                            style: .plain,
                            target: self,
                            action: #selector(save))
    
        //snack bar
        snackMessage.text = ""
        snackMessage.enableRippleBehavior = true
        MDCSnackbarManager.default.snackbarMessageViewBackgroundColor = .systemPurple
        
    }
    
    @objc func save() {
        if let selectedRows = tableView.indexPathsForSelectedRows {
        
            RealmManager.shared.storeSetting(iPath: selectedRows, completion: { [weak self] result in
                guard let self = self else { return }

                switch result {
                    case .success(_):
                        self.snackMessage.text = "更新成功"
                    case .failure(_):
                        self.snackMessage.text = "更新失敗"
                }
            })
        }
        
        tableView.reloadData()
        MDCSnackbarManager.default.show(snackMessage)
    }
}

extension SettingViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.countries.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        if (countries[indexPath.row].favorite == 0) {
            cell.accessoryType = .checkmark
        }
        else {
            cell.accessoryType = .none
        }
        
        cell.textLabel?.text = countries[indexPath.row].name
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
            tableView.cellForRow(at: indexPath)?.accessoryType = .none

        }
        else {
            
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        
        
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
            tableView.cellForRow(at: indexPath)?.accessoryType = .none

        }
        else {
            
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
    }
    

}

