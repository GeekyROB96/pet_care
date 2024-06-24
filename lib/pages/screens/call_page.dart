import 'package:flutter/material.dart';
import 'package:pet_care/constants/zego_credentials.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
import 'package:zego_uikit_signaling_plugin/zego_uikit_signaling_plugin.dart';

class CallPage extends StatelessWidget {
  final String username;
  final String userId;
  const CallPage({Key? key
  , required this.callID
  ,required this.username,
  required this.userId
  }) : super(key: key);
  final String callID;

  @override
  Widget build(BuildContext context) {
    return ZegoUIKitPrebuiltCall(
      appID: ZegoCredentials.appID,
      appSign: ZegoCredentials.appSign,
      userID: userId,
      userName: username,
      callID: callID,
          plugins: [ZegoUIKitSignalingPlugin()],

      // You can also use groupVideo/groupVoice/oneOnOneVoice to make more types of calls.
       config: ZegoUIKitPrebuiltCallConfig.oneOnOneVideoCall(),
    );
  }
}
