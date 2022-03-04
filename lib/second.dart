import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class Second extends StatefulWidget {
  const Second({Key? key}) : super(key: key);

  @override
  _SecondState createState() => _SecondState();
}

class _SecondState extends State<Second> {
  TextEditingController fieldKey = TextEditingController();
  TextEditingController fieldSecondKey = TextEditingController();

  DatabaseReference dataBaseFirst = FirebaseDatabase.instance.ref("Reception");
  DatabaseReference dataBaseSecond =
      FirebaseDatabase.instance.ref("Second Map");
  DatabaseReference dataBaseThird = FirebaseDatabase.instance.ref("Third Map");

  List<Map> data = [];
  selectData(){
    dataBaseFirst.once().then((value) {
      data.clear();
      Map temp = value.snapshot.value as Map;
      temp.forEach((key, value) {
        data.add(value);
      });
      setState(() {});
    });
    print("Snapshot");
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                TextField(controller: fieldKey),
                SizedBox(height: 50.0, width: 50,),
                TextField(controller: fieldSecondKey),
                MaterialButton(
                  onPressed: () {
                    String? firstKey = dataBaseFirst.push().key;
                    dataBaseFirst.child(firstKey!).set({
                      'Number': fieldKey.text,
                      'key': firstKey,
                    });
                  },
                  child: Text("Add for First"),
                ),
                MaterialButton(
                  onPressed: () {
                   selectData();
                  },
                  child: Text("SELECT"),
                ),
                Expanded(
                  child: ListView.builder(
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GestureDetector(
                          onTap: () {
                            dataBaseFirst.child(data[index]['key']).update(
                                {
                                  'Number':fieldKey.text,
                                });
                            selectData();
                          },
                          child: CircleAvatar(radius: 50,
                          backgroundImage: NetworkImage(data[index]['image']),),
                          // child: Text(data[index]['Number']),
                        ),
                      );
                    },
                    itemCount: data.length,
                  ),
                )
                /* MaterialButton(
                  onPressed: () {
                    dataBaseFirst.child('First').update({
                      'Number': fieldKey.text,
                    });
                  },
                  child: Text("Edit for First"),
                ),
                MaterialButton(
                  onPressed: () {
                    dataBaseFirst.child('First').remove();
                  },
                  child: Text("Delete for First"),
                ),
                MaterialButton(
                  onPressed: () {
                    String? secondKey = dataBaseSecond.push().key;
                    dataBaseSecond.child(secondKey!).set({
                      'Name': fieldKey.text,
                      'key': secondKey,
                    });
                  },
                  child: Text("Add for Second"),
                ),
                MaterialButton(
                  onPressed: () {
                    dataBaseSecond.child('Second').update({
                      'Name': fieldKey,
                    });
                  },
                  child: Text("Edit for Second"),
                ),
                MaterialButton(
                  onPressed: () {
                    dataBaseSecond.child('Second').remove();
                  },
                  child: Text("Delete for Second"),
                ),
                MaterialButton(
                  onPressed: () {
                    dataBaseThird.child('Third').set({
                      'First Name': fieldKey,
                      'Second Name': (fieldSecondKey.text == '')
                          ? "Empty"
                          : fieldSecondKey,
                    });
                  },
                  child: Text("Add for Second"),
                ),
                MaterialButton(
                  onPressed: () {
                    dataBaseThird.child('Third').update({
                      'First Name': fieldKey,
                      'Second Name': fieldSecondKey,
                    });
                  },
                  child: Text("Edit for Second"),
                ),
                MaterialButton(
                  onPressed: () {
                    dataBaseThird.child('Third').remove();
                  },
                  child: Text("Delete for Second"),
                ),*/
              ],
            ),
          ),
        ),
      ),
    );
  }
}
