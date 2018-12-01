import "package:flutter/material.dart";
import "package:path_provider/path_provider.dart";
import "dart:io";

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  Socket _socket;
  var _isPersonAtDoor = false;
  var _isDoorLocked = true;

  void _initializeSocket() async {
    _socket = await Socket.connect("10.177.16.161", 1919,
        timeout: Duration(seconds: 5));
    _socket.listen(_messageHandler);
  }

  void _messageHandler(List<int> data) async {
    print(data);
    if (data.last == 110) {
      _isPersonAtDoor = false;
      return;
    } else if (data.last == 100) {
      sleep(Duration(seconds: 1));
      _doneHandler();
      return;
    }

    _isPersonAtDoor = true;
    final docDir = await getApplicationDocumentsDirectory();
    final image = File("${docDir.path}/image.png");

    image.writeAsStringSync("");
    image.writeAsBytesSync(data, mode: FileMode.append);
  }

  void _changeDoorStatus(bool status, [bool popContext = true]) {
    setState(() {
      _isDoorLocked = status;
      _socket.write(status ? "lock_door" : "unlock_door");
      if (popContext) {
        Navigator.of(context).pop();
      }
    });
  }

  void _doneHandler() async {
    if (!_isPersonAtDoor) {
      return;
    }

    final docDir = await getApplicationDocumentsDirectory();
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: Text("Someone's at the door!"),
          content: Image(
            image: FileImage(File("${docDir.path}/image.png")),
          ),
          actions: <Widget>[
            FlatButton(
              onPressed: () => _changeDoorStatus(false),
              child: Text("UNLOCK"),
            ),
            FlatButton(
              onPressed: () => _changeDoorStatus(true),
              child: Text("LOCK"),
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _initializeSocket();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Padding(
            padding:
                EdgeInsets.only(top: MediaQuery.of(context).size.height / 6),
            child: Stack(
              alignment: Alignment.center,
              children: <Widget>[
                SizedBox(
                  width: MediaQuery.of(context).size.width - 64,
                  height: MediaQuery.of(context).size.width - 64,
                  child: CircularProgressIndicator(
                    value: 1.0,
                    valueColor: AlwaysStoppedAnimation<Color>(
                        _isDoorLocked ? Colors.lightGreenAccent : Colors.red),
                    strokeWidth: 16.0,
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width - 96,
                  height: MediaQuery.of(context).size.width - 96,
                  child: CircularProgressIndicator(
                    value: 1.0,
                    valueColor: AlwaysStoppedAnimation<Color>(
                        _isDoorLocked ? Colors.lightGreenAccent : Colors.red),
                  ),
                ),
                InkWell(
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                    ),
                    width: MediaQuery.of(context).size.width - 96,
                    height: MediaQuery.of(context).size.width - 96,
                    child: Icon(
                      _isDoorLocked ? Icons.lock_open : Icons.lock_outline,
                      color: Colors.white,
                      size: 72.0,
                    ),
                  ),
                  onTap: () {
                    setState(() {
                      _changeDoorStatus(!_isDoorLocked, false);
                    });
                  },
                  borderRadius: BorderRadius.circular(
                      (MediaQuery.of(context).size.width - 96) / 2),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
