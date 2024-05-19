import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:resterant_app/screens/join.dart';
import 'package:resterant_app/screens/main_screen.dart';


class Walkthrough extends StatefulWidget {
  @override
  _WalkthroughState createState() => _WalkthroughState();
}

class _WalkthroughState extends State<Walkthrough> {

List pageInfos = [
  {
    "title": "Fresh Food",
    "body": "Enjoy the freshest ingredients sourced directly from local farms and markets. "
        "Our commitment to quality ensures that every dish is bursting with flavor and nutrition. "
        "Indulge in a variety of seasonal fruits, crisp vegetables, succulent meats, and savory seafood.",
    "img": "assets/on1.png",
  },
  {
    "title": "Fast Delivery",
    "body": "Get your food delivered to your doorstep in record time! Our efficient delivery "
        "system ensures that your meals arrive piping hot and ready to devour. "
        "No more waiting around - satisfaction is just a few clicks away.",
    "img": "assets/on2.png",
  },
  {
    "title": "Easy Payment",
    "body": "Say goodbye to complicated payment processes. With our easy payment options, "
        "you can complete your transaction hassle-free. Whether you prefer cash, card, or digital payments, "
        "we've got you covered. Ordering food has never been this convenient!",
    "img": "assets/on3.png",
  },
];

  @override
  Widget build(BuildContext context) {
    List<PageViewModel> pages = [
      for(int i = 0; i<pageInfos.length; i++)
        _buildPageModel(pageInfos[i])
    ];

    return WillPopScope(
      onWillPop: ()=>Future.value(false),
      child: Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        body: Padding(
          padding: EdgeInsets.all(10.0),
          child: IntroductionScreen(
            pages: pages,
            onDone: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (BuildContext context){
                    return JoinApp();
                  },
                ),
              );
            },
            onSkip: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (BuildContext context){
                    return JoinApp();
                  },
                ),
              );
            },
            showSkipButton: true,
            skip: Text("Skip"),
            next: Text(
              "Next",
              style: TextStyle(
                fontWeight: FontWeight.w800,
                //color: Theme.of(context).primaryColor,
                 color: Colors.yellow,
              ),
            ),
            done: Text(
              "Done",
              style: TextStyle(
                fontWeight: FontWeight.w800,
                //color: Theme.of(context).primaryColor,
                 color: Colors.yellow,
              ),
            ),
          ),
        ),
      ),
    );
  }

  _buildPageModel(Map item){
    return PageViewModel(
      title: item['title'],
      body: item['body'],
      image: Image.asset(
        item['img'],
        height: 185.0,
      ),
      decoration: PageDecoration(
        titleTextStyle: TextStyle(
          fontSize: 28.0,
          fontWeight: FontWeight.w600,
          //color: Theme.of(context).primaryColor,
           color: Colors.yellow,
        ),
        bodyTextStyle: TextStyle(fontSize: 15.0),
//        dotsDecorator: DotsDecorator(
//          activeColor: Theme.of(context).accentColor,
//          activeSize: Size.fromRadius(8),
//        ),
        pageColor: Theme.of(context).primaryColor,
      ),
    );
  }
}