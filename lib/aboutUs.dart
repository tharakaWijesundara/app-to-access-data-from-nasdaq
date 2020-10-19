
import 'package:flutter/material.dart';
class aboutUs extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title:Text('Developer details'),
        centerTitle: true,
        actions: <Widget>[
          Padding(
              padding: EdgeInsets.only(right: 20.0),
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.fromLTRB(20, 100, 20, 20),
            child: Column(
              children: <Widget>[
                Image.asset(
                    'assets/hexcodeLogo.png',
                  width: 200,
                  height: 200,
                ),
                Text("2020 \u00a9 Hexcode Labs Developers",style: TextStyle(
                  fontSize: 15,
                  color: Colors.grey
                ),),
                Text("hexcode.labs@gmail.com",style: TextStyle(
                    fontSize: 15,
                    color: Colors.grey
                ),)
              ],
            )
        ),

      ),
    );
  }
}
