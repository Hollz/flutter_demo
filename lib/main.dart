import 'package:flutter/material.dart';
import './pages/index_page.dart';
import 'package:provide/provide.dart';
import './provide/counter.dart';
import './provide/child_category.dart';
import './provide/category_goods_list.dart';
import 'package:fluro/fluro.dart';
import './routers/application.dart';
import './routers/routes.dart';
import './provide/details_info.dart';
import './provide/cart.dart';

void main() {

  final router = Router();
  Application.router = router;
  Routes.configureRoutes(router);

  var counter = Counter();
  var providers = Providers();
  var childCategory = ChildCategory();
  var categoryGoodsList = CategoryGoodsListProvide();
  var detailsInfo = DetailsInfoProvide();
  var cart = CartProvide();

  providers
    ..provide(Provider<Counter>.value(counter))
    ..provide(Provider<ChildCategory>.value(childCategory))
    ..provide(Provider<CategoryGoodsListProvide>.value(categoryGoodsList))
    ..provide(Provider<DetailsInfoProvide>.value(detailsInfo))
    ..provide(Provider<CartProvide>.value(cart));
    
  runApp(ProviderNode(
    child: MyApp(),
    providers: providers,
  ));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: MaterialApp(
        title: '百姓生活+',
        onGenerateRoute: Application.router.generator,
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: Colors.pink,
        ),
        home: IndexPage(),
      ),
    );
  }
}
