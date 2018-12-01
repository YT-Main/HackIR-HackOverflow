import "package:flutter/material.dart";
import "package:image_picker/image_picker.dart";

class UploadScreen extends StatefulWidget {
  @override
  _UploadScreenState createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {
  void _takeAndSendImage() async {
    // This is supposed to upload an image to train.
    await ImagePicker.pickImage(source: ImageSource.camera);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Align(
        alignment: Alignment.bottomRight,
        child: FloatingActionButton.extended(
          foregroundColor: Colors.white,
          backgroundColor: Colors.black,
          onPressed: _takeAndSendImage,
          icon: Icon(Icons.camera_alt),
          label: Text("CAMERA"),
        ),
      ),
    );
  }
}
