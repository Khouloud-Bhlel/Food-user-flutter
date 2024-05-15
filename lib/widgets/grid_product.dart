import 'package:flutter/material.dart';
import 'package:resterant_app/screens/details.dart';
import 'package:resterant_app/util/const.dart';

class GridProduct extends StatelessWidget {
  final String name;
  final String imageUrl;
  final String desc;
  final String productId;
  final double price;
  final double reduction;

  // final DateTime startDate;
  // final DateTime endDate;

  const GridProduct({
    Key? key,
    required this.name,
    required this.imageUrl,
    required this.desc,
    required this.productId,
    required this.price,
     required this.reduction,

  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (BuildContext context) => ProductDetails(
              productId: productId,
            ),
          ),
        );
      },
      child: ListView(
        shrinkWrap: true,
        primary: false,
        children: <Widget>[
          Stack(
            children: <Widget>[
              Container(
                height: MediaQuery.of(context).size.height / 3.6,
                width: MediaQuery.of(context).size.width / 2.2,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Image.network(
                    imageUrl,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 2.0, top: 8.0),
            child: Text(
              name,
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.w900,
              ),
              maxLines: 2,
            ),
          ),
        ],
      ),
    );
  }
}
