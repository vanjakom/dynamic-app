//
//  ListViewController.swift
//  dynamic-app
//
//  Created by Vanja Komadinovic on 9/29/16.
//  Copyright © 2016 mungolab.com. All rights reserved.
//

import Foundation
import UIKit

class DiscloseCellUI: UITableViewCell {
    @IBOutlet weak var label: UILabel! = nil
}

class LabelCellUI: UITableViewCell {
    @IBOutlet weak var label: UILabel! = nil
}

class TextCellUI: UITableViewCell {
    @IBOutlet weak var textField: UITextField! = nil
}

class ListViewController: UITableViewController {
    var elements: [ListElement]! = []
    var appStateMachine: AppStateMachine! = nil
    // todo, see how to support dynamic state
    // static state provided once
    var state: Dictionary<String, AnyObject> = Dictionary()
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.elements.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let element = self.elements[indexPath.row]
        
        let cell: UITableViewCell
        
        switch element {
        case is DiscloseCell:
            let reusableCell = self.tableView.dequeueReusableCell(withIdentifier: "DiscloseCellUI") as! DiscloseCellUI
            reusableCell.label.text = (element as! DiscloseCell).text
            cell = reusableCell
        case is TextCell:
            let reusableCell = self.tableView.dequeueReusableCell(withIdentifier: "TextCellUI") as! TextCellUI
            // use tag to find out which text is entered
            reusableCell.textField.tag = indexPath.row
            if let stateVar = (element as! TextCell).stateVar {
                if let text = self.state[stateVar] as? String {
                    reusableCell.textField.text = text
                }
            } else {
                reusableCell.textField.text = nil
            }
            if let placeholderText = (element as! TextCell).placeholderText {
                reusableCell.textField.placeholder = placeholderText
            } else {
                reusableCell.textField.placeholder = nil
            }
            cell = reusableCell
        case is LabelCell:
            let reusableCell = self.tableView.dequeueReusableCell(withIdentifier: "LabelCellUI") as! LabelCellUI
            reusableCell.label.text = (element as! LabelCell).text
            cell = reusableCell
        default:
            let reusableCell = self.tableView.dequeueReusableCell(withIdentifier: "LabelCellUI") as! LabelCellUI
            reusableCell.label.text = "unknown cell type"
            cell = reusableCell
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let element = self.elements[indexPath.row]
        switch element {
        case is OnDiscloseAction:
            if let action = (element as! OnDiscloseAction).onDisclose {
                self.appStateMachine.reactOnAction(action: action, state: self.state)
            }
        default:
            ()
        }
    }
    
    @IBAction func textEntered(sender: UITextField) {
        sender.resignFirstResponder()
        
        let index = sender.tag
        let cell: TextCell = self.elements[index] as! TextCell
        
        if let stateVar = cell.stateVar {
            self.state[stateVar] = sender.text as AnyObject?
        }
    }
}
