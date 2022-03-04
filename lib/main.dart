import 'dart:io';
import 'package:firebase/second.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    MaterialApp(
      home: Second(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  DatabaseReference db = FirebaseDatabase.instance.ref('Reception');
  File? img;
  String url = '';

  selectImage() async {
    ImagePicker picker = ImagePicker();
    XFile? image = await picker.pickImage(source: ImageSource.gallery);
    img = File(image!.path);

    /// Upload image to firebase
    String fileName = basename(img!.path);
    Reference firebaseStorageRef =
        FirebaseStorage.instance.ref().child('uploads/$fileName');
    UploadTask uploadTask = firebaseStorageRef.putFile(img!);
    url = await (await uploadTask).ref.getDownloadURL();
    print('--$url---');
    String? key = db.push().key;
    db.child(key!).set({
      'image': url,
      'key': key,
    });
    setState(() {

    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            selectImage();
          },
        ),
        body: Center(
          child: CircleAvatar(
            radius: 100,
            backgroundImage: NetworkImage(url == ''
                ? 'https://flutter-examples.com/wp-content/uploads/2019/11/Image_Picker_Thumb_new.png'
                : url),
          ),
        ),
      ),
    );
  }
}
