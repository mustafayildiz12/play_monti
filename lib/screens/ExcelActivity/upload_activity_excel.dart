import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:excel/excel.dart' as excel_lib;
import 'package:play_monti/models/final_activity_model.dart';
import 'package:play_monti/service/activty_service.dart';
import 'package:play_monti/utlis/widgets/custom_snackbar.dart';

class UploadActivityExcel extends StatefulWidget {
  const UploadActivityExcel({super.key});

  @override
  State<UploadActivityExcel> createState() => _UploadActivityExcelState();
}

class _UploadActivityExcelState extends State<UploadActivityExcel> {
  final TextEditingController csvFileNameController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final List<FinalActivityModel> excelItems = [];

  String selectedAgeType = "18-24";
  List<String> ageTypes = ["18-24", "24-36", "36-48", "48-60"];

  String selectedLanguage = "tr";
  List<String> languages = ["tr", "en", "sp", "fr"];

  List<int> bytes = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Yeni Aktivite"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Row(children: [
                Expanded(
                  child: DropdownButton(
                    value: selectedAgeType,

                    // Down Arrow Icon
                    icon: const Icon(Icons.keyboard_arrow_down),

                    // Array list of items
                    items: ageTypes.map((String items) {
                      return DropdownMenuItem(value: items, child: Text(items));
                    }).toList(),
                    // After selecting the desired option,it will
                    // change button value to selected value
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedAgeType = newValue!;
                      });
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: DropdownButton(
                    value: selectedLanguage,

                    // Down Arrow Icon
                    icon: const Icon(Icons.keyboard_arrow_down),

                    // Array list of items
                    items: languages.map((String items) {
                      return DropdownMenuItem(value: items, child: Text(items));
                    }).toList(),
                    // After selecting the desired option,it will
                    // change button value to selected value
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedAgeType = newValue!;
                      });
                    },
                  ),
                ),
              ]),
              const SizedBox(height: 16),
              TextFormField(
                controller: csvFileNameController,
                onTap: () async {
                  final excelBytes = await _pickFiles();
                  setState(() {
                    bytes = excelBytes;
                  });
                },
                readOnly: true,
                decoration: const InputDecoration(
                  label: Text("Dosya Seç"),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    try {
                      await tabloKontrolIslemleri();
                    } catch (e) {
                      setState(() {
                        excelItems.clear();
                        bytes.clear();
                      });

                      debugPrint("Excel Hatası: $e");
                    }
                  }
                },
                child: const Text("Kaydet"),
              )
            ],
          ),
        ),
      ),
    );
  }

  ///Sadece Excel işlemlerine özel dosya seçim fonksiyonumuz.
  Future<List<int>> _pickFiles() async {
    try {
      final List<PlatformFile>? tempFiles =
          (await FilePicker.platform.pickFiles(
        type: FileType.custom,
        onFileLoading: (FilePickerStatus status) =>
            debugPrint(status.toString()),

        /// get us byte data
        withData: true,

        /// user select only  type of files which is in list
        allowedExtensions: ['xlsx'],
      ))
              ?.files;

      ///check file is epmty or not
      if (tempFiles == null) {
        return [];
      }
      // ignore: prefer_typing_uninitialized_variables
      var excelBytes;
      for (final PlatformFile e in tempFiles) {
        excelBytes = e.bytes;
      }

      if (tempFiles.isNotEmpty) {
        setState(() {
          csvFileNameController.text = tempFiles[0].name;
        });
        return excelBytes;
      } else {
        return [];
      }
    } on PlatformException catch (e) {
      /// catch platform error
      debugPrint('Unsupported operation $e');

      return [];
    } catch (e) {
      /// catch platform error
      debugPrint(e.toString());

      return [];
    }
  }

  /// Sadece Excel işlemlerine özel dosya seçim fonksiyonumuz.
  Future<void> tabloKontrolIslemleri() async {
    excel_lib.Excel excel;

    if (bytes.isNotEmpty) {
      try {
        excel = excel_lib.Excel.decodeBytes(bytes);

        final List<String> hataOlanSatirlar = [];
        final String sheetName = excel.tables.keys.first;
        print(sheetName);
        final pblItemsSheet = excel.tables[sheetName];

        if (pblItemsSheet == null) {
          debugPrint("Excel $sheetName sayfası bulunamadı.");
          customSnackBar.error("snackbar.excelTemplate".tr);
          clearFile();
        } else {
          /// Kolon indeksleri
          const int kDayIndex = 0;
          const int kActivityNameIndex = 1;

          const int kAgeGroupIndex = 2;
          const int kActivityTypeIndex = 3;
          const int kImprovementNameIndex = 4;
          const int kMaterials = 5;
          const int kSteps = 6;
          const int kClue = 7;
          const int kEmoji = 8;
          const int kSecurity = 9;
          const int kApothegm = 10;

          for (int i = 1; i < pblItemsSheet.maxRows; i++) {
            final List<excel_lib.Data?> row = pblItemsSheet.rows[i];

            FinalActivityModel addProjectRequestModel = FinalActivityModel(
              day: int.parse(
                row[kDayIndex]!.value!.toString(),
              ),
              activityName: row[kActivityNameIndex]!.value!.toString(),
              ageGroup: row[kAgeGroupIndex]!.value!.toString(),
              activityType: row[kActivityTypeIndex]!.value!.toString(),
              improvementArea: row[kImprovementNameIndex]!.value!.toString(),
              materials: row[kMaterials]!.value!.toString(),
              stepByStep: row[kSteps]!.value!.toString(),
              clue: row[kClue]!.value!.toString(),
              emoji: row[kEmoji]!.value!.toString(),
              warningText: row[kSecurity]!.value!.toString(),
              apothegm: row[kApothegm]!.value!.toString(),
            );

            setState(() {
              excelItems.add(addProjectRequestModel);
            });
          }

          if (hataOlanSatirlar.isEmpty) {
            await addProjects(excelItems);
          }
        }
      } catch (e) {
        debugPrint(e.toString());
      }
    }
  }

  Future<void> addProjects(List<FinalActivityModel> activityModel) async {
    try {
      for (var e in activityModel) {
        await activityService.addWeeklyActivity(
            ageGroup: selectedAgeType,
            language: selectedLanguage,
            activityModel: e);
      }
      customSnackBar.success("Başarılı");
    } catch (e) {
      customSnackBar.error("$e");
    }
  }

  void clearFile() {
    setState(() {
      csvFileNameController.clear();
    });
  }
}
