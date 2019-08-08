import 'dart:developer';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'dart:convert';

// void main() => runApp(MyApp());

class DailyLog {
  final String lid;
  final String project, projclientname, projstatus;

  DailyLog({
    this.lid,
    this.project,
    this.projclientname,
    this.projstatus,
  });

  factory DailyLog.fromJson(Map<String, dynamic> jsonData) {
    return DailyLog(
      lid: jsonData['lid'],
      project: jsonData['project'],
      projclientname: jsonData['proj_client_name'],
      projstatus: jsonData['proj_status'],
    );
  }
}



class CustomListView extends StatelessWidget {

  final List<DailyLog> dailylog;
  CustomListView(this.dailylog);
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
        
    return ListView.builder(
      itemCount: dailylog.length,
      itemBuilder: (context, int currentIndex) {
        return createViewItem(dailylog[currentIndex], context);
      },
    );
    
  }

  Widget createViewItem(DailyLog dailyLog, BuildContext context){

    return new ListTile(
      title: new Card(
        elevation: 5.0,
        child: new Container(
          decoration: BoxDecoration(border: Border.all(color: Colors.orange)),
          padding: EdgeInsets.all(10.0),
          margin: EdgeInsets.all(10.0),

          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Padding(
                    child: Text(dailyLog.projclientname,
                    style: new TextStyle(fontWeight: FontWeight.bold),
                    textAlign: TextAlign.right,
                    ),
                  padding: EdgeInsets.all(1.0)),
                ],
              ),
              Row(
                children: <Widget>[
                  Padding(
                    child: Text(dailyLog.project,
                    style: new TextStyle(fontStyle: FontStyle.italic),
                    textAlign: TextAlign.right,
                    ),
                    padding: EdgeInsets.all(1.0)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
 Future <List<DailyLog>> downloadValue() async{
    final url = "";
    String user1 = 'admin';
    String pass = '1234';
    String basicAuth = 'Basic ' + base64Encode(utf8.encode('$user1:$pass'));

    var bodyvalue = jsonEncode({
    'user': "435"
    });
    print(bodyvalue);

    final response = await http.post(url, body: bodyvalue,headers: {'authorization': basicAuth,
          "content-type": "application/json"});

          print(response);
          final responseJson = json.decode(response.body);
          var responseObject = responseJson['daily_log_data'];
          print(responseJson);
          // print(responseJson['daily_log_data']);
          // print(responseObject);


          if(response.statusCode==200){
            List dailylog = responseJson['daily_log_data'];

            return dailylog.map((dailyLog)=> new DailyLog.fromJson(dailyLog)).toList();
          }else{
            throw Exception('We were not able to successfully download the json data.');
          }
  }

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      theme: new ThemeData(
        primarySwatch: Colors.deepOrange,
      ),
      home: new Scaffold(
        appBar: new AppBar(title: const Text('List View')),
        body: new Center(
          child: new FutureBuilder<List<DailyLog>>(
            future: downloadValue(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                List<DailyLog> dailyLog = snapshot.data;

                print(dailyLog);
                return new CustomListView(dailyLog);
              } else if (snapshot.hasError) {
                return Text('${snapshot.error}');
              }
              //return  a circular progress indicator.
              return new CircularProgressIndicator();
            },
          ),

        ),
      ),
    );
  }
}


void main() {
  runApp(MyApp());
}
