import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:health_app/ui/addScreen.dart';
import 'package:progress_indicators/progress_indicators.dart';

class TodoScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return TodoScreenState();
  }
}

class TodoScreenState extends State {
  List<Map<String, Object>> _listTask = [];
  List<Map<String, Object>> _listDone = [];
  int _currentState = 0; // check state of Tab (Task or Complete)
  int countTodo = 0;
  int countDone = 0;
  bool loading = false; // state to show loading

  Widget build(BuildContext context) {
    return _buildBody(context);
  }

  Widget _showCircularProgress() {
    // show Loading when data not complete
    if (loading) {
      return Scaffold(
          body: Center(
        child: FadingText('Loading...'),
      ));
    }
    return Container(
      width: 0,
      height: 0,
    );
  }

  @override
  Widget _buildBody(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('todo').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          loading = true;
          return _showCircularProgress();
        }
        return _buildList(context,
            snapshot.data.documents); // return data on firebase as snapshot
      },
    );
  }

  Widget _buildList(BuildContext context, List<DocumentSnapshot> snapshot) {
    loading = false;
    _listTask.clear(); // clear map when load data again
    _listDone.clear();
    if (_listTask.length + _listDone.length < snapshot.length) {
      for (int i = 0; i < snapshot.length; i++) {
        if (snapshot[i].data['done'] == 0) {
          _listTask.add({
            'id': snapshot[i].documentID, // get ID. use for delete
            "title": snapshot[i].data["title"].toString(),
            "done": false,
          });
        } else {
          _listDone.add({
            'id': snapshot[i].documentID,
            "title": snapshot[i].data["title"].toString(),
            "done": true,
          });
        }
      }
      // turn off loading...
    }

// array of Bottom Tap widget
    List _bottomTab = <Widget>[
      IconButton(
        icon: Icon(Icons.add),
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => AddSrceen()));
        },
      ),
      IconButton(
        icon: Icon(Icons.delete),
        onPressed: () {
          for (int i = 0; i < _listDone.length; i++) {
            Firestore.instance
                .collection('todo')
                .document(_listDone[i]['id']) // delete todo by ID
                .delete()
                .catchError((e) {
              print(e);
            });
          }
        },
      )
    ];

// list page of BottomBar
    List _currentScreen = [
      _listTask.length == 0
          ? Text("No data found..")
          : ListView.separated(
              itemCount: _listTask.length,
              itemBuilder: (context, int position) {
                return Column(
                  children: <Widget>[
                    ListTile(
                      title: Text(
                        _listTask[position]['title'],
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                      trailing: Checkbox(
                        value: _listTask[position]['done'],
                        onChanged: (bool value) {
                          setState(() {
                            Firestore.instance
                                .collection('todo')
                                .document(_listTask[position]['id'])
                                .updateData({'done': 1});
                          });
                        },
                      ),
                    )
                  ],
                );
              },
              separatorBuilder: (context, index) => Divider(
                    color: Colors.black,
                  ),
            ),
      _listDone.length == 0
          ? Text("No data found..")
          : ListView.separated(
              itemCount: _listDone.length,
              itemBuilder: (context, int position) {
                return Column(
                  children: <Widget>[
                    ListTile(
                      title: Text(
                        _listDone[position]['title'],
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                      trailing: Checkbox(
                        value: _listDone[position]['done'],
                        onChanged: (bool value) {
                          setState(() {
                            Firestore.instance
                                .collection('todo')
                                .document(_listDone[position]['id'])
                                .updateData({'done': 0});
                          });
                        },
                      ),
                    )
                  ],
                );
              },
              separatorBuilder: (context, index) => Divider(
                    color: Colors.black,
                  ),
            ),
    ];
    return DefaultTabController(
      // Bottom Tab
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Todo"),
          actions: <Widget>[_currentState == 0 ? _bottomTab[0] : _bottomTab[1]],
        ),
        body: Stack(
          children: <Widget>[
            Center(
                child:
                    _currentState == 0 ? _currentScreen[0] : _currentScreen[1]),
            _showCircularProgress(), // loading...
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentState,
          items: [
            BottomNavigationBarItem(
                icon: Icon(Icons.list), title: Text('Task')),
            BottomNavigationBarItem(
                icon: Icon(Icons.done_all), title: Text('Complete'))
          ],
          onTap: (int index) {
            setState(() {
              _currentState = index;
            });
          },
        ),
      ),
    );
  }
}
