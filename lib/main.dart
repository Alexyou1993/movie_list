import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() => runApp(MaterialApp(
      home: HomePage(),
      debugShowCheckedModeBanner: false,
    ));

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Map<String, dynamic> mapResponse;
  Map<String, dynamic> mapData;
  List<dynamic> movies;

  Future<String> fetchData() async {
    http.Response response;
    response = await http.get('https://yts.mx/api/v2/list_movies.json?limit=5&page=5&rating=7');
    if (response.statusCode == 200) {
      setState(() {
        mapResponse = json.decode(response.body.toString()) as Map<String, dynamic>;
        mapData = mapResponse['data'] as Map<String, dynamic>;
        movies = mapData['movies'] as List<dynamic>;
      });
    } else {
      return throw Exception('Failed to load page');
    }
  }

  @override
  void initState() {
    fetchData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fetch Data from Internet'),
        backgroundColor: Colors.blue[900],
      ),
      body: mapResponse == null
          ? Container()
          : SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Text(
                    mapResponse['status_message'].toString(),
                    style: const TextStyle(fontSize: 30),
                  ),
                  ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemBuilder: (BuildContext context, int index) {
                      return Container(
                        margin: const EdgeInsets.all(8),
                        child: Column(
                          children: <Widget>[
                            Image.network((movies[index]['medium_cover_image']).toString()),
                            Text(
                              movies[index]['title'].toString(),
                              style: const TextStyle(fontSize: 30),
                            ),
                          ],
                        ),
                      );
                    },
                    itemCount: movies == null ? 0 : movies.length,
                  ),
                ],
              ),
            ),
    );
  }
}
