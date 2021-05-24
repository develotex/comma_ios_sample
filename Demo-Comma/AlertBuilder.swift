//
//  AlertFactory.swift
//  Comma_Example
//
//  Created by develotex
//  Copyright (c) 2021 develotex. All rights reserved.

import UIKit

protocol AlertsBuilder: AnyObject {
  func buildLoginAlert(completion: @escaping (Int) -> ()) -> UIViewController
  func buildCallAlert(hasVideo:Bool, completion: @escaping (String) -> ()) -> UIViewController
  func buildDeleteAlert(completion: @escaping () -> ()) -> UIViewController
}

class AlertsBuilderImpl: AlertsBuilder {
  
  func buildLoginAlert(completion: @escaping (Int) -> ()) -> UIViewController {
    let alertController = UIAlertController(title: "Login", message: "Enter user id", preferredStyle: .alert)
    alertController.addTextField { (textField) in
      textField.text = ""
      textField.keyboardType = .decimalPad
    }
    alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alertController] (_) in
      let textField = alertController?.textFields!.first
      guard let text = textField?.text else { return }
      let numData = (text as NSString).integerValue
      completion(numData)
    }))
    alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
    return alertController
  }
  
  func buildCallAlert(hasVideo:Bool, completion: @escaping (String) -> ()) -> UIViewController {
    let alertController = UIAlertController(title: hasVideo == true ? "Video Call" : "Call", message: "Enter callee user id", preferredStyle: .alert)
    alertController.addTextField { (textField) in
      textField.text = ""
      textField.keyboardType = .numberPad
    }
    alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alertController] (_) in
      let textField = alertController?.textFields!.first
      guard let text = textField?.text else { return }
      completion(text)
    }))
    alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
    return alertController
  }
  
  func buildDeleteAlert(completion: @escaping () -> ()) -> UIViewController {
    let alertController = UIAlertController(title: "Delete User", message: "", preferredStyle: .alert)
    
    alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
      completion()
    }))
    alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
    return alertController
  }
}
