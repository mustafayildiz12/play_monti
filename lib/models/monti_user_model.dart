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
      this.languageCode,
      this.isAnonymous,
      this.isAdmin});

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
        completedActivities: map['completedActivities'] ?? 0,
        languageCode: map['languageCode'],
        isAnonymous: map['isAnonymous'],
        isAdmin: map['isAdmin']);
  }

  final String? userName;
  final String? userPassword;
  final String? uid;
  final String? userEmail;
  final int? status;
  final int? createDateTimeStamp;
  final String? deviceId;
  final String? ageActivity;
  final String? selectedLanguage;
  final String? startDate;
  final String? languageCode;
  final int? completedActivities;
  final bool? isAnonymous;
  final bool? isAdmin;

  Map<String, dynamic> toMap() {
    return {
      'userName': userName,
      'userPassword': userPassword,
      'uid': uid,
      'userEmail': userEmail,
      'status': status,
      'createDateTimeStamp': createDateTimeStamp,
      'deviceId': deviceId,
      'ageActivity': ageActivity,
      'selectedLanguage': selectedLanguage,
      'startDate': startDate,
      'completedActivities': completedActivities,
      'languageCode': languageCode,
      'isAdmin': isAdmin
    };
  }

  /// copyWith metodu
  MontiUserModel copyWith(
      {String? userName,
      String? userPassword,
      String? uid,
      String? userEmail,
      int? status,
      int? createDateTimeStamp,
      String? deviceId,
      String? ageActivity,
      String? selectedLanguage,
      String? startDate,
      int? completedActivities,
      String? languageCode,
      bool? isAnonymous,
      bool? isAdmin}) {
    return MontiUserModel(
        userName: userName ?? this.userName,
        userPassword: userPassword ?? this.userPassword,
        uid: uid ?? this.uid,
        userEmail: userEmail ?? this.userEmail,
        status: status ?? this.status,
        createDateTimeStamp: createDateTimeStamp ?? this.createDateTimeStamp,
        deviceId: deviceId ?? this.deviceId,
        ageActivity: ageActivity ?? this.ageActivity,
        selectedLanguage: selectedLanguage ?? this.selectedLanguage,
        startDate: startDate ?? this.startDate,
        completedActivities: completedActivities ?? this.completedActivities,
        languageCode: languageCode ?? this.languageCode,
        isAnonymous: isAnonymous ?? this.isAnonymous,
        isAdmin: isAdmin ?? this.isAdmin);
  }
}
