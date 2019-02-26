import 'package:flutter/material.dart';
import '../service/service_method.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'dart:convert';

class HomePage extends StatefulWidget {
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String homePageContent = '正在获取数据...';

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        appBar: AppBar(
          title: Text('百姓生活+'),
        ),
        body:FutureBuilder(
          future: getHomeContent(),
          builder: (context,snapshot){
            if (snapshot.hasData) {
              var data = json.decode(snapshot.data.toString());

              List<Map> swiperDataList = (data['data']['slides'] as List).cast();
              return Column(
                  children: <Widget>[
                    MySwiper(swiperDataList: swiperDataList,),
                  ],
              );
            }else{
                return Center(
                  child: Text('加载中...'),
                );
            }
          },
        ),
      ),
    );
  }
}

class MySwiper extends StatelessWidget {
  final List swiperDataList;
  MySwiper({Key key,this.swiperDataList}):super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 190,
      child: Swiper(
        itemBuilder: (BuildContext contxt,int index){
          return Image.network("${swiperDataList[index]['image']}",fit:BoxFit.fill);
        },
        itemCount: swiperDataList.length,
        pagination: SwiperPagination(),
        autoplay: true,
      ),
    );
  }
}
