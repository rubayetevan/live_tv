import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tv/pages/tvPlayer.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Live TV'),
      ),
      body: SafeArea(
        child: Container(
          child: StreamBuilder<QuerySnapshot>(
            stream: Firestore.instance.collection('channels').orderBy('name').snapshots(),
            builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) return Text('Error: ${snapshot.error}');
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                default:
                  return GridView.count(
                    crossAxisCount: (MediaQuery.of(context).size.width / 120.0).round(),
                    children: snapshot.data.documents.map((DocumentSnapshot document) {
                      return Padding(
                        padding: EdgeInsets.all(5.0),
                        child: RaisedButton(
                          onPressed: () {
                            Navigator.push(
                              FocusManager.instance.primaryFocus.context,
                              MaterialPageRoute(builder: (context) => TVPlayerPage(document['url'])),
                            );
                          },
                          color: Colors.lightBlue.shade50,
                          child: Text(document['name']),
                        ),
                      );
                    }).toList(),
                  );
              }
            },
          ),
        ),
      ),
    );
  }
}
