////
////  ViewController.swift
////  Demo-Comma
////
//  Created by develotex
//  Copyright (c) 2021 develotex. All rights reserved.

import UIKit
import Comma

protocol CommaManagerDelegate {
  var commaManager: CommaManager? { get set }
}

class ViewController: UIViewController, CommaManagerDelegate {
  @IBOutlet weak var speakerBarButton: UIBarButtonItem!
  @IBOutlet weak var micBarButton: UIBarButtonItem!
  @IBOutlet weak var videoBarButton: UIBarButtonItem!
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var callButton: UIButton!
  @IBOutlet weak var videoCallButton: UIButton!
  @IBOutlet weak var endCallButton: UIButton!
  @IBOutlet weak var deleteButton: UIButton!
  @IBOutlet weak var loginButton: UIButton!
  
  var commaManager: CommaManager? = nil
  var alertsBuilder:AlertsBuilder!
  var hasVideo = false
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupUI()
    alertsBuilder = AlertsBuilderImpl()
    
    commaManager = CommaManager.shared
    commaManager?.register = { userId in
      DispatchQueue.main.async {
        self.titleLabel.text = "User Id: \(String(describing: userId!))"
        self.setAuthState()
      }
    }
    
    commaManager?.connectionStateDidChange =  { connectionState in
      switch connectionState {
      case .checking: print("checking")
      case .connected: print("connected")
      case .failed: print("failed")
      case .disconnected: print("disconnected")
      case .none: print("unknown")
      @unknown default: break
      }
    }
    
    commaManager?.isReceiveIncomingCall = { incomingCall in
      if incomingCall.callType == 2 { //type 1 audio //type 2 video
        self.hasVideo = true
      }
      //* Disable this if you use Voip push
      self.commaManager?.didReceiveIncomingPushWith(incomingCall: incomingCall, withCallKit: true)
      //*
    }
    
    self.commaManager?.isAnswered = { incomingCall in
      print("==Answered call==")
    }
    
    commaManager?.isCallEnded = { hasEnd in
      self.hasVideo = false
    }
    
    commaManager?.isDeleted = { _ in
      DispatchQueue.main.async {
        self.setUnAuthState()
      }
    }
  }
  
  func configure(userId:Int) {
    if let deviceSecret = getDeviceSecret(),
       let deviceId = getDeviceId() {
      //auth
      commaManager?.configureService(withDeviceSecret: deviceSecret, deviceId: deviceId, voipToken: nil, isApnsSandbox: true)
    } else {
      //register
      commaManager?.configureService(userId: userId, userName: "User_\(userId)", projectId: 2, projectApiKey: "DevProject2ApiKeyDevProject2ApiKeyDevProject2ApiKeyDevProject2Ap", voipToken: nil, isApnsSandbox: true)
    }
  }
  
  func presentVideoVC() {
    let videoController = VideoController()
    videoController.delegate = self
    videoController.modalPresentationStyle = .fullScreen
    self.navigationController?.pushViewController(videoController, animated: true)
  }
  
  @IBAction func loginButtonClicked(_ sender: Any) {
    let alert = alertsBuilder.buildLoginAlert { userID in
      self.configure(userId: userID)
    }
    present(alert, animated: true, completion: nil)
  }
  
  @IBAction func callButtonClicked(_ sender: Any) {
    let alert = alertsBuilder.buildCallAlert(hasVideo: false) { userID in
      self.commaManager?.startCall(id: userID)
    }
    present(alert, animated: true, completion: nil)
  }
  
  @IBAction func videoCallButtonClicked(_ sender: Any) {
    let alert = alertsBuilder.buildCallAlert(hasVideo: true) { userID in
      self.commaManager?.startVideoCall(id: userID)
      self.hasVideo = true
    }
    present(alert, animated: true, completion: nil)
  }
  
  @IBAction func deleteButtonClicked(_ sender: Any) {
    let alert = alertsBuilder.buildDeleteAlert {
      self.commaManager?.deleteDevice()
    }
    present(alert, animated: true, completion: nil)
  }
  
  @IBAction func endCallButtonClicked(_ sender: Any) {
    endCall()
  }
  
  private func endCall() {
    commaManager?.endCall()
  }
  
  @IBAction func presentButtonClicked(_ sender: Any) {
    presentVideoVC()
  }
  
  @IBAction func speakerBarButtonClicked(_ sender: Any) {
    if speakerBarButton.image == UIImage(systemName: "speaker.fill") {
      speakerBarButton.image = UIImage(systemName: "speaker.wave.3.fill")
      commaManager?.setSpeaker(false)
    } else {
      speakerBarButton.image = UIImage(systemName: "speaker.fill")
      commaManager?.setSpeaker(true)
    }
  }
  
  @IBAction func micBarButtonClicked(_ sender: Any) {
    if micBarButton.image == UIImage(systemName: "mic.fill") {
      micBarButton.image = UIImage(systemName: "mic.slash.fill")
      commaManager?.setMuteAudio(true)
    } else {
      micBarButton.image = UIImage(systemName: "mic.fill")
      commaManager?.setMuteAudio(false)
    }
  }
  
  @IBAction func videoBarButtonClicked(_ sender: Any) {
    if videoBarButton.image == UIImage(systemName: "video.fill") {
      videoBarButton.image = UIImage(systemName: "video.slash.fill")
      commaManager?.setMuteVideo(true)
    } else {
      videoBarButton.image = UIImage(systemName: "video.fill")
      commaManager?.setMuteVideo(false)
    }
  }
}

extension ViewController {
  func setupUI() {
    title = "Comma"
    self.navigationController?.navigationBar.shadowImage = UIImage()
    self.navigationController?.navigationBar.isTranslucent = false
    setUnAuthState()
    self.hasVideo = false
  }
  
  func setUnAuthState() {
    self.hasVideo = false
    self.titleLabel.text = "Unauth"
    callButton.setDisable()
    videoCallButton.setDisable()
    endCallButton.setDisable()
    deleteButton.setDisable()
    loginButton.setEnable()
  }
  
  func setAuthState() {
    loginButton.setDisable()
    callButton.setEnable()
    videoCallButton.setEnable()
    endCallButton.setEnable()
    deleteButton.setEnable()
  }
}

extension UIButton {
  func setEnable() {
    alpha = 1.0
    isHighlighted = false
    isEnabled = true
  }
  func setDisable() {
    alpha = 0.6
    isHighlighted = true
    isEnabled = false
  }
}
