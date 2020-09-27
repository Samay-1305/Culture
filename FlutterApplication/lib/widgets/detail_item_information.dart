import 'package:flutter/material.dart';
import 'package:culture/constants/color_contants.dart';

class DetailItemInformation extends StatelessWidget {
  final itemValue;
  final shareValue;
  final totalShares;
  final availableShares;
  final netChange;
  final totalReturn;
  final shareCount;
  DetailItemInformation({this.shareCount, this.itemValue, this.shareValue, this.totalShares, this.availableShares, this.netChange, this.totalReturn});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: (MediaQuery.of(context).size.width/2) - 32,
            child: Column(
              children: [
                Row(
                  children: [
                    Text(
                        'Item Valuation',
                        style: TextStyle(color: grey)
                    ),
                    Spacer(),
                    Text(
                      '\$' + itemValue.toString(),
                      style: TextStyle(color: white),
                    )
                  ],
                ),
                Row(
                  children: [
                    Text(
                        'Share Price',
                        style: TextStyle(color: grey)
                    ),
                    Spacer(),
                    Text(
                      '\$' + shareValue.toString(),
                      style: TextStyle(color: white),
                    )
                  ],
                ),
                Row(
                  children: [
                    Text(
                        '% Change',
                        style: TextStyle(color: grey)
                    ),
                    Spacer(),
                    Text(
                        (double.parse(netChange) - 100)
                            .toStringAsFixed(2) + ' \%',
                        style: TextStyle(color: double.parse(shareCount) > 0 ? double.parse(netChange) - 100 >= 0 ? green : red : white,
                            fontWeight: FontWeight.bold)
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            width: (MediaQuery.of(context).size.width/2) - 32,
            child: Column(
              children: [
                Row(
                  children: [
                    Text(
                        'Available Shares',
                        style: TextStyle(color: grey)
                    ),
                    Spacer(),
                    Text(
                      availableShares.toString(),
                      style: TextStyle(color: green),
                    )
                  ],
                ),
                Row(
                  children: [
                    Text(
                        'Volume',
                        style: TextStyle(color: grey)
                    ),
                    Spacer(),
                    Text(
                      totalShares.toString(),
                      style: TextStyle(color: white),
                    )
                  ],
                ),
                Row(
                  children: [
                    Text(
                        'Total Return',
                        style: TextStyle(color: grey)
                    ),
                    Spacer(),
                    Text(
                      totalReturn.toStringAsFixed(2),
                        style: TextStyle(color: totalReturn > 0 ? double.parse(netChange) - 100 >= 0 ? green : red : white,
                            fontWeight: FontWeight.bold)
                    ),
                  ],
                ),

              ],
            ),
          ),
        ],
      ),
    );
  }
}
