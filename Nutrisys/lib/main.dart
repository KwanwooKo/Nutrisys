import 'package:flutter/material.dart';
import 'package:nutrisys/setProfile.dart';
import 'package:provider/provider.dart';
import './profile.dart';
import './home.dart';
import './calendar.dart';
import './addNew.dart';
import './settings.dart';
import './nutritionInfo.dart';
import 'package:firebase_database/firebase_database.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(ChangeNotifierProvider(
      create: (context) => Profile(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false, // 화면 좌측 상단에 DEBUG 스티커 없애줌
        initialRoute: '/',
        // home: ProfileForm(),
        home: MyApp(),
      )));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int tab = 0;

  Map<DateTime, NutritionInfo> nutritionHistory = {
    DateTime(2023, 2, 04): NutritionInfo(12.2, 421.2, 123.4, 52.12, 2102.5),
    DateTime(2023, 2, 05): NutritionInfo(23.2, 222.2, 323.4, 322.12, 4102.5),
    DateTime(2023, 2, 06): NutritionInfo(3.2, 2.2, 0.4, 122.12, 4.5),
    DateTime(2023, 2, 07): NutritionInfo(13123.1, 2.2, 323.4, 322.12, 410205.9),
  };

  DateTime selectedDate = DateTime(
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
  );

  void changeSelectedDate(DateTime date) {
    setState(() {
      selectedDate = date;
    });
  }

  // 고관우: setState 를 이용해서 tap 변경
  void clickTap(var index) {
    setState(() {
      tab = index;
    });
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    var pages = [
      Home(
        nutritionHistory: nutritionHistory,
        selectedDate: selectedDate,
        changeSelectedDate: changeSelectedDate,
      ),
      Calendar(
          nutritionHistory: nutritionHistory,
          changeTabTo: clickTap,
          changeSelectedDate: changeSelectedDate),
      // AddNew(nutritionHistory: nutritionHistory)
      AddNew()
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'NutriSys',
        ),
        centerTitle: false,
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const Settings()));
              },
              icon: const Icon(Icons.settings)),
        ],
      ),
      body: pages[tab],
      bottomNavigationBar: BottomNavigationBar(
        // 고관우: currentIndex 이용해주니까 이거 focus 가 바뀌네
        currentIndex: tab,
        // 고관우: index 를 이용해서 tap 을 띄워 => setState 필요
        onTap: (index) {
          clickTap(index);
        },
        items: const [
          // 고관우: 이거 focus 계속 home 에 가있는데 focus 이동 안되나?
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: '홈',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month_outlined),
            label: '캘린더',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: '추가',
          ),
        ],
      ),
    );
  }
}
