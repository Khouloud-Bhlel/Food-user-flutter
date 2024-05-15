import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:resterant_app/screens/cart.dart';
import 'package:resterant_app/screens/discount.dart';
import 'package:resterant_app/screens/home.dart';
import 'package:resterant_app/screens/myorder.dart';
import 'package:resterant_app/screens/settings.dart';
import 'package:resterant_app/screens/search.dart';
import 'package:resterant_app/util/const.dart';
import 'package:resterant_app/widgets/badge.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late PageController _pageController; // Marking _pageController as late
  int _page = 0;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => Future.value(false),
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          centerTitle: true,
          title: Text(
            Constants.appName,
          ),
          elevation: 0.0,
          actions: <Widget>[
           IconButton(
  icon: Icon(
    Icons.shopping_bag, // Icône représentant les commandes
    size: 22.0,
  ),
  onPressed: () {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) {
          return OrderPage();
        },
      ),
    );
  },
  tooltip: "My orders",
),

          ],
        ),
        body: PageView(
          physics: NeverScrollableScrollPhysics(),
          controller: _pageController,
          onPageChanged: onPageChanged,
          children: <Widget>[
            Home(),
            DiscountPage(),        
            SearchScreen(),
            CartScreen(),
            Settings(),
          ],
        ),
        bottomNavigationBar: BottomAppBar(
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              SizedBox(width: 7),
              IconButton(
                icon: Icon(
                  Icons.home,
                  size: 24.0,
                ),
                color: _page == 0
                    ? Colors.yellow // If pressed, icon turns yellow
                    : Theme.of(context).brightness == Brightness.dark
                        ? Colors.white // If dark mode, icon is white
                        : Colors.black, // Otherwise, icon is black
                onPressed: () => _pageController.jumpToPage(0),
              ),
              IconButton(
  icon: Icon(
    Icons.local_offer,
    size: 24.0,
  ),
  color: _page == 1
      ? Colors.yellow
      : Theme.of(context).brightness == Brightness.dark
          ? Colors.white
          : Colors.black,
  onPressed: () => _pageController.jumpToPage(1),
),
              IconButton(
                icon: Icon(
                  Icons.search,
                  size: 24.0,
                ),
                color: _page == 2
                    ? Colors.yellow
                    : Theme.of(context).brightness == Brightness.dark
                        ? Colors.white
                        : Colors.black,
                onPressed: () => _pageController.jumpToPage(2),
              ),
              IconButton(
                icon: IconBadge(
                  icon: Icons.shopping_cart,
                  size: 24.0,
                ),
                color: _page == 3
                    ? Colors.yellow
                    : Theme.of(context).brightness == Brightness.dark
                        ? Colors.white
                        : Colors.black,
                onPressed: () => _pageController.jumpToPage(3),
              ),
              IconButton(
                icon: Icon(
                  Icons.settings,
                  size: 24.0,
                ),
                color: _page == 4
                    ? Colors.yellow
                    : Theme.of(context).brightness == Brightness.dark
                        ? Colors.white
                        : Colors.black,
                onPressed: () => _pageController.jumpToPage(4),
              ),
              SizedBox(width: 7),
            ],
          ),
          color: Theme.of(context).primaryColor,
          shape: CircularNotchedRectangle(),
        ),
        floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: FloatingActionButton(
          elevation: 4.0,
          child: Icon(
            Icons.search,
          ),
          onPressed: () => _pageController.jumpToPage(2),
        ),
      ),
    );
  }

  void navigationTapped(int page) {
    _pageController.jumpToPage(page);
  }

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }

  void onPageChanged(int page) {
    setState(() {
      this._page = page;
    });
  }
}
