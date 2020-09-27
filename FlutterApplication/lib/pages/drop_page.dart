import 'dart:async';
import 'dart:convert';
import 'package:culture/api_calls/post.dart';
import 'package:culture/constants/color_contants.dart';
import 'package:culture/objects/item.dart';
import 'package:culture/objects/user.dart';
import 'package:culture/paint/stock_painter.dart';
import 'package:culture/widgets/detail_item_information.dart';
import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:slide_to_confirm/slide_to_confirm.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;

class DropPage extends StatefulWidget {
  final index;
  final User user;
  DropPage({this.index, this.user});

  @override
  _DropPageState createState() => _DropPageState();
}

class _DropPageState extends State<DropPage> {
  double _x = 0.0;
  bool _isPressed = false;
  List<Offset> points = [Offset(0,125), Offset(300, 125)];
  int initialNumber = 1;
  double toggle_buy_sell = 0.0;
  Timer _timer;
  Item item = Item(itemName: "", itemID: -100, itemValue: 0.0, availableShares: 0.0, totalShares: 0.0, shareValue: 0.0);
  bool buy = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _timer = Timer.periodic(Duration(seconds: 1), (t) async {
      await POST(authKey: widget.user.authKey).fetchChartData(widget.index).then((value) {
        if (mounted) {
          setState(() {
            points = value;
          });
        }
      });

      await POST(authKey: widget.user.authKey).fetchItemData(widget.index).then((value) {
        if (mounted) {
          setState(() {
            item = value;
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
    if (item.itemID == -100) {
      return Container(
        color: black,
        child: SpinKitCubeGrid(
          color: green,
        ),
      );
    }
    return Material(
      color: black,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  GestureDetector(
                    child: Icon(Icons.arrow_back, color: white),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        item.itemName,
                        style: TextStyle(color:white, fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  Spacer(),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        '\$' + item.shareValue.toStringAsPrecision(4),
                        style: TextStyle(color: double.parse(item.netChange) - 100 >= 0 ? green : red, fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 4.0),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('The Nike MAG is a limited edition shoe created by Nike Inc. It is a replica of a shoe featured in the motion '
                    'picture, Back to the Future Part II. '
                    'The Nike Mag was originally released for sale in 2011 and again in 2016.',
                  style: TextStyle(color: grey),
                ),
              ),
              SizedBox(height: 64),
              Row(
                children: [
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Shares Owned',
                        style: TextStyle(color: white, fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  Spacer(),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        item.shareCount,
                        style: TextStyle(color: white, fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: DetailItemInformation(
                  itemValue: item.itemValue,
                  shareValue: item.shareValue.toStringAsPrecision(4),
                  totalShares: item.totalShares,
                  availableShares: item.availableShares,
                  netChange: item.netChange,
                  totalReturn: (double.parse(item.shareCount) * (item.shareValue.toDouble() - double.parse(item.averageCost))),
                  shareCount: item.shareCount,
                ),
              ),
              Spacer(),
              Center(
                child: CustomPaint(
                  size: Size(300, 200),
                  painter: StockPainter(x: _x, isPressed: _isPressed, points: points, midlineColor: white,
                      graphColor: points[points.length - 1].dy < 125 ? green : red
                  ),
                ),
              ),
              Spacer(),
              Row(
                children: [
                  Theme(
                    data: Theme.of(context).copyWith(
                      accentColor: white,
                      textTheme: Theme.of(context).textTheme.copyWith(
                          headline5: Theme.of(context).textTheme.headline5.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: 32
                          ),
                          bodyText2: Theme.of(context).textTheme.headline5.copyWith(
                            color: grey
                          )
                      )
                    ),
                    child: NumberPicker.integer(
                      initialValue: initialNumber,
                      minValue: 1,
                      maxValue: (5 * 4500),
                      onChanged: (value) {
                        setState(() {
                          initialNumber = value;
                        });
                      },
                    ),
                  ),
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                        children: [
                          TextSpan(text: initialNumber.toString() + '\n',
                              style: TextStyle(fontWeight: FontWeight.bold, color: white, fontSize: 64)
                          ),
                          TextSpan(text: 'shares', style: TextStyle(color: grey))
                        ]
                    ),
                  ),
                  Spacer(),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        buy = !buy;
                        toggle_buy_sell = toggle_buy_sell == 0.0 ? 75.0 : 0.0;
                      });
                    },
                    child: Stack(
                      children: [
                        Container(
                          height: 75,
                          width: 150,
                          decoration: BoxDecoration(
                              color: white,
                              borderRadius: BorderRadius.all(Radius.circular(15.0))
                          ),
                        ),
                        AnimatedContainer(
                          transform: Matrix4.translationValues(toggle_buy_sell, 0.0, 0.0),
                          margin: EdgeInsets.fromLTRB(2.5, 2.5, 2.5, 2.5),
                          duration: Duration(milliseconds: 250),
                          height: 70,
                          width: 70,
                          decoration: BoxDecoration(
                              color: black,
                              borderRadius: BorderRadius.all(Radius.circular(15.0))
                          ),
                          child: Center(
                            child: Text(
                              toggle_buy_sell == 0.0 ? 'Buy' : 'Sell',
                              style: TextStyle(
                                  color: toggle_buy_sell == 0.0 ? green : red,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 32),
              ConfirmationSlider(
                text: "\$ " + (initialNumber * item.shareValue).toStringAsFixed(2),
                foregroundColor: grey,
                width: MediaQuery.of(context).size.width - 32,
                foregroundShape: BorderRadius.all(Radius.circular(10.0)),
                backgroundShape: BorderRadius.all(Radius.circular(10.0)),
                onConfirmation: () async {
                  var response;
                  if (buy) {
                    response = await http.post('http://52.206.9.79/api/new/transactions/buy/', body: {
                      'auth_key': widget.user.authKey,
                      'share_count': initialNumber.toString(),
                      'item_id': widget.index.toString()
                    });
                  } else {
                    response = await http.post('http://52.206.9.79/api/new/transactions/sell/', body: {
                      'auth_key': widget.user.authKey,
                      'share_count': initialNumber.toString(),
                      'item_id': widget.index.toString()
                    });
                  }

                  if (response.statusCode == 200) {
                    print(json.decode(response.body)['success']);
                  } else {
                    throw Exception('Failed to buy stock');
                  }
                }
              ),
            ],
          ),
        ),
      ),
    );
  }
}
