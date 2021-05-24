//
//  AppDelegate.swift
//  Demo-Comma
//
//  Created by develotex
//  Copyright (c) 2021 develotex. All rights reserved.

import UIKit.UIWindow
import Comma
import PushKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  var window: UIWindow?
  private var commaManager: CommaManager!
  
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    return true
  }
  
  func applicationDidEnterBackground(_ application: UIApplication) {
    if commaManager == nil {
      self.commaManager.closeConnection()
      self.commaManager = nil
    }
  }
  
  func applicationDidBecomeActive(_ application: UIApplication) {
    if commaManager == nil {
      configureComma()
    }
  }
  
  //MARK: - Configure Comma
  func configureComma() {
    commaManager = CommaManager.shared
    if let deviceSecret = getDeviceSecret(),
       let deviceId = getDeviceId() {
      //auto auth
      commaManager.configureService(withDeviceSecret: deviceSecret, deviceId: deviceId, voipToken: nil, isApnsSandbox: true)
    }
  }
}

extension AppDelegate {
  func pushRegistry(_ registry: PKPushRegistry, didReceiveIncomingPushWith payload: PKPushPayload, for type: PKPushType, completion: @escaping () -> Void) {
    if type == .voIP {
      commaManager.didReceiveIncomingPushWith(dictionaryPayload: payload.dictionaryPayload, withCallKit: true)
    }
  }
}
