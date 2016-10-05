//
//  AppsLoader.swift
//  dynamic-app
//
//  Created by Vanja Komadinovic on 9/27/16.
//  Copyright © 2016 mungolab.com. All rights reserved.
//

import Foundation

class AppsLoader {
    func getApps() -> [App] {
        return [
            App(appName: "TestApp", appUrl: "http://localhost:7070/apps/test")
        ]
    }
}
