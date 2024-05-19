import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:resterant_app/providers/app_providers.dart';
import 'package:resterant_app/screens/splash.dart';
import 'package:resterant_app/util/const.dart';
import 'package:resterant_app/screens/reservation.dart';
import 'package:resterant_app/screens/delevery.dart';

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.fromLTRB(10.0,0,10.0,0),

        child: ListView(
          children: <Widget>[
            ListTile(
              title: Text(
                "Dark Theme",
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                ),
              ),

              trailing: Switch(
                value: Provider.of<AppProvider>(context).theme == Constants.lightTheme
                    ? false
                    : true,
                onChanged: (v) async{
                  if (v) {
                    Provider.of<AppProvider>(context, listen: false)
                        .setTheme(Constants.darkTheme, "dark");
                  } else {
                    Provider.of<AppProvider>(context, listen: false)
                        .setTheme(Constants.lightTheme, "light");
                  }
                },
                activeTrackColor: Colors.yellow,
                activeColor: Theme.of(context).primaryColor,
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (BuildContext context) {
                      return ReservationPage();
                    },
                  ),
                );
              },
              child: Text('Make a Reservation'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (BuildContext context) {
                      return DeliveryPage();
                    },
                  ),
                );
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Call the Delivery Man'),
                  GestureDetector(
                    onTap: () {
                      // Navigate to the website here
                      // Example: launch('https://yourwebsite.com/delivery');
                    },
                    child: Icon(Icons.info_outline),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            Text(
              "Prohibited Brand: If you want to become a delivery person, you must go to the website:",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
