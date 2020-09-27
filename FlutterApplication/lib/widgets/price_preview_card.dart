import 'package:culture/constants/color_contants.dart';
import 'package:culture/objects/item.dart';
import 'package:culture/objects/user.dart';
import 'package:culture/pages/drop_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class PreviewCard extends StatefulWidget {
  final index;
  final Item data;
  final User user;
  PreviewCard({this.index, this.data, this.user});

  @override
  _PreviewCardState createState() => _PreviewCardState();
}

class _PreviewCardState extends State<PreviewCard> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => DropPage(index: widget.index, user: widget.user)));
      },
      child: Container(
        height: 144,
        decoration: BoxDecoration(
            color: black,
            borderRadius: BorderRadius.all(Radius.circular(8.0)),
            border: Border.all(
              color: double.parse(widget.data.shareCount) > 0 ? double.parse(widget.data.netChange) - 100 >= 0 ? green : red : white,
              width: 3.0
            ),
            boxShadow: [
              BoxShadow(
                color: black.withOpacity(0.2),
                spreadRadius: 5,
                blurRadius: 5,
                offset: Offset(5, 5),
              )
            ]
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(widget.data.itemName, style: TextStyle(color: white, fontSize: 20, fontWeight: FontWeight.bold)),
              SizedBox(height: 4),
              Text(widget.data.description.toString(), style: TextStyle(color: grey, fontSize: 12, fontWeight: FontWeight.bold)),
              Spacer(),
              Row(
                children: [
                  Text("\$ " + widget.data.sharesWorth, style: TextStyle(color: white, fontWeight: FontWeight.bold)),
                  Spacer(),
                  if(double.parse(widget.data.shareCount) > 0)
                    Text(
                        (double.parse(widget.data.netChange) - 100)
                            .toStringAsFixed(2) + ' \%',
                        style: TextStyle(color: double.parse(widget.data
                            .shareCount) > 0 ? double.parse(widget.data
                            .netChange) - 100 >= 0 ? green : red : white,
                            fontWeight: FontWeight.bold)
                    ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
