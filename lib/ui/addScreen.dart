import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AddSrceen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return AddlistSrceen();
  }
}

class AddlistSrceen extends State<AddSrceen> {
  final _formkey = GlobalKey<FormState>();
  TextEditingController textController = TextEditingController();

// add Data via Firebase
  addData() {
    if (textController.text.length > 0) {
      Firestore.instance.runTransaction((Transaction transaction) async {
        DocumentReference reference =
            Firestore.instance.collection('todo').document();
        await reference.setData({"title": textController.text, "done": 0});
      });
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('New Subject'),
        ),
        body: Stack(
          children: <Widget>[
            Container(
              margin: EdgeInsets.all(10.0),
              child: Form(
                key: _formkey,
                child: ListView(
                  children: <Widget>[
                    TextFormField(
                      autofocus: true, // auto focus on textfield
                      textInputAction: TextInputAction
                          .done, // make enter on keyboard as done
                      style: TextStyle(fontSize: 22),
                      controller: textController,
                      decoration: InputDecoration(labelText: 'Subject'),
                      onFieldSubmitted: (v) {
                        // when click done on keyboard. It will pop to Todo page
                        _formkey.currentState.validate();
                        addData();
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return "Please fill subject";
                        }
                      },
                    ),
                    RaisedButton(
                      child: Text(
                        'Save',
                        style: TextStyle(fontSize: 18),
                      ),
                      onPressed: () async {
                        _formkey.currentState.validate();
                        addData();
                      },
                    )
                  ],
                ),
              ),
            ),
          ],
        ));
  }
}
