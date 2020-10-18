import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:xml2json/xml2json.dart';
import 'dart:convert';
import 'dart:async';

void main() => runApp(IosApp());

class IosApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Ios App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: codesViewer(),
    );
  }
}

class codesViewer extends StatefulWidget {
  @override
  _codesViewerState createState() => _codesViewerState();
}

class _codesViewerState extends State<codesViewer> {
  final Xml2Json xml2json = Xml2Json();
  Future<String> myFuture;
  Size screenSize(BuildContext context) {
    return MediaQuery.of(context).size;
  }

  @override
  void initState() {
    super.initState();
    myFuture = getData();
  }

  /////////////for testing///////////
  List<Map<String, dynamic>> results = [
    {"haltTime": "04:27:40", "issueSymbol": "ATHE", "reasonCodes": "AB"},
    {"haltTime": "04:27:45", "issueSymbol": "ATH", "reasonCodes": "ABC"},
    {"haltTime": "04:27:46", "issueSymbol": "AT", "reasonCodes": "AC"}
  ];
  //////////////////////////////////

  List<Map<String, dynamic>> rawData = [];
  List<Map<String, dynamic>> rowData = [];

  Future<String> getData() async {
    try {
      Response response =
          await get("http://www.nasdaqtrader.com/rss.aspx?feed=tradehalts");
      xml2json.parse(utf8.decode(response.bodyBytes));
      var jsonData = xml2json.toGData();
      var data = json.decode(jsonData);

      Map<String, dynamic> obj = {
        'haltTime': null,
        'issueSymbol': null,
        'reasonCodes': null
      };
      int noOfRows = int.parse(data['rss']['channel']["ndaq\$numItems"]["\$t"]);
      if (noOfRows == 1) {
        rawData.add(data['rss']['channel']['item']);
      } else {
        rawData = data['rss']['channel']['item'];
      }
      setState(() {
        for (var data in rawData) {
          obj['haltTime'] = data['ndaq\$HaltTime']['\$t'];
          obj['issueSymbol'] = data['ndaq\$IssueSymbol']['\$t'];
          obj['reasonCodes'] = data['ndaq\$ReasonCode']['\$t'];

          rowData.add(obj);
        }
      });
//      print(data);
      print("done");
      print(rowData[0]);
      return "done";
    } catch (e) {
      print(e);
      return null;
    }
//    print(json.decode(utf8.decode(response.bodyBytes)));
    //return "successful";
  }

  DataRow _getDataRow(data, width, index) {
    Color rowColor(int index) {
      if (index % 2 == 0) {
        return Colors.white;
      } else {
        return Colors.blue[50];
      }
    }

    return DataRow(
      cells: <DataCell>[
        DataCell(Container(
          color: rowColor(index),
          width: width / 3.6,
          height: 35,
          child: Center(
              child: Text(
            data["haltTime"],
            style: TextStyle(fontSize: 15, color: Colors.blue[900]),
          )),
        )),
        DataCell(Container(
          color: rowColor(index),
          width: width / 3.6,
          height: 35,
          child: Center(
              child: Text(
            data["issueSymbol"],
            style: TextStyle(fontSize: 15, color: Colors.blue[900]),
          )),
        )),
        DataCell(Container(
          color: rowColor(index),
          width: width / 3.6,
          height: 35,
          child: Center(
              child: Text(
            data["reasonCodes"],
            style: TextStyle(fontSize: 15, color: Colors.blue[900]),
          )),
        )),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final double width = screenSize(context).width;
    return Container(
        child: Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Center(child: const Text('Custom app')),
      ),
      body: FutureBuilder(
        future: myFuture,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.data == null) {
            return (Center(
              child: CircularProgressIndicator(),
            ));
          } else {
            return Padding(
              padding: new EdgeInsets.all(10.0),
              child: SingleChildScrollView(
                  child: Center(
                      child: Container(
                          padding: new EdgeInsets.all(5.0),
                          width: width,
                          child: Center(
                            child: DataTable(
                              columnSpacing: 0,
                              horizontalMargin: 0,
                              columns: [
                                DataColumn(
                                    label: Center(
                                        child: Container(
                                  decoration: BoxDecoration(
                                    color: const Color(0xff7c94b6),
                                    borderRadius: BorderRadius.circular(2),
                                  ),
                                  width: width / 3.6,
                                  height: 50,
                                  alignment: Alignment.center,
                                  //color: Colors.blue[50],
                                  child: Center(
                                    child: Text('Halt time',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15,
                                            color: Colors.blue[900])),
                                  ),
                                ))),
                                DataColumn(
                                    label: Center(
                                        child: Container(
                                  decoration: BoxDecoration(
                                    color: const Color(0xff7c94b6),
                                    borderRadius: BorderRadius.circular(2),
                                  ),
                                  width: width / 3.6,
                                  height: 50,
                                  alignment: Alignment.center,
                                  child: Center(
                                    child: Text('Issue symbol',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15,
                                            color: Colors.blue[900])),
                                  ),
                                ))),
                                DataColumn(
                                    label: Center(
                                        child: Container(
                                  decoration: BoxDecoration(
                                    color: const Color(0xff7c94b6),
                                    borderRadius: BorderRadius.circular(2),
                                  ),
                                  width: width / 3.6,
                                  height: 50,
                                  alignment: Alignment.center,
                                  child: Center(
                                    child: Text('Reason codes',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15,
                                            color: Colors.blue[900])),
                                  ),
                                ))),
                              ],
                              rows: List.generate(
                                  rowData.length,
                                  (index) => _getDataRow(
                                      rowData[index],
                                      MediaQuery.of(context).size.width,
                                      index)),
                            ),
                          )))),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            rawData = [];
            rowData = [];
          });
          getData();
        },
        child: Icon(Icons.refresh),
        backgroundColor: Colors.green,
      ),
    ));
  }
}
