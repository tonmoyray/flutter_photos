import 'package:flutter/material.dart';
import 'package:share/share.dart';


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
      child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            InteractiveViewer(
                panEnabled: true,
                scaleEnabled: true,
                minScale: 1.0,
                maxScale: 10,
                child: Image.network(imageUrl)
            ),
            ElevatedButton(
              child: Text('Share'),
              onPressed: () => Share.share("Sharing image link: "+imageUrl),
            )
          ])
    );
  }
}
