import 'package:dio/dio.dart';
import 'dart:async';
import 'dart:io';
import '../config/service_url.dart';

Future request(url,{formData}) async {
  //可选参数
  print("开始请求数据 .....");
  try {
    Response response;
    Dio dio = Dio();
    dio.options.contentType =
        ContentType.parse("application/x-www-form-urlencoded");

    if (formData == null) {
      response = await dio.post(servicePaht[url]);
    } else {
      response = await dio.post(servicePaht[url], data: formData);
    }
    if (response.statusCode == 200) {
      return response.data;
    } else {
      throw Exception('后端代码异常，请检查服务器...');
    }
  } catch (e) {
    return print(e);
  }
}

Future getHomeContent() async {
  print("开始请求数据...........");
  try {
    Response response;
    Dio dio = Dio();
    // dio.interceptors.add(LogInterceptor(requestBody: false));
    dio.options.contentType =
        ContentType.parse("application/x-www-form-urlencoded");
    var formData = {'lon': '115.02932', 'lat': '35.76189'};
    response = await dio.post(servicePaht['homePageContext'], data: formData);
    if (response.statusCode == 200) {
      return response.data;
    } else {
      throw Exception('后端代码异常，请检查服务器.....');
    }
  } catch (e) {
    return print(e);
  }
}

Future getHomeBelowConten() async {
  print("开始请求数据...........");
  try {
    Response response;
    Dio dio = Dio();
    // dio.interceptors.add(LogInterceptor(requestBody: false));
    dio.options.contentType =
        ContentType.parse("application/x-www-form-urlencoded");
    // var formData = {'lon': '115.02932', 'lat': '35.76189'};
    var formData = {'page': '1'};
    response =
        await dio.post(servicePaht['homePageBelowConten'], data: formData);
    if (response.statusCode == 200) {
      return response.data;
    } else {
      throw Exception('后端代码异常，请检查服务器.....');
    }
  } catch (e) {
    return print(e);
  }
}
