import "package:flutter/material.dart";
import "main_screen.dart";
import "upload_screen.dart";

class MainScaffold extends StatefulWidget {
  @override
  _MainScaffoldState createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> {
  var _curIndex = 0;
  final _screens = [
    MainScreen(),
    UploadScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("HackSecure"),
        backgroundColor: Colors.black,
      ),
      body: _screens[_curIndex],
      bottomNavigationBar: Theme(
        data: ThemeData(
          primaryColor: Colors.white,
          canvasColor: Colors.black,
          textTheme: TextTheme(
            caption: TextStyle(
              color: Colors.white70,
            ),
          ),
        ),
        child: BottomNavigationBar(
          currentIndex: _curIndex,
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              title: Text("Home"),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.file_upload),
              title: Text("Upload"),
            ),
          ],
          onTap: _onItemTapped,
        ),
      ),
      backgroundColor: Color(0xFF1A1A1A),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _curIndex = index;
    });
  }
}
