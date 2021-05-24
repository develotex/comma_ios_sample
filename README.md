# **Comma SDK (by Develotex)**

[![Version](https://img.shields.io/cocoapods/v/Comma.svg?style=flat)](https://cocoapods.org/pods/Comma)
[![License](https://img.shields.io/cocoapods/l/Comma.svg?style=flat)](https://cocoapods.org/pods/Comma)
[![Platform](https://img.shields.io/cocoapods/p/Comma.svg?style=flat)](https://cocoapods.org/pods/Comma)


`Comma SDK` is a simple solution to integrate audio and video calls into your applications.
Contacts us via email develotex@gmail.com to get your own api keys.
Getting api keys automatically on develotex.io - coming soon.

## Requirements

```
Minimum ios 13 support
```
```
Set `Enable Bitcode` to No 
```
## Installation

Comma is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'Comma'
```

## **Initialization**

```
import Comma

var commaManager: CommaManager? = nil

commaManager = CommaManager.shared
```

Then configure  `Comma` instance when your app has started:

Register a new device 
```
commaManager?.configureService (
  localUserId: <USER_ID>, 
  userName: <USER_NAME>, 
  projectId: <PROJECT_ID>, 
  projectApiKey: <PROJECT_KEY>,
  voipToken: <VOIP_TOKEN?>, 
  isApnsSandbox: <IS_APNSSANBOX>
```

Login 
```
commaManager?.configureService (
  withDeviceSecret: <DEVICE_SECRET>, 
  deviceId: <DEVICE_ID>, 
  voipToken: <VOIP_TOKEN?>, 
  isApnsSandbox: <IS_APNSSANBOX>
)
```

Please note that The registration method is called after connecting to the signaling server. This method is a direct alternative to the Login method, with the only difference that Login authorizes the connection for an existing device, and Register creates a new device and automatically authorizes the connection for it. Thus, you cannot call Login after Register.


Please call  `closeConnection()` in method  `applicationDidEnterBackground`  to properly close all connections & configure your session anew in method  `applicationDidBecomeActive` 


### **Callbacks**

```
commaManager?.register = { userId in
  print("your id \(userId)")
}
```

### **Receive Incoming Call**

```
commaManager?.isReceiveIncomingCall = { incomingCall in
print("Incoming Call \(incomingCall)")
}

```

**APNS Push**

register voip push token
```
func pushRegistry(_ registry: PKPushRegistry, didUpdate pushCredentials: PKPushCredentials, for type: PKPushType) {
  if pushCredentials.token.count == 0 { return }
  else if type == PKPushType.voIP {
    let tokenData = pushCredentials.token
    let voipToken = tokenData.map { String(format: "%02.2hhx", $0) }.joined()
    commaManager?.registerVoipPushNotification(voipToken: voipToken, isApnsSandbox: true)
  }
}
```
receive voip push token
```
func pushRegistry(_ registry: PKPushRegistry, didReceiveIncomingPushWith payload: PKPushPayload, for type: PKPushType, completion: @escaping () -> Void) {
  if type == .voIP {
  commaManager.didReceiveIncomingPushWith(dictionaryPayload: payload.dictionaryPayload, withCallKit: true)
  }
}
```
If you are using CallKit: to show the application logo on the callkit screen you need to add the image named  `AppIconForComma `.

### **Accept or Decline Incoming Call**
Accept 
```
  self.commaManager?.answerCall(true, type: incomingCall.callType)
```

### **Call**

Calling only with audio:
```
commaManager?.startCall(id: <CALEE_ID>)
```

Calling with video:
```
commaManager?.startVideoCall(id: <CALEE_ID>)
```

Call options:
mute / unmute audio
```
commaManager?.setMuteAudio(true)
```
mute / unmute video
```
commaManager?.setMuteVideo(true)
```
speaker
```
commaManager?.setSpeaker(false)
```

streaming to local and remote views during a video call
```
commaService?.setupVideo(localView: <local_UIView>, remoteView: <remote_UIView>,cameraPosition: <camera_position>)
```

End Call
```
commaManager?.endCall()
```

Check Connection State
```
commaManager?.connectionStateDidChange =  { state in
  switch state {
  case .checking:
  case .connected:
  case .failed:
  case .disconnected:
  }
}
```

## Author

develotex, develotex@gmail.com

## License

Comma is available under the Commercial license. See the LICENSE file for more info.
