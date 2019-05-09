import 'package:flutter/material.dart';
import '../service/service_method.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'dart:convert';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import '../routers/application.dart';
import 'package:provide/provide.dart';
import '../provide/child_category.dart';
import '../provide/currentIndex.dart';
import '../model/category.dart';

class HomePage extends StatefulWidget {
  _HomePageState createState() => _HomePageState();
}

GlobalKey<RefreshFooterState> _footerKey = new GlobalKey<RefreshFooterState>();

int page = 1;
List<Map> hotGoodsList = [];

class _HomePageState extends State<HomePage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  String homePageContent = '正在获取数据...';

  @override
  void initState() {
    super.initState();
    print('HomePageState');
  }

  @override
  Widget build(BuildContext context) {
    //初始化一次，全局可用
    ScreenUtil.instance = ScreenUtil(width: 750, height: 1334)..init(context);
    print('设备高度:${ScreenUtil.screenHeight}');
    print('设备宽度:${ScreenUtil.screenWidth}');
    print('设备密度:${ScreenUtil.pixelRatio}');
    return Container(
      child: Scaffold(
        appBar: AppBar(
          title: Text('百姓生活+'),
        ),
        body: FutureBuilder(
          future: request("homePageContext",
              formData: {'lon': '115.02932', 'lat': '35.76189'}),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              var data = json.decode(snapshot.data.toString());

              List<Map> swiperDataList =
                  (data['data']['slides'] as List).cast();
              List<Map> navigatorList =
                  (data['data']['category'] as List).cast();
              String advertesPicture =
                  data['data']["advertesPicture"]["PICTURE_ADDRESS"];

              String leaderImage = data['data']['shopInfo']['leaderImage'];
              String leaderPhone = data['data']['shopInfo']['leaderPhone'];

              List<Map> recommendlist =
                  (data['data']['recommend'] as List).cast();

              String floor1Pic = data['data']['floor1Pic']["PICTURE_ADDRESS"];
              String floor2Pic = data['data']['floor2Pic']["PICTURE_ADDRESS"];
              String floor3Pic = data['data']['floor3Pic']["PICTURE_ADDRESS"];

              List<Map> floor1 = (data['data']['floor1'] as List).cast();
              List<Map> floor2 = (data['data']['floor2'] as List).cast();
              List<Map> floor3 = (data['data']['floor3'] as List).cast();

              return EasyRefresh(
                refreshFooter: ClassicsFooter(
                  key: _footerKey,
                  bgColor: Colors.white,
                  textColor: Colors.pink,
                  moreInfoColor: Colors.pink,
                  showMore: true,
                  noMoreText: "",
                  moreInfo: "加载中...",
                  loadText: "",
                  loadReadyText: "上拉加载...",
                ),
                child: ListView(
                  children: <Widget>[
                    MySwiper(
                      swiperDataList: swiperDataList,
                    ),
                    TopNavigator(
                      navigatorList: navigatorList,
                    ),
                    ADBanner(
                      advertesPicture: advertesPicture,
                    ),
                    LeaderPhone(
                      leaderImage: leaderImage,
                      leaderPhone: leaderPhone,
                    ),
                    Recommend(
                      recommendList: recommendlist,
                    ),
                    FlootTitle(
                      pictureAddress: floor1Pic,
                    ),
                    FlootContent(
                      flootGoodsList: floor1,
                    ),
                    FlootTitle(
                      pictureAddress: floor2Pic,
                    ),
                    FlootContent(
                      flootGoodsList: floor2,
                    ),
                    FlootTitle(
                      pictureAddress: floor3Pic,
                    ),
                    FlootContent(
                      flootGoodsList: floor3,
                    ),
                    HotGoods(),
                  ],
                ),
                loadMore: () async {
                  print("加载更多");
                  var formPage = {"page": page};
                  request("homePageBelowConten", formData: formPage)
                      .then((val) {
                    var data = json.decode(val);
                    List<Map> newGoodsList = (data['data'] as List).cast();
                    setState(() {
                      hotGoodsList.addAll(newGoodsList);
                      page++;
                    });
                  });
                },
              );
            } else {
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
  MySwiper({Key key, this.swiperDataList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: ScreenUtil.getInstance().setHeight(333),
      width: ScreenUtil.getInstance().setWidth(750),
      child: Swiper(
        onTap: (index) {
          Application.router.navigateTo(
              context, '/detail?id=${swiperDataList[index]['goodsId']}');
        },
        itemBuilder: (BuildContext contxt, int index) {
          return Image.network("${swiperDataList[index]['image']}",
              fit: BoxFit.fill);
        },
        itemCount: swiperDataList.length,
        pagination: SwiperPagination(),
        autoplay: true,
      ),
    );
  }
}

class TopNavigator extends StatelessWidget {
  final List navigatorList;

  TopNavigator({Key key, this.navigatorList}) : super(key: key);

  Widget _getViewItemUI(BuildContext context, item, index) {
    return InkWell(
      onTap: () {
        _goCategory(context, index, item['mallCategoryId']);
      },
      child: Column(
        children: <Widget>[
          Image.network(
            item['image'],
            width: ScreenUtil.getInstance().setWidth(95),
          ),
          Text(item["mallCategoryName"]),
        ],
      ),
    );
  }

  void _goCategory(context, index, String categoryId) async {
    await request('getCategory').then((val) {
      var data = json.decode(val.toString());
      var category = CategoryModel.fromJson(data);
      List list = category.data;

      Provide.value<ChildCategory>(context).changeCategory(categoryId, index);
      Provide.value<ChildCategory>(context)
          .getChildCategory(list[index].bxMallSubDto, categoryId);
      Provide.value<CurrentIndexProvide>(context).changeIndex(1);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (this.navigatorList.length > 10) {
      this.navigatorList.removeRange(10, this.navigatorList.length);
    }
    var tempIndex = -1;
    return Container(
      height: ScreenUtil.getInstance().setHeight(320),
      padding: EdgeInsets.all(3.0),
      child: GridView.count(
        physics: NeverScrollableScrollPhysics(),
        crossAxisCount: 5,
        padding: EdgeInsets.all(5.0),
        children: navigatorList.map((item) {
          tempIndex++;
          return _getViewItemUI(context, item, tempIndex);
        }).toList(),
      ),
    );
  }
}

class ADBanner extends StatelessWidget {
  final String advertesPicture;

  ADBanner({Key key, this.advertesPicture}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Image.network(advertesPicture),
    );
  }
}

class LeaderPhone extends StatelessWidget {
  final String leaderImage;
  final String leaderPhone;

  LeaderPhone({Key key, this.leaderImage, this.leaderPhone}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: InkWell(
        onTap: _launcheURL,
        child: Image.network(leaderImage),
      ),
    );
  }

  void _launcheURL() async {
    String url = 'tel:' + leaderPhone;
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could notlanuch $url';
    }
  }
}

class Recommend extends StatelessWidget {
  final List recommendList;

  Recommend({Key key, this.recommendList}) : super(key: key);

  Widget _titleWidget() {
    return Container(
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.fromLTRB(10.0, 2.0, 0, 5.0),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(width: 0.5, color: Colors.black12),
        ),
      ),
      child: Text(
        "商品推荐",
        style: TextStyle(color: Colors.pink),
      ),
    );
  }

  Widget _item(context, index) {
    return InkWell(
      onTap: () {
        Application.router.navigateTo(
            context, "/detail?id=${recommendList[index]['goodsId']}");
      },
      child: Container(
        height: ScreenUtil().setHeight(333),
        width: ScreenUtil().setWidth(250),
        padding: EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            left: BorderSide(width: 0.5, color: Colors.black12),
          ),
        ),
        child: Column(
          children: <Widget>[
            Image.network(recommendList[index]['image']),
            Text("¥${recommendList[index]['mallPrice']}"),
            Text(
              "¥${recommendList[index]['price']}",
              style: TextStyle(
                  decoration: TextDecoration.lineThrough, color: Colors.grey),
            )
          ],
        ),
      ),
    );
  }

  Widget _recommendList() {
    return Container(
      height: ScreenUtil().setHeight(333),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: recommendList.length,
        itemBuilder: (context, index) {
          return _item(context, index);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // height: ScreenUtil().setHeight(380),
      margin: EdgeInsets.only(top: 10.0),
      child: Column(
        children: <Widget>[_titleWidget(), _recommendList()],
      ),
    );
  }
}

