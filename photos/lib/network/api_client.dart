import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart';
import 'package:photos/model/image_data.dart';

Future <List<ImageData>> getPics(int page, int limit) async {
  List<ImageData> categories = [];
  final String url = "https://picsum.photos/v2/list?page=$page&limit=$limit";
  print(url);
  var response = await get(Uri.parse(url));
  var decodedResponse = json.decode(response.body);

  for (var item in decodedResponse) {
      final cate = ImageData.fromJson(item);
        categories.add(cate);
  }
  return categories;
}