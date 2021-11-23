import 'package:flutter/material.dart';
import 'package:photos/model/image_data.dart';
import 'package:photos/network/api_client.dart';
import 'image_details.dart';
import 'package:photos/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:connectivity/connectivity.dart';


class ImageList extends StatefulWidget {
  ImageList();

  @override
  _SecondPageState createState() => _SecondPageState();
}

class _SecondPageState extends State<ImageList> {
  Map<int, ImageData> categoryList = {};
  List<ImageData> categories = [];
  final ScrollController _scrollController = ScrollController();
  int page = 1;
  bool loading = false;
  final timeDifferenceToFetchNewData = 300000;

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
      if(!loading){
        if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent){
          page ++;
          print("New Data Call");
          mockFetch();
        } else if (_scrollController.position.pixels <= _scrollController.position.minScrollExtent) {
          page --;
          print("New Data Call");
          mockFetch();
        }

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
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var prefKey = Constants.apiResponseKey + page.toString();
    var timestampPrefkey = Constants.timestampKey + page.toString();
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile || connectivityResult == ConnectivityResult.wifi ) {
      // I am connected to a mobile network.
      if (prefs.getString(prefKey) != null){
        final int savedTimeStamp = prefs.getInt(timestampPrefkey)!;
        final int currentTimeStamp = DateTime.now().millisecondsSinceEpoch;
        final int timeDiff = currentTimeStamp - savedTimeStamp;
        if (timeDiff < timeDifferenceToFetchNewData){
          print("Not Fetching new Data, returning cached response");
          final String catString =  prefs.getString(prefKey)!;
          setState(() {
            categories = ImageData.decode(catString);
          });
        } else {
          print("Fetching new Data");
          setState(() {
            loading = true;
          });
          categories = await getPics(page,10) as List<ImageData>;
          print(categories);
          setState(() {
            loading = false;
          });
        }
      } else {
        setState(() {
          loading = true;
        });
        categories = await getPics(page,10) as List<ImageData>;
        print(categories);
        setState(() {
          loading = false;
        });
      }
    } else {
      if (prefs.getString(prefKey) != null){
        final String catString =  prefs.getString(prefKey)!;
        categories = ImageData.decode(catString);
      }
    }
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
