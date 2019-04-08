import 'package:flutter/material.dart';
import '../model/category.dart';

class ChildCategory with ChangeNotifier {

   List<BxMallSubDto> childCategoryList = [];

  void getChildCategory(List<BxMallSubDto> list){
      var all = BxMallSubDto();
      all.mallSubId = '00';
      all.mallCategoryId = "00";
      all.mallSubName = '全部';
      all.comments = 'null';
      childCategoryList = [all];
      childCategoryList.addAll(list);
      notifyListeners();
  }
}