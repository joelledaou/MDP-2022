import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  Material myItems(IconData icon, String heading, int color, String routeName) {
    return Material(
        color: Colors.white,
        elevation: 14.0,
        shadowColor: Color(0x802196F3),
        borderRadius: BorderRadius.circular(24.0),
        child: Center(
            child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(heading,
                                style: TextStyle(
                                    color: Color(color), fontSize: 20.0))),
                        Material(
                            color: Color(color),
                            borderRadius: BorderRadius.circular(15.0),
                            child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                // child: Icon(
                                //   icon,
                                //   color: Colors.white,
                                //   size: 30.0,
                                // )
                                child: IconButton(
                                  icon: Icon(icon),
                                  color: Colors.white,
                                  iconSize: 30.0,
                                  onPressed: () {
                                    Navigator.pushNamed(context, routeName);
                                  },
                                )))
                      ],
                    )
                  ],
                ))));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "INVERTRACKER",
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          centerTitle: true,
        ),
        body: StaggeredGridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 12.0,
          mainAxisSpacing: 12.0,
          children: <Widget>[
            Padding(padding: const EdgeInsets.only(top: 0.3)),
            myItems(Icons.account_box, "Profile", 0xffed622b, "/profile"),
            myItems(Icons.offline_bolt, "Consumption", 0xff26cb3c, "/charts"),
            myItems(Icons.notifications, "Notifications", 0xffff3266, "/test"),
            myItems(Icons.attach_money, "Savings", 0xff3399fe, "/savings"),
            myItems(Icons.settings, "Settings", 0xfff4c83f, "/settings"),
            myItems(Icons.message, "Contact", 0xff622F74, "/test")
            // myItems(Icons.favorite, "Followers", 0xffad61f1),
            // myItems(Icons.message, "Messages", 0xff7297ff),
          ],

          // staggeredTiles: [
          //   StaggeredTile.extent(2, 130.0),
          //   StaggeredTile.extent(1, 150.0),
          //   StaggeredTile.extent(1, 150.0),
          //   StaggeredTile.extent(1, 150.0),
          //   StaggeredTile.extent(1, 150.0),
          //   StaggeredTile.extent(2, 240.0),
          //   StaggeredTile.extent(2, 120.0),
          // ],

          staggeredTiles: [
            StaggeredTile.extent(2, 15.0),
            StaggeredTile.extent(2, 150.0),
            StaggeredTile.extent(1, 250.0),
            StaggeredTile.extent(1, 145.0),
            StaggeredTile.extent(1, 145.0),
            StaggeredTile.extent(1, 150.0),
            StaggeredTile.extent(1, 145.0),
            // StaggeredTile.extent(2, 240.0),
            // StaggeredTile.extent(2, 120.0),
          ],
        )

        /*
        body: StaggeredGrid.count(
          crossAxisCount: 4,
          mainAxisSpacing: 4,
          crossAxisSpacing: 4,
          children: const [
            StaggeredGridTile.count(
              crossAxisCellCount: 2,
              mainAxisCellCount: 2,
              child: myItems(Icons.graphic_eq, "Total Views", 0xffed622b),
            )
          ],
        )
        */

        );
  }
  
}
