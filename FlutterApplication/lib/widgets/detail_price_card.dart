import 'package:flutter/material.dart';
import 'package:culture/constants/color_contants.dart';

class DetailPriceCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: (MediaQuery.of(context).size.width/2) - 48,
            child: Column(
              children: [
                Row(
                  children: [
                    Text(
                        'Open',
                        style: TextStyle(color: grey, fontWeight: FontWeight.bold)
                    ),
                    Spacer(),
                    Text(
                      '\$28.56',
                      style: TextStyle(color: white, fontWeight: FontWeight.bold),
                    )
                  ],
                ),
                Row(
                  children: [
                    Text(
                        'High',
                        style: TextStyle(color: grey, fontWeight: FontWeight.bold)
                    ),
                    Spacer(),
                    Text(
                      '\$28.78',
                      style: TextStyle(color: white, fontWeight: FontWeight.bold),
                    )
                  ],
                ),
                Row(
                  children: [
                    Text(
                        'Volume',
                        style: TextStyle(color: grey, fontWeight: FontWeight.bold)
                    ),
                    Spacer(),
                    Text(
                      '25 M',
                      style: TextStyle(color: white, fontWeight: FontWeight.bold),
                    )
                  ],
                )
              ],
            ),
          ),
          Container(
            width: (MediaQuery.of(context).size.width/2) - 48,
            child: Column(
              children: [
                Row(
                  children: [
                    Text(
                        'Close',
                        style: TextStyle(color: grey, fontWeight: FontWeight.bold)
                    ),
                    Spacer(),
                    Text(
                      '\$28.69',
                      style: TextStyle(color: white, fontWeight: FontWeight.bold),
                    )
                  ],
                ),
                Row(
                  children: [
                    Text(
                        'Low',
                        style: TextStyle(color: grey, fontWeight: FontWeight.bold)
                    ),
                    Spacer(),
                    Text(
                      '\$28.42',
                      style: TextStyle(color: white, fontWeight: FontWeight.bold),
                    )
                  ],
                ),
                Row(
                  children: [
                    Text(
                        '% Change',
                        style: TextStyle(color: grey, fontWeight: FontWeight.bold)
                    ),
                    Spacer(),
                    Text(
                      '+2.56 %',
                      style: TextStyle(color: green, fontWeight: FontWeight.bold),
                    )
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
