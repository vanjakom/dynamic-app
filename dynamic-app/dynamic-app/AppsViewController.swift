//
//  AppsViewController.swift
//  dynamic-app
//
//  Created by Vanja Komadinovic on 9/27/16.
//  Copyright © 2016 mungolab.com. All rights reserved.
//

import Foundation
import UIKit

class AppCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel! = nil
}

class AppsViewController: UITableViewController {
    lazy var apps: [App] = {
        let appsLoader = AppsLoader()
        return appsLoader.getApps()
    }()
    
    override func viewDidLoad() {
        self.navigationItem.title = nil
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.apps.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let app = self.apps[indexPath.row]
        
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "AppCell") as! AppCell
        
        cell.nameLabel.text = app.appName
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // todo start app
        print("Starting app: \(self.apps[indexPath.row].appName)")
        
        let appStateMachine = AppStateMachine(app: self.apps[indexPath.row], navigationController: self.navigationController!)
        
        appStateMachine.reactOnAction(action: HomeAction(), state: Dictionary())
    }
}
