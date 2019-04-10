import 'package:flutter/material.dart';
import 'package:fluro/fluro.dart';
import '../pages/details_page.dart';

var detailsHandler = Handler(
      handlerFunc: (BuildContext context,Map<String,dynamic> prarms){
        String goodsId = prarms['id'].first;
        print("goods Id is $goodsId");
        return DetailsPage(goodsId);
      }
);