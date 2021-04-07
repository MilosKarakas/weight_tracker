import 'package:get_it/get_it.dart';
import 'package:weight_tracker/services/auth_service.dart';
import 'package:weight_tracker/services/data_service.dart';

GetIt serviceLocator = GetIt.instance;

void setupServiceLocator() {
  serviceLocator.registerFactory(() => AuthService());
  serviceLocator.registerFactory(() => DataService());
}
