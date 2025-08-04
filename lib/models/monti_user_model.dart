class MontiUserModel {
  MontiUserModel(
      {this.userName,
      this.userPassword,
      this.uid,
      this.userEmail,
      this.status,
      this.createDateTimeStamp,
      this.deviceId});

  factory MontiUserModel.fromMap(Map<String, dynamic> map) {
    return MontiUserModel(
      userName: map['userName'],
      userPassword: map['userPassword'],
      uid: map['uid'],
      userEmail: map["userEmail"],
      status: map["status"],
      deviceId: map["deviceId"],
      createDateTimeStamp: map["createDateTimeStamp"] ?? 0,
    );
  }
  String? userName;
  String? userPassword;
  String? uid;
  String? userEmail;
  int? status;
  int? createDateTimeStamp;
  String? deviceId;

  Map<String, dynamic> toMap() {
    return {
      'userName': userName,
      'userPassword': userPassword,
      'uid': uid,
      "userEmail": userEmail,
      "status": status,
      "createDateTimeStamp": createDateTimeStamp,
      "deviceId": deviceId
    };
  }
}
