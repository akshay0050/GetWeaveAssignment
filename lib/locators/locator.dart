
import 'package:flutter_app/view/login/login_notifier.dart';
import 'package:get_it/get_it.dart';

GetIt locator = GetIt.instance;
void setupLocator() {
  locator.registerFactory(() => LoginNotifierModel());
}