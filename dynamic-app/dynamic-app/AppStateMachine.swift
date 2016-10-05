//
//  AppStateMachine.swift
//  dynamic-app
//
//  Created by Vanja Komadinovic on 9/28/16.
//  Copyright © 2016 mungolab.com. All rights reserved.
//

import Foundation
import UIKit

class AppStateMachine {
    let app: App
    let navigationController: UINavigationController
    var rootViewController: UIViewController?
    let client: DynamicAppClient
    
    init(app: App, navigationController: UINavigationController) {
        self.app = app
        self.client = DynamicAppClient()
        self.navigationController = navigationController
    }
    
    func reactOnAction(action: Action, state: Dictionary<String, AnyObject>) {
        switch action {
        case is ExitAction:
            if let rootViewController = self.rootViewController {
                self.navigationController.popToViewController(rootViewController, animated: false)
            } else {
               print("Exit action but not started app")
            }
        case is HomeAction:
            if let rootViewController = self.rootViewController {
                self.navigationController.popToViewController(rootViewController, animated: false)
            } else {
                self.rootViewController = self.navigationController.visibleViewController
            }
            DynamicAppClient.request(appUri: self.app.appUrl, action: "index", state: state, handler: reactOnResponse)
        case is ReturnAction:
            self.navigationController.popViewController(animated: false)
        case is CustomAction:
            DynamicAppClient.request(appUri: self.app.appUrl, action: (action as! CustomAction).action, state: state, handler: reactOnResponse)
        default:
            print("unknown action")
        }
    }
    
    func reactOnResponse(response: DynamicAppResponse?) -> Void {
        print("Response from server")
        
        if let response = response {
            switch response.render {
            case is List:
                let listVC = self.navigationController.storyboard?.instantiateViewController(withIdentifier: "ListViewController") as! ListViewController
                listVC.elements = (response.render as! List).elements
                listVC.state = response.state
                listVC.appStateMachine = self
                
                self.navigationController.pushViewController(listVC, animated: false)
            default:
                print("Unknown element")
            }
        }
    }
}
