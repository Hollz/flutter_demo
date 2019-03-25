import 'package:flutter/material.dart';
import '../service/service_method.dart';
import 'dart:convert';
import '../model/category.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CategoryPage extends StatefulWidget {
  _CategoryPageState createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {


  @override
  Widget build(BuildContext context) {
  
    return Scaffold(
      appBar:AppBar(title: Text("分类列表"),),
      body: Container(
        child: Row(
          children: <Widget>[
            LeftCategoryNav()
          ],
        ),
      ),
    );
  }

  
}

class LeftCategoryNav extends StatefulWidget {

  _LeftCategoryNavState createState() => _LeftCategoryNavState();
}


  List list = [];


class _LeftCategoryNavState extends State<LeftCategoryNav> {

  void initState() { 
    _getCategory();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Container(
       child: Container(
         width: ScreenUtil().setWidth(180),
         decoration: BoxDecoration(
          border: Border(
            right: BorderSide(width: 1,color: Colors.black12)
          )
         ),
         child: ListView.builder(
           itemCount: list.length,
           itemBuilder: (context,index){
             return _getLeftInkWell(index);
           },
         ),
       ),
    );
  }

  Widget _getLeftInkWell(int index){
  
    return InkWell(
      onTap: (){},
      child: Container(
        height: ScreenUtil().setHeight(100),
        padding: EdgeInsets.only(left: 10.0,top: 20.0),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            bottom: BorderSide(width: 1,color: Colors.black12)
          )
        ),
        child: Text(list[index].mallCategoryName ,style: TextStyle(fontSize: ScreenUtil().setSp(28)),),
      ),
    );
  }


  void _getCategory() async{
    request("getCategory").then((val){
      var data = json.decode(val.toString());

      CategoryModel category = CategoryModel.fromJson(data);
     
      setState(() {
        list = category.data;
      });
    });
  }
}