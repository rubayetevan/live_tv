import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';

import 'tvPlayer.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('EBOX TV'),
      ),
      body: SafeArea(
        child: Container(
          child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection('channels').orderBy('name').snapshots(),
            builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) return Text('Error: ${snapshot.error}');
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                default:
                  return Padding(
                    padding: EdgeInsets.all(3),
                    child: GridView.count(
                      crossAxisSpacing: 3,
                      mainAxisSpacing: 3,
                      crossAxisCount: (MediaQuery.of(context).size.width / 120.0).round(),
                      children: snapshot.data.docs.map((DocumentSnapshot document) {
                        return Padding(
                          padding: EdgeInsets.all(5.0),
                          child: RaisedButton(
                            onPressed: () {
                              Navigator.push(
                                FocusManager.instance.primaryFocus.context,
                                MaterialPageRoute(
                                    builder: (context) => TVPlayerPage(document['url'], document['name'])),
                              );
                            },
                            color: Colors.white,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Container(
                                  height: 90,
                                  width: 90,
                                  child: (!kIsWeb)
                                      ? CachedNetworkImage(
                                          imageUrl: document['logo'],
                                    imageBuilder: (context, imageProvider) => Container(
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          image: imageProvider, fit: BoxFit.contain),
                                      ),
                                    ),
                                    placeholder: (context, url) => LinearProgressIndicator(),
                                    errorWidget: (context, url, error) => Icon(Icons.error),
                                  ) : Image.network(document['logo']),
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  );
              }
            },
          ),
        ),
      ),
    );
  }
}