class FlootTitle extends StatelessWidget {
  final String pictureAddress;

  FlootTitle({Key key, this.pictureAddress}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8.0),
      child: Image.network(pictureAddress),
    );
  }
}

class FlootContent extends StatelessWidget {
  final List flootGoodsList;

  FlootContent({Key key, this.flootGoodsList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          _firstRow(context),
          _otherGoods(context),
        ],
      ),
    );
  }

  Widget _firstRow(BuildContext context) {
    return Row(
      children: <Widget>[
        _goodsItem(context, flootGoodsList[0]),
        Column(
          children: <Widget>[
            _goodsItem(context, flootGoodsList[1]),
            _goodsItem(context, flootGoodsList[2]),
          ],
        ),
      ],
    );
  }

  Widget _otherGoods(BuildContext context) {
    return Row(
      children: <Widget>[
        _goodsItem(context, flootGoodsList[3]),
        _goodsItem(context, flootGoodsList[4]),
      ],
    );
  }

  Widget _goodsItem(BuildContext context, Map goods) {
    return Container(
      width: ScreenUtil().setWidth(375),
      child: InkWell(
        onTap: () {
          print('点击了商品');
          Application.router
              .navigateTo(context, "/detail?id=${goods['goodsId']}");
        },
        child: Image.network(goods['image']),
      ),
    );
  }
}

