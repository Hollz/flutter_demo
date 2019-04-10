import 'package:flutter/material.dart';
import '../provide/details_info.dart';
import 'package:provide/provide.dart';
import './details_page/details_top_area.dart';
import './details_page/details_explain.dart';

class DetailsPage extends StatelessWidget {
  final String goodsId;

  DetailsPage(this.goodsId);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text("商品详细页"),
      ),
      body: FutureBuilder(
        future: _getGoodsInfo(context),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Container(
              child: Column(
                children: <Widget>[
                  DetailsTopArea(),
                  DetailsExplain(),
                ],
              ),
            );
          } else {
            return Text("加载中....");
          }
        },
      ),
    );
  }

  Future _getGoodsInfo(BuildContext context) async {
    await Provide.value<DetailsInfoProvide>(context).getDetailsInfo(goodsId);
    return '完成加载';
  }
}
