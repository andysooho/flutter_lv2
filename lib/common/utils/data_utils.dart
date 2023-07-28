import 'package:flutter_lv2/common/const/data.dart';

class DataUtils{
  static String pathToUrl(String value) => 'http://$ip$value';

  static List<String> listPathsToUrls(List<String> paths){
    return paths.map((e) => pathToUrl(e)).toList();
  }
}