class HotGoods extends StatefulWidget {
  _HotGoodsState createState() => _HotGoodsState();
}

class _HotGoodsState extends State<HotGoods> {
  @override
  void initState() {
    _getHotGoods();
    super.initState();
  }

  void _getHotGoods() async {
    var formPage = {"page": page};
    request("homePageBelowConten", formData: formPage).then((val) {
      var data = json.decode(val.toString());
      List<Map> newGoodsList = (data['data'] as List).cast();
      if (this.mounted) {
        //是否加载
        setState(() {
          hotGoodsList.addAll(newGoodsList);
          page++;
        });
      }
    });
  }

  //火爆专区头部
  Widget _hotTile = Container(
    margin: EdgeInsets.only(top: 10.0),
    padding: EdgeInsets.all(5.0),
    alignment: Alignment.center,
    decoration: BoxDecoration(
      color: Colors.white,
      border: Border(
        bottom: BorderSide(width: 0.5, color: Colors.black12),
      ),
    ),
    child: Text('火爆专区'),
  );

//火爆专区子项
  Widget _warpList() {
    if (hotGoodsList.length != 0) {
      List<Widget> listWidget = hotGoodsList.map((val) {
        return InkWell(
          onTap: () {
            print("点击了火爆专区");
            Application.router
                .navigateTo(context, '/detail?id=${val['goodsId']}');
          },
          child: Container(
            width: ScreenUtil().setWidth(372),
            color: Colors.white,
            padding: EdgeInsets.all(5.0),
            margin: EdgeInsets.only(bottom: 3.0),
            child: Column(
              children: <Widget>[
                Image.network(
                  val['image'],
                  width: ScreenUtil().setWidth(375),
                ),
                Text(
                  val['name'],
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      color: Colors.pink, fontSize: ScreenUtil().setSp(26)),
                ),
                Row(
                  children: <Widget>[
                    Text("￥${val['mallPrice']}"),
                    Text(
                      "￥ ${val['price']}",
                      style: TextStyle(
                          color: Colors.black26,
                          decoration: TextDecoration.lineThrough),
                    )
                  ],
                )
              ],
            ),
          ),
        );
      }).toList();

      return Wrap(
        spacing: 2,
        children: listWidget,
      );
    } else {
      return Text('');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          _hotTile,
          _warpList(),
        ],
      ),
    );
  }
}
