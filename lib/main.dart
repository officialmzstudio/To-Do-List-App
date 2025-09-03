import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

import 'screens/welcome_screen.dart';
import 'utils/hive_helper.dart';
import 'models/task_provider.dart';
import 'utils/notification_service.dart'; //  اضافه کردن

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter(); // init مسیر Hive
  await HiveHelper.initHive(); // ثبت Adapter و باز کردن box
  await NotificationService().init(); //  مقداردهی نوتیفیکیشن‌ها
  runApp(const YaddashtApp());
}

class YaddashtApp extends StatelessWidget {
  const YaddashtApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => TaskProvider(),
      child: MaterialApp(
        title: 'Yaddasht',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          fontFamily: 'Ubuntu',
          primaryColor: const Color(0xFFA6CDC6),
          scaffoldBackgroundColor: Colors.white,
        ),
        home: const WelcomeScreen(),
      ),
    );
  }
}
