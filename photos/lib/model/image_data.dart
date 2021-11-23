import 'dart:convert';

class ImageData {
  String id = "";
  String author = "";
  int width = 0;
  int height = 0;
  String url = "";
  String download_url = "";


  ImageData.fromJson(Map<String, dynamic> parsedJson) {
    id = parsedJson["id"];
    author = parsedJson["author"];
    width = parsedJson["width"];
    height = parsedJson["height"];
    url = parsedJson["url"];
    download_url = parsedJson["download_url"];
  }

  static Map<String, dynamic> toMap(ImageData cat) => {
    'id': cat.id,
    'author': cat.author,
    'width': cat.width,
    'height': cat.height,
    'url': cat.url,
    'download_url': cat.download_url,
  };

  static String encode(List<ImageData> images) => json.encode(
    images
        .map<Map<String, dynamic>>((image) => ImageData.toMap(image))
        .toList(),
  );

  static List<ImageData> decode(String images) =>
      (json.decode(images) as List<dynamic>)
          .map<ImageData>((item) => ImageData.fromJson(item))
          .toList();

  @override
  String toString() => 'Category { id: $id }';
}