//*********************************************
//  Deal Diligence was designed and created by      *
//  Nathan Kane                               *
//  copyright 2023                            *
//*********************************************

// This defines the database table or document

class Device {
  String? userId;
  String? deviceToken;
  String? platform;

  Device({this.userId, this.deviceToken, this.platform});

  Map<String, dynamic> toMap() {
    return {
      'deviceToken': deviceToken,
      'userrId': userId,
      'platform': platform,
    };
  }

  Device.fromFirestore(Map<String, dynamic> firestore)
      : userId = firestore['userId'],
        deviceToken = firestore['deviceToken'],
        platform = firestore['platform'];
}
