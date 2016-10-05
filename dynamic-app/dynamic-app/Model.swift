//
//  Model.swift
//  dynamic-app
//
//  Created by Vanja Komadinovic on 9/28/16.
//  Copyright © 2016 mungolab.com. All rights reserved.
//

import Foundation

class App {
    let appName: String
    let appUrl: String
    
    init(appName: String, appUrl: String) {
        self.appName = appName
        self.appUrl = appUrl
    }
}

class Element {
    
}

class ListElement: Element {
    
}

protocol OnDiscloseAction: class {
    var onDisclose: Action? { get }
}

class DiscloseCell: ListElement, OnDiscloseAction {
    let text: String
    let onDisclose: Action?
    
    init(text: String, onDisclose: Action?) {
        self.text = text
        self.onDisclose = onDisclose
    }
    
    convenience init(dictionary: Dictionary<String, AnyObject>) {
        let text = dictionary["text"] as! String
        let onDisclose: Action?
        if let onDiscloseDict = dictionary["on-disclose"] as? Dictionary<String,AnyObject> {
            onDisclose = ActionFactory.createAction(actionDict: onDiscloseDict)
        } else {
            onDisclose = nil
        }
        self.init(text: text, onDisclose: onDisclose)
    }
}

class LabelCell: ListElement {
    let text: String
    
    init(text: String) {
        self.text = text
    }
    
    convenience init(dictionary: Dictionary<String, AnyObject>) {
        let text = dictionary["text"] as! String
        self.init(text: text)
    }
}

class TextCell: ListElement {
    let placeholderText: String?
    let stateVar: String?
    
    init(placeholderText: String?, stateVar: String?) {
        self.placeholderText = placeholderText
        self.stateVar = stateVar
    }
    
    convenience init(dictionary: Dictionary<String, AnyObject>) {
        let placeholderText = dictionary["placeholder"] as? String
        let stateVar = dictionary["state-var"] as? String
        
        self.init(placeholderText: placeholderText, stateVar: stateVar)
    }
}

class List: Element {
    let elements: [ListElement]
    
    init(elements: [ListElement]) {
        self.elements = elements
    }
}

// todo
class UnknownCell: ListElement {
    
}

class Action {
    
}

class CustomAction: Action {
    let action: String
    
    init(action: String) {
        self.action = action
    }
}

class HomeAction: Action {

}

class ReturnAction: Action {
    
}

class ExitAction: Action {
    
}

class ActionFactory {
    class func createAction(actionDict: Dictionary<String,AnyObject>) -> Action {
        let action = actionDict["action"] as! String
        
        switch action {
        case "#exit":
            return ExitAction()
        case "#return":
            return ReturnAction()
        case "#home":
            return HomeAction()
        default:
            return CustomAction(action: action)
        }
    }
}

class ElementUIFactory {
    class func createElement(elementDictionary: Dictionary<String, AnyObject>) -> Element {
        let type = elementDictionary["type"] as! String
        
        switch type {
        case "text-cell":
            return TextCell(dictionary: elementDictionary)
        case "disclose-cell":
            return DiscloseCell(dictionary: elementDictionary)
        case "label-cell":
            return LabelCell(dictionary: elementDictionary)
        default:
            return UnknownCell()
        }
    }
    
    class func createListElements(elementsDictionary: Array<Dictionary<String, AnyObject>>) -> List {
        let elements = elementsDictionary.map { (elementDictionary) -> ListElement in
            return ElementUIFactory.createElement(elementDictionary: elementDictionary) as! ListElement
        }
        
        return List(elements: elements)
    }
}






