import 'package:flutter/material.dart';
import '../service/service_method.dart';
import 'dart:convert';
import '../model/category.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../provide/child_category.dart';
import 'package:provide/provide.dart';

class CategoryPage extends StatefulWidget {
  _CategoryPageState createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("分类列表"),
      ),
      body: Container(
        child: Row(
          children: <Widget>[
            LeftCategoryNav(),
            Column(
              children: <Widget>[RightCategoryNav()],
            )
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
var listIndex = 0;

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
            border: Border(right: BorderSide(width: 1, color: Colors.black12))),
        child: ListView.builder(
          itemCount: list.length,
          itemBuilder: (context, index) {
            return _getLeftInkWell(index);
          },
        ),
      ),
    );
  }

  Widget _getLeftInkWell(int index) {
    bool isClick = false;
    isClick = (listIndex == index) ? true : false;

    return InkWell(
      onTap: () {
        setState(() {
          listIndex = index;
        });

        var childList = list[index].bxMallSubDto;
        Provide.value<ChildCategory>(context).getChildCategory(childList);
      },
      child: Container(
        height: ScreenUtil().setHeight(100),
        padding: EdgeInsets.only(left: 10.0, top: 20.0),
        decoration: BoxDecoration(
            color: isClick?Color.fromRGBO(236, 238, 239, 1.0):Colors.white,
            border:
                Border(bottom: BorderSide(width: 1, color: Colors.black12))),
        child: Text(
          list[index].mallCategoryName,
          style: TextStyle(fontSize: ScreenUtil().setSp(28)),
        ),
      ),
    );
  }

  void _getCategory() async {
    await request("getCategory").then((val) {
      var data = json.decode(val.toString());

      CategoryModel category = CategoryModel.fromJson(data);

      setState(() {
        list = category.data;
      });

      Provide.value<ChildCategory>(context).getChildCategory(list[0].bxMallSubDto);
    });
  }
}

class RightCategoryNav extends StatefulWidget {
  _RightCategoryNavState createState() => _RightCategoryNavState();
}

class _RightCategoryNavState extends State<RightCategoryNav> {
  @override
  Widget build(BuildContext context) {
    return Container(child: Provide<ChildCategory>(
      builder: (context, child, childCategory) {
        return Container(
          height: ScreenUtil().setHeight(80),
          width: ScreenUtil().setWidth(570),
          decoration: BoxDecoration(
              border:
                  Border(bottom: BorderSide(width: 1, color: Colors.black12))),
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: childCategory.childCategoryList.length,
            itemBuilder: (context, index) {
              return _rightInkWell(childCategory.childCategoryList[index]);
            },
          ),
        );
      },
    ));
  }

  Widget _rightInkWell(BxMallSubDto item) {
    return InkWell(
      onTap: () {},
      child: Container(
        padding: EdgeInsets.fromLTRB(5.0, 10.0, 5.0, 10.0),
        child: Text(
          item.mallSubName,
          style: TextStyle(fontSize: ScreenUtil().setSp(28)),
        ),
      ),
    );
  }
}
