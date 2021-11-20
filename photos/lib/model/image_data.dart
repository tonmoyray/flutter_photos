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

  @override
  String toString() => 'Category { id: $id }';
}