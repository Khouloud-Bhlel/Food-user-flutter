import 'package:flutter/material.dart';

class HomeCategory extends StatefulWidget {
  final String imageUrl; // Remplacez image par imageUrl
  final String name;
  final Function tap;
  final bool isHome;

  const HomeCategory({
    Key? key,
    required this.imageUrl, // Remplacez image par imageUrl
    required this.name,
    required this.tap,
    required this.isHome,
  }) : super(key: key);

  @override
  _HomeCategoryState createState() => _HomeCategoryState();
}

class _HomeCategoryState extends State<HomeCategory> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (widget.isHome) {
          // Ajoutez ici la logique de navigation pour les catégories si nécessaire
          // Par exemple, vous pouvez utiliser Navigator.push pour naviguer vers une autre page
        } else {
          // Vous pouvez appeler la fonction de tap ici si nécessaire
          widget.tap();
        }
      },
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        elevation: 4.0,
        child: Padding(
          padding: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
          child: Row(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(left: 0.0, right: 10.0),
                child: Image.network(
                  widget.imageUrl, // Remplacez image par imageUrl
                  width: 30, // Ajustez la largeur selon vos besoins
                  height: 30, // Ajustez la hauteur selon vos besoins
                ),
              ),
              
              SizedBox(width: 5),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  SizedBox(height: 10.0),
                  Text(
                    "${widget.name}",
                    style: TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 17,
                    ),
                  ),
                  SizedBox(height: 5),
                ],
              ),
              SizedBox(width: 5),
            ],
          ),
        ),
      ),
    );
  }
}
