import 'package:flutter/material.dart';
import '../model/details.dart';
import '../service/service_method.dart';
import 'dart:convert';

class DetailsInfoProvide with ChangeNotifier {
  DetailsModel goodsInfo;

  bool isLeft = true;
  bool isRight = false;

  getDetailsInfo(String id) async {
    var formData = {'goodId': id};

    await request('getGoodDetailById', formData: formData).then((val) {
      var data = json.decode(val.toString());
      print(data);

      goodsInfo = DetailsModel.fromJson(data);
      notifyListeners();
    });
    
  }

  changeLeftAndRight(String changeState){
    if(changeState == 'left'){
        isLeft = true;
        isRight = false;
    }else{
      isLeft = false;
      isRight = true;
    }

    notifyListeners();
  }
}
