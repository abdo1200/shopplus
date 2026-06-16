import 'package:flutter/material.dart';
import 'package:shopplus/app/shopplus_app.dart';
import 'package:shopplus/core/di/service_locator.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureDependencies();
  runApp(const ShopPlusApp());
}
