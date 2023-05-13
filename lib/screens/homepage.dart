import 'package:flutter/material.dart';
import 'package:konnect/QRPage.dart';
import 'package:konnect/molecules/drawer.dart';
import 'package:konnect/scanner.dart';
import 'package:konnect/screens/Profile.dart';
import 'package:konnect/screens/Settings.dart';

class Homepage extends StatefulWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: SafeArea(
        child: Scaffold(
          bottomNavigationBar: NavigationBar(
            height: 60,
            backgroundColor: const Color.fromRGBO(48, 1, 50, 1),
            selectedIndex: currentIndex,
            onDestinationSelected: (ind) => {setState(() {currentIndex = ind;})},
            destinations:
              const <Widget>[
                NavigationDestination(
                  icon: Icon(Icons.home_filled,color: Colors.white,),
                  label: 'Home',
                ),
                NavigationDestination(
                  icon: Icon(Icons.account_circle,color: Colors.white,),
                  label: 'Profile',
                ),
                NavigationDestination(
                  icon: Icon(Icons.settings,color: Colors.white,),
                  label: 'Settings',
                ),

            ],
          ),
          body: Container(
            decoration: const BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                  Color.fromRGBO(65, 1, 590, 10),
                  Color.fromRGBO(0, 0, 31, 10)
                ])),
            child: [
              Column(
              children: [
                const TabBar(indicatorColor: Colors.white, tabs: [
                  Tab(
                    text: 'QR Code',
                  ),
                  Tab(
                    text: 'Scanner',
                  ),
                ]),
                SizedBox(
                  height: MediaQuery.of(context).size.height - 158,
                  child: TabBarView(
                    children: [
                      QRPage(),
                      const ScannerPage(),
                    ],
                  ),
                ),
              ],
            ),
              const Profile(),
              Settings()
            ][currentIndex],
          ),
        ),
      ),
    );
  }
}
