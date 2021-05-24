//
//  VideoController.swift
//  Comma_Example
//
//  Created by develotex
//  Copyright (c) 2021 develotex. All rights reserved.

import UIKit
import Comma

class VideoController: UIViewController {
  var delegate: CommaManagerDelegate?
  var localView: UIView = {
    let v = UIView()
    v.backgroundColor = .clear
    return v
  }()
  
  var remoteView: UIView = {
    let v = UIView()
    v.backgroundColor = .clear
    return v
  }()
  
  var switchCameraButton: UIButton = {
    let b = UIButton(type: .system)
    b.setImage(UIImage(systemName: "line.3.crossed.swirl.circle"), for: .normal)
    return b
  }()
  
  var isFront = true
  override func viewDidLoad() {
    super.viewDidLoad()
    self.setupUI()
    delegate?.commaManager?.setupVideo(localView: localView, remoteView: remoteView, cameraPosition: .front)
  }
  
  func setupUI() {
    view.backgroundColor = .white
    remoteView.frame = self.view.frame
    view.insertSubview(remoteView, at: 0)
    localView.frame = CGRect(x: 0, y: 0, width: view.frame.size.width * 0.4, height: view.frame.size.height * 0.3)
    localView.frame.origin = .init(x: view.frame.size.width * 0.6 - 20, y: view.frame.size.height * 0.7 - 20)
    localView.layer.cornerRadius = 12
    self.localView.frame.origin.y = self.view.frame.size.height * 0.05
    self.localView.frame.origin.x = self.view.frame.width - self.localView.frame.width - 10
    localView.layer.masksToBounds = true
    view.addSubview(localView)
    localView.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(onPan(_:))))
    remoteView.didMoveToSuperview()
    
    switchCameraButton.addTarget(self, action: #selector(switchCameraButtonClicked), for: .touchUpInside)
    view.addSubview(switchCameraButton)
    switchCameraButton.translatesAutoresizingMaskIntoConstraints = false
    
    switchCameraButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32).isActive = true
    //    switchCameraButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32).isActive = true
    switchCameraButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -32).isActive = true
    switchCameraButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
    switchCameraButton.widthAnchor.constraint(equalToConstant: 60).isActive = true
  }
  
  @objc func switchCameraButtonClicked() {
    if isFront {
      isFront = false
      delegate?.commaManager?.setupVideo(localView: localView, remoteView: remoteView, cameraPosition: .back)
      switchCameraButton.setImage(UIImage(systemName: "line.3.crossed.swirl.circle.fill"), for: .normal)
    } else {
      isFront = true
      delegate?.commaManager?.setupVideo(localView: localView, remoteView: remoteView, cameraPosition: .front)
      switchCameraButton.setImage(UIImage(systemName: "line.3.crossed.swirl.circle"), for: .normal)
    }
    print("isFront: \(isFront)")
  }
  
  @objc func onPan(_ pan: UIPanGestureRecognizer) {
    let translation = pan.translation(in: localView)
    if pan.state == UIGestureRecognizer.State.changed {
      localView.center = CGPoint(x: localView.center.x + translation.x, y: localView.center.y + translation.y)
      pan.setTranslation(CGPoint.zero, in: localView)
    } else if pan.state == .ended {
      let center = self.view.center
      UIView.animate(withDuration: 0.2, animations: {
        if self.localView.center.x > center.x {
          self.localView.frame.origin.x = self.view.frame.width - self.localView.frame.width - 10
        } else {
          self.localView.frame.origin.x = 10
        }
        if self.localView.center.y > center.y {
          self.localView.frame.origin.y = self.view.frame.height - self.localView.frame.height - 100
        } else {
          self.localView.frame.origin.y =  self.view.frame.size.height * 0.05
        }
      })
    }
  }
}
