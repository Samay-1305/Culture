import 'package:culture/api_calls/post.dart';
import 'package:culture/constants/color_contants.dart';
import 'package:culture/objects/item.dart';
import 'package:culture/objects/user.dart';
import 'package:culture/widgets/price_preview_card.dart';
import 'package:flappy_search_bar/flappy_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class SearchPage extends StatefulWidget {
  final User user;
  SearchPage({this.user});

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  List<Item> items = [];

  Future<List<Item>> _getAllItems(String text) async {
    var result = await POST(authKey: widget.user.authKey).fetchShowcase(text);
    return result;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    POST(authKey: widget.user.authKey).fetchShowcase("").then((value) {
      if (mounted) {
        setState(() {
          items = value;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Hero(
      transitionOnUserGestures: true,
      tag: "search",
      child: Material(
        color: black,
        child: SafeArea(
          child: Container(
            color: black,
            child: Column(
              children: [
                Expanded(
                  child: SearchBar<Item>(
                    searchBarPadding: EdgeInsets.symmetric(horizontal: 10),
                    headerPadding: EdgeInsets.symmetric(horizontal: 10),
                    listPadding: EdgeInsets.symmetric(horizontal: 10),
                    onSearch: _getAllItems,
                    minimumChars: 0,
                    textStyle: TextStyle(
                      color: white,
                      fontWeight: FontWeight.bold
                    ),
                    icon: Icon(Icons.search, color: white),
                    loader: Center(child: SpinKitCubeGrid(color: white)),
                    cancellationWidget: Text("Cancel", style: TextStyle(color: white, fontWeight: FontWeight.bold)),
                    onItemFound: (item, index) {
                      return Padding(
                        padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                        child: PreviewCard(index: item.itemID, data: item, user: widget.user),
                      );
                    },
                    emptyWidget: Center(
                      child: ListView.builder(
                        itemCount: items.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: PreviewCard(index: items[index].itemID,
                                data: items[index],
                                user: widget.user),
                          );
                        }
                      ),
                    )
                  ),
                )
              ],
            )
          ),
        ),
      )
    );
  }
}
