class AgeGroupModel {
  final String ageGroupCode;
  final String ageGroupName;
  AgeGroupModel({required this.ageGroupCode, required this.ageGroupName});
}

List<AgeGroupModel> enAgeGroupList = [
  AgeGroupModel(ageGroupCode: "18-24", ageGroupName: "👶 18-24 months"),
  AgeGroupModel(ageGroupCode: "24-36", ageGroupName: "👶 24-36 months"),
  AgeGroupModel(ageGroupCode: "36-48", ageGroupName: "👶 36-48 months"),
  AgeGroupModel(ageGroupCode: "48-60", ageGroupName: "👶 48-60 months")
];

List<AgeGroupModel> trAgeGroupList = [
  AgeGroupModel(ageGroupCode: "18-24", ageGroupName: "👶 18-24 ay"),
  AgeGroupModel(ageGroupCode: "24-36", ageGroupName: "👶 24-36 ay"),
  AgeGroupModel(ageGroupCode: "36-48", ageGroupName: "👶 36-48 ay"),
  AgeGroupModel(ageGroupCode: "48-60", ageGroupName: "👶 48-60 ay")
];
