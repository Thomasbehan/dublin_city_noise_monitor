import 'package:flutter/material.dart';
import 'package:screen/screen.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Places extends StatefulWidget {
  Places({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _PlacesState createState() => _PlacesState();
}

class _PlacesState extends State<Places> {

  void keepScreenOn() {
    // Prevent screen from going into sleep mode:
    Screen.keepOn(true);
  }
  List locations = [];
  Future<List> _getLocationIndex() async {
    var data = await http.get('http://dublincitynoise.sonitussystems.com/applications/api/dublinnoisedata.php?returnLocationStrings=true&location=all', headers: {"Accept": "application/json"});

    setState(() {
      print(data);
      locations = json.decode(data.body);
    });

  }

  @override
  void initState() {
    this.keepScreenOn();
    this._getLocationIndex();
  }


  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text('Noice Monitor Locations'),
        ),
        body: new ListView.builder(
            itemCount: locations == [] ? 1 : locations.length,
            itemBuilder: (BuildContext context, i) {
              if (locations == []) {
                return new ListTile(
                    title: new Text("Loading"),
                    subtitle: new Text("..."),
                    leading: new CircleAvatar(
                      backgroundImage:
                      new NetworkImage('https://media0.giphy.com/media/3oEjI6SIIHBdRxXI40/giphy.gif'),
                    )
                );
              } else {
                return new ListTile(
                    title: new Text(locations[i]),
                    subtitle: new Text(locations[i]),
                    leading: new CircleAvatar(
                      backgroundImage:
                      new NetworkImage('http://www.iconninja.com/files/438/273/222/location-optimization-geo-map-place-icon.png'),
                    )
                );
              }

            }
        ));
  }
}
