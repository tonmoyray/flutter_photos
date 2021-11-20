import 'package:flutter/material.dart';
import 'package:photos/model/image_data.dart';
import 'package:photos/network/api_client.dart';
import 'image_details.dart';


class ImageList extends StatefulWidget {
  ImageList();

  @override
  _SecondPageState createState() => _SecondPageState();
}

class _SecondPageState extends State<ImageList> {
  Map<int, ImageData> categoryList = {};
  List<ImageData> categories = [];
  final ScrollController _scrollController = ScrollController();
  int page = 0;
  bool loading = false;

  void _showImageDetails(BuildContext context, String imageUrl){
    showModalBottomSheet(
        context: context,
        isScrollControlled :true,
        builder: (_){return ImageDetails(imageUrl);}
        );
  }

  @override
  void initState() {
    super.initState();
    mockFetch();
    _scrollController.addListener(() {
      if(_scrollController.position.pixels >= _scrollController.position.maxScrollExtent && !loading){
        print("New Data Call");
        mockFetch();
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    mockFetch();
    _scrollController.dispose();
  }

  mockFetch() async  {
    setState(() {
      loading = true;
    });
    categories = await getPics(page,10) as List<ImageData>;
    print(categories);
    page ++;
    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Images"),
      ),
      body: LayoutBuilder (builder: (context, constraints) {
          if (categories.isNotEmpty) {
              final List<ImageData>? data = categories;
              print(data);
              return Stack(
                children: [
                   ListView.builder(
                    controller: _scrollController,
                      itemCount: data?.length,
                      itemBuilder: (context, index) {
                        return Container(
                            constraints: BoxConstraints.tightFor(width: 0.0, height: 200.0),
                            child: ListTile(
                              contentPadding: const EdgeInsets.fromLTRB(10, 5, 10, 0),
                              title: Image.network(
                                data![index].download_url,
                                fit: BoxFit.fitWidth,
                              ),
                              onTap: () {
                                _showImageDetails(context ,data[index].download_url);
                              },
                            )
                        );
                      }),
                  if(loading)...[Positioned(
                    left:0,
                    bottom:0,
                    child: Container(
                      width: constraints.maxWidth,
                      height : 80,
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    ),
                  ),]

                  ],
              );
            } else {
              return Container(child:
              Center(child:
              CircularProgressIndicator(),
              ));
            }
          }),

    );
  }
}
