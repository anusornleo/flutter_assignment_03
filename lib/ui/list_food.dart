import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ListFood extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return TodoScreenState();
  }
}

// class ListFoodState extends State<ListFood> {
//   List<Map<String, String>> _listFood = [];
//   String filter;

//   @override
//   Widget _buildBody(BuildContext context) {
//     return StreamBuilder<QuerySnapshot>(
//       stream: Firestore.instance.collection('todo').snapshots(),
//       builder: (context, snapshot) {
//         if (!snapshot.hasData)
//           return Container(
//               color: Color.fromARGB(200, 255, 255, 255), child: Center());
//         return _buildList(context, snapshot.data.documents);
//       },
//     );
//   }

//   @override
//   void initState() {
//     super.initState();
//     _buildBody(context);
//   }

//   Widget _buildList(BuildContext context, List<DocumentSnapshot> snapshot) {
//     if (_listFood.length < snapshot.length) {
//       for (int i = 0; i < snapshot.length; i++) {
//         _listFood.add({
//           "name": snapshot[i].data["title"].toString(),
//           "done": snapshot[i].data["done"].toString(),
//         });
//       }
//     }
//     return Scaffold(
//         appBar: AppBar(title: Text("data")),
//         body: new Container(
//             child: ListView.builder(
//           shrinkWrap: true,
//           itemCount: _listFood.length,
//           itemBuilder: (BuildContext context, int index) {
//             return new ListTile(
//               title: new Text(_listFood[index]['name']),
//               onTap: () {},
//               trailing: Text(_listFood[index]['done']),
//             );
//           },
//         )));
//   }

//   Widget build(BuildContext context) {
//     return _buildBody(context);
//   }
// }

class TodoScreenState extends State {
  List<Map<String, String>> _listFood = [];
  List<Map<String, String>> _listTask = [];
  List<Map<String, String>> _listDone = [];
  int _current_state = 0;
  int countTodo = 0;
  int countDone = 0;

  Widget build(BuildContext context) {
    return _buildBody(context);
  }

  @override
  Widget _buildBody(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('todo').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData)
          return Container(
              color: Color.fromARGB(200, 255, 255, 255), child: Center());
        return _buildList(context, snapshot.data.documents);
      },
    );
  }

  Widget _buildList(BuildContext context, List<DocumentSnapshot> snapshot) {
    print(snapshot.toList());
    if (_listTask.length + _listDone.length < snapshot.length) {
      for (int i = 0; i < snapshot.length; i++) {
        if (snapshot[i].data['done'] == false) {
          _listTask.add({
            "title": snapshot[i].data["title"].toString(),
            "done": snapshot[i].data["done"].toString(),
          });
        } else {
          _listDone.add({
            "title": snapshot[i].data["title"].toString(),
            "done": snapshot[i].data["done"].toString(),
          });
        }
      }
    }

    List current_tab = <Widget>[
      IconButton(
        icon: Icon(Icons.add),
        onPressed: () {
          // Navigator.push(
          //     context, MaterialPageRoute(builder: (context) => AddSrceen()));
        },
      ),
      IconButton(
        icon: Icon(Icons.delete),
        onPressed: () {},
      )
    ];

    List current_screen = [
      // countTodo == 0
      //     ? Text("No data found..")
      //     :
      ListView.builder(
        itemCount: _listTask.length,
        itemBuilder: (context, int position) {
          print(_listTask);
          return Column(
            children: <Widget>[
              Divider(
                height: 5.0,
              ),
              ListTile(
                title: Text(
                  _listTask[position]['title'] + _listTask[position]['done'],
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
                // trailing: Checkbox(
                //     onChanged: (bool value) {
                //       setState(() {
                //         listTodo[position].done = value;
                //       });
                //       db.update(listTodo[position]);
                //     },
                //     value: listTodo[position].done),
              )
            ],
          );
        },
      ),
      // countDone == 0
      //     ? Text("No data found..")
      //     :
      ListView.builder(
        itemCount: _listDone.length,
        itemBuilder: (context, int position) {
          return Column(
            children: <Widget>[
              Divider(
                height: 5.0,
              ),
              ListTile(
                title: Text(
                  _listDone[position]['title'],
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
                // trailing: Checkbox(
                //     onChanged: (bool value) {
                //       setState(() {
                //         listTodoDone[position].done = value;
                //       });
                //       db.update(listTodoDone[position]);
                //     },
                //     value: listTodoDone[position].done),
              )
            ],
          );
        },
      ),
    ];
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Todo"),
          actions: <Widget>[
            _current_state == 0 ? current_tab[0] : current_tab[1]
          ],
          backgroundColor: Colors.blue,
        ),
        body: Center(
            child: _current_state == 0 ? current_screen[0] : current_screen[1]),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _current_state,
          items: [
            BottomNavigationBarItem(
                icon: Icon(Icons.list), title: Text('Task')),
            BottomNavigationBarItem(
                icon: Icon(Icons.done_all), title: Text('Complete'))
          ],
          onTap: (int index) {
            setState(() {
              _current_state = index;
            });
          },
        ),
      ),
    );
  }
}
