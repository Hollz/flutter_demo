import 'package:flutter/material.dart';
import '../service/service_method.dart';
import 'dart:convert';

class CategoryPage extends StatefulWidget {
  _CategoryPageState createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  @override
  Widget build(BuildContext context) {
    _getCategory();
    return Container(
       child: Text("data"),
    );
  }

  void _getCategory() async{
    request("getCategory").then((val){
      var data = json.decode(val.toString());
      print(data);
    });
  }
}