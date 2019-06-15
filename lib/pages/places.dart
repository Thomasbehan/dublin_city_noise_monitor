import 'package:flutter/material.dart';
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

  List locations = [];
  List noises = [];
  Future<List> _getLocationIndex() async {
    var data = await http.get('http://dublincitynoise.sonitussystems.com/applications/api/dublinnoisedata.php?returnLocationStrings=true&location=all', headers: {"Accept": "application/json"});
    await this._getNoiseData();
    setState(() {
      locations = json.decode(data.body);
    });
    return locations;
  }

  Future<List> _getNoiseData() async {

    for (var i = 1; i < locations.length; i++) {
      print(i);
      var noiseData = await http.get('http://dublincitynoise.sonitussystems.com/applications/api/dublinnoisedata.php?location=$i', headers: {"Accept": "application/json"});
      noises.add(json.decode(noiseData.body));
    }

    return noises;
  }

  @override
  void initState() {
    this._getLocationIndex();
  }

  @override
  Widget build(BuildContext context) {

    final topAppBar = AppBar(
      elevation: 0.1,
      backgroundColor: Color.fromRGBO(58, 66, 86, 1.0),
      title: Text(widget.title),
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.menu),
          onPressed: () {},
        )
      ],
    );


    final makeBody = Container(
      child: new ListView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemCount: locations == [] ? 0 : locations.length,
        itemBuilder: (BuildContext context, int index) {
          return Card(
            elevation: 8.0,
            margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
            child: Container(
              decoration: BoxDecoration(color: Color.fromRGBO(64, 75, 96, .9)),
              child: ListTile(
                  contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                  leading: Container(
                    padding: EdgeInsets.only(right: 12.0),
                    decoration: new BoxDecoration(
                        border: new Border(
                            right: new BorderSide(width: 1.0, color: Colors.white24))),
                    child: Icon(Icons.autorenew, color: Colors.white),
                  ),
                  title: Text(
                    locations[index],
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  // subtitle: Text("Intermediate", style: TextStyle(color: Colors.white)),

                  subtitle: Row(
                    children: <Widget>[
                      Icon(Icons.surround_sound, color: Colors.yellowAccent),
                      Text(noises[index]["aleq"][noises[index]["entries"] -1], style: TextStyle(color: Colors.white)) // noises[index]["aleq"]
                    ],
                  ),
                  trailing:
                  Icon(Icons.keyboard_arrow_right, color: Colors.white, size: 30.0)),
            ),
          );
        },
      ),
    );

     return Scaffold(
        backgroundColor: Color.fromRGBO(58, 66, 86, 1.0),
        appBar: topAppBar,
        body:FutureBuilder<List>(
            future: _getLocationIndex(),
            builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
              if(noises.length == locations.length) {
                return new ListTile(
                    title: new Text("Loading"),
                    subtitle: new Text("..."),
                    leading: new CircleAvatar(
                      backgroundImage:
                      new NetworkImage('https://media0.giphy.com/media/3oEjI6SIIHBdRxXI40/giphy.gif'),
                    )
                );
              }else {
                return makeBody;
              }
            })
          );

  }
}
