class LanguageModel {
  final String languageCode;
  final String languageName;
  LanguageModel({
    required this.languageCode,
    required this.languageName,
  });
}

List<LanguageModel> enLanguageList = [
  LanguageModel(languageCode: "en", languageName: "English"),
  LanguageModel(languageCode: "tr", languageName: "Turkish"),
];

List<LanguageModel> trLanguageList = [
  LanguageModel(languageCode: "en", languageName: "İngilizce"),
  LanguageModel(languageCode: "tr", languageName: "Türkçe"),
];
