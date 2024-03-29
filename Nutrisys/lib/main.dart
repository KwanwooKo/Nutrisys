import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './profile.dart';
import './home.dart';
import './calendar.dart';
import './addNew.dart';
import './settings.dart';
import './nutritionInfo.dart';
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
      ChangeNotifierProvider (
          create: (context) => Profile(),
          child: MaterialApp(
            debugShowCheckedModeBanner: false, // 화면 우측 상단에 DEBUG 스티커 없애줌
            initialRoute: '/',
            // home: ProfileForm(),
            home: MyApp(),
            theme: ThemeData(
              scaffoldBackgroundColor: Colors.white, // 공백 색
              primarySwatch: Colors.cyan, // **** 얘가 메인 컬러
              appBarTheme: AppBarTheme(
                foregroundColor: Colors.black87, // app bar 글씨 색
              ),
              elevatedButtonTheme: ElevatedButtonThemeData(
                style: ButtonStyle(
                    foregroundColor: MaterialStateProperty.all<Color>(Colors.white) // 네모 버튼 글자 색
                ),
              ),
            ),
          )
      )
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int tab = 0;

  Map<DateTime, NutritionInfo> nutritionHistory = {};

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
      Home(nutritionHistory: nutritionHistory, selectedDate: selectedDate, changeSelectedDate: changeSelectedDate,),
      Calendar(nutritionHistory : nutritionHistory, changeTabTo : clickTap, changeSelectedDate : changeSelectedDate),
      AddNew(nutritionHistory: nutritionHistory)
    ];

    return Scaffold(
      // backgroundColor: Colors.white24,
      appBar: AppBar(
        title: const Text('NutriSys',),
        centerTitle: true,
        toolbarHeight: 60,
        actions: [
          IconButton(
              onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => const Settings()));
              },
              icon: const Icon(Icons.person),
          ),
        ],
      ),
      body: pages[tab],
      bottomNavigationBar: SizedBox(
        height: 70,
        child: BottomNavigationBar(
          // 고관우: currentIndex 이용해주니까 이거 focus 가 바뀌네
          currentIndex: tab,
          // 고관우: index 를 이용해서 tap 을 띄워 => setState 필요
          onTap: (index) { clickTap(index); },
          items: const [
            // 고관우: 이거 focus 계속 home 에 가있는데 focus 이동 안되나?
            BottomNavigationBarItem(icon: Icon(Icons.home), label: '홈',),
            BottomNavigationBarItem(icon: Icon(Icons.calendar_month_outlined), label: '캘린더',),
            BottomNavigationBarItem(icon: Icon(Icons.add), label: '추가',),
          ],
        ),
      ),
    );
  }
}
