//
//  SettingViewController.swift
//  WebsocketProject
//
//  Created by 宇宣 Chen on 2022/2/27.
//

import UIKit
import MaterialComponents.MaterialSnackbar

class SettingViewController: UIViewController {
    
    var countryVMs = [CollectionItemViewModel]()
    let db = DatabaseService.shared
    
    let tableView = UITableView()
    let snackMessage = MDCSnackbarMessage()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        countryVMs = db.sort(isAscending: true)
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
        MDCSnackbarManager.default.snackbarMessageViewBackgroundColor = .systemBlue
        
    }
    
    @objc func save() {
        if let selectedRows = tableView.indexPathsForSelectedRows {
            
            DispatchQueue.main.async {
                
                do {
                    try self.db.storeSetting(iPath: selectedRows)
                    self.snackMessage.text = "更新成功"
                    self.countryVMs = self.db.sort(isAscending: true)
                    self.tableView.reloadData()
                
                }
                catch RealmError.write {
                    self.snackMessage.text = "更新失敗"
                }
                catch {
                    print("我是誰")
                }

                MDCSnackbarManager.default.show(self.snackMessage)
            }
        }
    }
}

extension SettingViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.countryVMs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        if (countryVMs[indexPath.row].favorite == 0) {
            cell.accessoryType = .checkmark
        }
        else {
            cell.accessoryType = .none
        }
        
        cell.textLabel?.text = countryVMs[indexPath.row].name
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

