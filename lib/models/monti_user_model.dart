class MontiUserModel {
  MontiUserModel(
      {this.userName,
      this.userPassword,
      this.uid,
      this.userEmail,
      this.status,
      this.createDateTimeStamp,
      this.deviceId,
      this.ageActivity,
      this.selectedLanguage,
      this.startDate,
      this.completedActivities,
      this.languageCode});

  factory MontiUserModel.fromMap(Map<String, dynamic> map) {
    return MontiUserModel(
        userName: map['userName'],
        userPassword: map['userPassword'],
        uid: map['uid'],
        userEmail: map["userEmail"],
        status: map["status"],
        deviceId: map["deviceId"],
        createDateTimeStamp: map["createDateTimeStamp"] ?? 0,
        ageActivity: map['ageActivity'],
        selectedLanguage: map['language'],
        startDate: map['startDate'],
        completedActivities: map['completedActivities'] ?? "",
        languageCode: map['languageCode']);
  }
  final String? userName;
  final String? userPassword;
  final String? uid;
  final String? userEmail;
  final int? status;
  final int? createDateTimeStamp;
  final String? deviceId;
  String? ageActivity;
  final String? selectedLanguage;
  final String? startDate;
  String? languageCode;
  int? completedActivities;

  Map<String, dynamic> toMap() {
    return {
      'userName': userName,
      'userPassword': userPassword,
      'uid': uid,
      "userEmail": userEmail,
      "status": status,
      "createDateTimeStamp": createDateTimeStamp,
      "deviceId": deviceId,
      'ageActivity': ageActivity,
      'selectedLanguage': selectedLanguage,
      'startDate': startDate,
      'completedActivities': completedActivities,
      'languageCode': languageCode
    };
  }
}
