import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        title: 'Flutter Demo',
        theme: new ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: new PhotoGrid());
  }
}

class PhotoGrid extends StatefulWidget {
  @override
  State createState() {
    return new PhotoGridState();
  }
}

class PhotoGridState extends State<PhotoGrid> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text('Flutter networking sample'),
        ),
        body: new FutureBuilder(
            future: _fetchPhotos(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return new ListView.builder(itemBuilder: (context, i) {
                  if (i.isOdd) return new Divider();
                  return _buildRow(snapshot.data[i] as Photo);
                });
              } else if (snapshot.hasError) {
                return new Text("Error");
              } else {
                return new Center(child: new CircularProgressIndicator());
              }
            }));
  }

  Future<List<Photo>> _fetchPhotos() async {
    final response =
        await http.get("https://jsonplaceholder.typicode.com/photos");
    final jsonArray = json.decode(response.body);
    final List<Photo> list = new List();
    for (var photo in jsonArray) {
      list.add(new Photo.fromJson(photo));
    }
    return list;
  }

  Widget _buildRow(Photo photo) {
    return new ListTile(
        onTap: () {
          openUrl(photo.url);
        },
        title: new Row(
          children: <Widget>[
            new FadeInImage.assetNetwork(
                placeholder: 'images/placeholder.png',
                image: photo.thumbnailUrl,
                fit: BoxFit.cover),
            new Expanded(
              child: new Container(
                padding: const EdgeInsets.all(8.0),
                child: new Text(photo.title),
              ),
            ),
          ],
        ));
  }

  void openUrl(String url) {
    Navigator.of(context).push(new MaterialPageRoute(
      builder: (context) {
        return new Scaffold(
            appBar: new AppBar(
              title: new Text('Saved Suggestions'),
            ),
            body: new Stack(
              children: <Widget>[
                new Center(child: new CircularProgressIndicator()),
                new Center(
                  child: new FadeInImage.assetNetwork(
                      placeholder: 'images/placeholder.png',
                      image: url,
                      fadeInDuration: new Duration(milliseconds: 200),
                      fit: BoxFit.cover),
                ),
              ],
            ));
      },
    ));
  }
}

/// {
///   "albumId": 1,
///   "id": 2,
///   "title": "reprehenderit est deserunt velit ipsam",
///   "url": "http://placehold.it/600/771796",
///   "thumbnailUrl": "http://placehold.it/150/771796"
/// }
class Photo {
  final int albumId;
  final int id;
  final String title;
  final String url;
  final String thumbnailUrl;

  Photo({this.albumId, this.id, this.title, this.url, this.thumbnailUrl});

  factory Photo.fromJson(Map<String, dynamic> json) {
    return new Photo(
      albumId: json['albumId'],
      id: json['id'],
      title: json['title'],
      url: json['url'],
      thumbnailUrl: json['thumbnailUrl'],
    );
  }
}
