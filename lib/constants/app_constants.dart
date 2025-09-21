import 'package:get_storage/get_storage.dart';
import 'package:play_monti/models/monti_user_model.dart';

final GetStorage localStorage = GetStorage("local");
final GetStorage infoStorage = GetStorage("info");

MontiUserModel? currentMontiUser;


// bool isTrialStarted => try for free'ye bastığımızda çalışır
// bool isPremium => trialdeyse ya da premiumsa
// 

