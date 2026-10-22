import 'package:courseflow/screens/courses_screen.dart';
import 'package:flutter/material.dart';
import 'package:courseflow/screens/home_screen.dart';
import 'package:provider/provider.dart';
import 'package:courseflow/repositories/assignment_repository.dart';
import 'package:courseflow/screens/schedule_screen.dart';

void main() async {
  runApp(ChangeNotifierProvider(
    create: (context) {
    final repo = AssignmentRepository();
    repo.fetchAndLoadAssignments();
    return repo;
  },
    child: const MainApp()
  ));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CourseFlow',
      home: HomePage(),
      theme: ThemeData(primarySwatch: Colors.green),
      darkTheme: ThemeData.dark(),
      themeMode: ThemeMode.light,
      debugShowCheckedModeBanner: false,
    );
  }
}


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  

  @override
  State<HomePage> createState() => HomePageState();
}


class HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  

  

  @override
  Widget build(BuildContext context) {

    void onNavigateToCourses() {
      setState((){_currentIndex = 1;});
    }

    void onNavigateToSchedule() {
      setState((){_currentIndex = 2;});
    }

    final List<Widget> _screens = [
      HomeScreen(onNavigateToCourses: onNavigateToCourses, onNavigateToSchedule: onNavigateToSchedule,),
      CoursesNavigator(),
      ScheduleScreen()
    ];

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (int index) {
          setState(() => _currentIndex = index);
        },
        destinations: [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home_rounded),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.school_outlined),
            selectedIcon: Icon(Icons.school_rounded),
            label: 'Courses',
          ),
          NavigationDestination(
            icon: Icon(Icons.calendar_today_outlined),
            selectedIcon: Icon(Icons.calendar_month_rounded),
            label: 'Schedule',
          ),
        ],
      ),
    );
  }
}