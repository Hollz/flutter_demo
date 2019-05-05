import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provide/provide.dart';
import '../model/cartInfo.dart';
import '../provide/cart.dart';
import './cart_page/cart_item.dart';
import './cart_page/cart_bottom.dart';

class CartPage extends StatefulWidget {
  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('购物车'),
      ),
      body: FutureBuilder(
        future: _getCartInfo(),
        builder: (context, snapshot) {
          List<CartInfoModel> cartList =
              Provide.value<CartProvide>(context).cartList;
          if (snapshot.hasData && cartList != null) {
            return Stack(
              children: <Widget>[
                ListView.builder(
                  itemCount: cartList.length,
                  itemBuilder: (context, index) {
                    return CartItem(cartList[index]);
                  },
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  child: CartBottom(),
                )
              ],
            );
          } else {
            return Text('正在加载');
          }
        },
      ),
    );
  }

  Future<String> _getCartInfo() async {
    await Provide.value<CartProvide>(context).getCartInfo();
    return 'end';
  }
}
