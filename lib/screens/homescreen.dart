import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lazyterminator/widgets/alltaskswidget.dart';
import 'package:lazyterminator/widgets/createtaskwidget.dart';
import 'package:lazyterminator/widgets/focusmodewidget.dart';
import 'package:lazyterminator/widgets/homewidget.dart';
import 'package:lazyterminator/widgets/profilewidget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 1; // Home Widget is not ready yet, if ready change to 0

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  final List<Widget> _pages = <Widget>[
    const HomeWidget(),
    const CreateTaskWidget(),
    const FocusModeWidget(),
    const AllTaskWidget(),
    const ProfileWidget()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          leading: Image.asset("images/main_logo.png"),
          title: const Text(
            "Lazy Terminator",
            style: TextStyle(
                color: Color.fromRGBO(23, 15, 106, 1),
                fontWeight: FontWeight.bold),
          ),
          backgroundColor: const Color.fromRGBO(254, 230, 159, 1),
          actions: <Widget>[
            Padding(
                padding: const EdgeInsets.only(right: 20.0),
                child: GestureDetector(
                  onTap: () {
                    FirebaseAuth.instance.signOut();
                  },
                  child: const Icon(
                    Icons.logout_outlined,
                    size: 26.0,
                    color: Color.fromRGBO(23, 15, 106, 1),
                  ),
                )),
          ]),
      body: _pages.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: "Add Task",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.dark_mode_outlined),
            label: "Focus Mode",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: "All Tasks",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Profile",
          )
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
