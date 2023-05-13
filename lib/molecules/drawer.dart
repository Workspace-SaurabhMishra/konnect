import 'package:flutter/material.dart';

class AppDrawer extends StatefulWidget {
  const AppDrawer({Key? key}) : super(key: key);

  @override
  State<AppDrawer> createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  @override
  Drawer build(BuildContext context) {
    return Drawer(
      backgroundColor: const Color.fromRGBO(48, 1, 50, 1),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 100.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Padding(
                        padding: EdgeInsets.only(left: 15.0),
                        child: Text(
                          "Home",
                          style: TextStyle(color: Colors.white, fontSize: 25),
                        ),
                      ),
                      Divider(
                        thickness: 0.5,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Padding(
                        padding: EdgeInsets.only(left: 15.0),
                        child: Text(
                          "Profile",
                          style: TextStyle(color: Colors.white, fontSize: 25),
                        ),
                      ),
                      Divider(
                        thickness: 0.5,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Padding(
                        padding: EdgeInsets.only(left: 15.0),
                        child: Text(
                          "Settings",
                          style: TextStyle(color: Colors.white, fontSize: 25),
                        ),
                      ),
                      Divider(
                        thickness: 0.5,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Padding(
                        padding: EdgeInsets.only(left: 15.0),
                        child: Text(
                          "About",
                          style: TextStyle(color: Colors.white, fontSize: 25),
                        ),
                      ),
                      Divider(
                        thickness: 0.5,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: 50,
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.only(left:15.0),
              child: Row(
                children: const [
                  Icon(
                    Icons.login_outlined,
                    color: Color.fromRGBO(48, 1, 50, 1),
                    size: 25,
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 10.0),
                    child: Text(
                      'Logout',
                      style: TextStyle(
                          color: Color.fromRGBO(48, 1, 50, 1), fontSize: 20),
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
