import 'dart:async';
import 'package:culture/api_calls/authentication.dart';
import 'package:culture/api_calls/post.dart';
import 'package:culture/objects/item.dart';
import 'package:culture/objects/user.dart';
import 'package:culture/pages/login_page.dart';
import 'package:culture/pages/search_page.dart';
import 'package:culture/paint/stock_painter.dart';
import 'package:culture/widgets/detail_price_card.dart';
import 'package:culture/widgets/price_preview_card.dart';
import 'package:flutter/material.dart';
import 'constants/color_contants.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      color: black,
      title: 'Flutter Demo',
      home: LoginPage(),
      theme: ThemeData(fontFamily: 'gilroy'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final User user;
  MyHomePage({this.user});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String username = "";
  String password = "";
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  List<Color> colors = [white, green, white, white, white];
  double _x = 0.0;
  bool _isPressed = false;
  List<Offset> points = [Offset(0,125), Offset(300, 125)];
  List<Item> items = [];
  Timer _timer;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _timer = Timer.periodic(Duration(seconds: 1), (t) async {
      await POST(authKey: widget.user.authKey).fetchChartData(1).then((value) {
        if (mounted) {
          setState(() {
            points = value;
          });
        }
      });

      await POST(authKey: widget.user.authKey).fetchPurchased().then((value) {
        if (mounted) {
          setState(() {
            items = value;
          });
        }
      });
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _timer.cancel();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: black,
      body: SafeArea(
        child: Stack(
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 48),
                child: Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text('Total Balance', style: TextStyle(color: Color.fromRGBO(113, 113, 113, 1.00), fontSize: 16, fontWeight: FontWeight.bold)),
                          Icon(Icons.keyboard_arrow_down, color: Color.fromRGBO(113, 113, 113, 1.00)),
                          Spacer(),
                          Hero(
                            tag: "search",
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(context, MaterialPageRoute(builder: (context) => SearchPage(user: widget.user)));
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border.all(color: white, width: 3.0),
                                  borderRadius: BorderRadius.all(Radius.circular(10.0))
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Icon(
                                    Icons.search,
                                    color: white,
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                      SizedBox(height: 8.0),
                      RichText(
                        text: TextSpan(
                            children: [
                              TextSpan(
                                text: '\$ 2,445',
                                style: TextStyle(
                                  color: white,
                                  fontSize: 48,
                                  fontFamily: 'gilroy',
                                  fontWeight: FontWeight.bold
                                ),
                              ),
                              TextSpan(
                                text: '.21',
                                style: TextStyle(
                                  color: grey,
                                  fontSize: 48,
                                ),
                              ),
                            ]
                        ),
                      ),
                      SizedBox(height: 24.0),
                      Row(
                        children: [
                          Text(
                            '+ \$ 252.26',
                            style: TextStyle(
                                color: grey,
                                fontSize: 18,
                                fontFamily: 'gilroy',
                                fontWeight: FontWeight.bold
                            ),
                          ),
                          SizedBox(width: 24.0),
                          Text(
                            '4.28%',
                            style: TextStyle(
                                color: green,
                                fontSize: 18,
                                fontFamily: 'gilroy',
                                fontWeight: FontWeight.bold
                            ),
                          ),
                          Icon(Icons.trending_up, color: green, size: 18),
                        ],
                      ),
                      SizedBox(height: 32),
                      DetailPriceCard(),
                      SizedBox(height: 32),
                      Center(
                        child: GestureDetector(
                          onHorizontalDragStart: (details) {
                            setState(() {
                              _isPressed = !_isPressed;
                              _x = details.localPosition.dx;
                            });
                          },
                          onHorizontalDragUpdate: (details) {
                            if (details.localPosition.dx > 0 && details.localPosition.dx < 300) {
                              setState(() {
                                _x = details.localPosition.dx;
                              });
                            }
                          },
                          onHorizontalDragEnd: (details) {
                            setState(() {
                              _isPressed = !_isPressed;
                            });
                          },
                          child: CustomPaint(
                            size: Size(300, 250),
                            painter: StockPainter(x: _x, isPressed: _isPressed, points: points, midlineColor: white,
                            graphColor: white),
                          ),
                        ),
                      ),
                      Container(
                        height: 48,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            GestureDetector(
                              child: Text('1D', style: TextStyle(color: colors[0], fontSize: 18, fontWeight: FontWeight.bold)),
                              onTap: () {
                                setState(() {
                                  colors = [green, white, white, white, white];
                                });
                              },
                            ),
                            GestureDetector(
                              child: Text('1M', style: TextStyle(color: colors[1], fontSize: 18, fontWeight: FontWeight.bold)),
                              onTap: () {
                                setState(() {
                                  colors = [white, green, white, white, white];
                                });
                              },
                            ),
                            GestureDetector(
                              child: Text('6M', style: TextStyle(color: colors[2], fontSize: 18, fontWeight: FontWeight.bold)),
                              onTap: () {
                                setState(() {
                                  colors = [white, white, green, white, white];
                                });
                              },
                            ),
                            GestureDetector(
                              child: Text('1Y', style: TextStyle(color: colors[3], fontSize: 18, fontWeight: FontWeight.bold)),
                              onTap: () {
                                setState(() {
                                  colors = [white, white, white, green, white];
                                });
                              },
                            ),
                            GestureDetector(
                              child: Text('5Y', style: TextStyle(color: colors[4], fontSize: 18, fontWeight: FontWeight.bold)),
                              onTap: () {
                                setState(() {
                                  colors = [white, white, white, white, green];
                                });
                              },
                            ),
                          ],
                        )
                      )
                    ],
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: DraggableScrollableSheet(
                initialChildSize: 0.21,
                minChildSize: 0.21,
                maxChildSize: 0.65,
                builder: (BuildContext context, scrollController) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 8.0, left: 2.0, right:2.0),
                    child: ListView.builder(
                        controller: scrollController,
                        itemCount: items.length,
                        itemBuilder: (context, index) => Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: PreviewCard(index: items[index].itemID, data: items[index], user: widget.user),
                        )
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}