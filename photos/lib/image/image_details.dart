import 'package:flutter/material.dart';


class ImageDetails extends StatefulWidget{
  final String imageUrl;
  ImageDetails(this.imageUrl);

  @override
  State<ImageDetails> createState() => _ImageDetailsState(imageUrl);
}

class _ImageDetailsState extends State<ImageDetails> {

  final String imageUrl;
  _ImageDetailsState(this.imageUrl);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10),
      child: InteractiveViewer(
          panEnabled: true,
          scaleEnabled: true,
          minScale: 1.0,
          maxScale: 10,
          child: Image.network(imageUrl)
      ),
    );
  }
}
