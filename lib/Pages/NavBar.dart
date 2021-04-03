import 'package:flutter/material.dart';
import 'package:fab_circular_menu/fab_circular_menu.dart';
import 'AR.dart';

class CircularNavBar extends StatefulWidget {
  @override
  _CircularNavBarState createState() => _CircularNavBarState();
}

int index = 0;
final GlobalKey<FabCircularMenuState> fabKey = GlobalKey();

class _CircularNavBarState extends State<CircularNavBar> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: (index == 1)
          ? Container(
              child: Center(
                child: Text("Another page"),
              ),
            )
          : ARModels(),
      floatingActionButton: FabCircularMenu(
        animationCurve: Curves.easeInOutQuint,
        fabCloseColor: Colors.red[400],
        key: fabKey,
        fabColor: Colors.red[400],
        ringColor: Colors.transparent,
        //animationDuration: const Duration(microseconds: 400),
        alignment: Alignment.bottomRight,
        fabOpenIcon: Icon(
          Icons.menu,
          color: Colors.white,
        ),
        fabCloseIcon: Icon(
          Icons.close,
          color: Colors.white,
        ),
        children: [
          ElevatedButton(
              style: ElevatedButton.styleFrom(
                  primary: Colors.red[400],
                  padding: EdgeInsets.all(18),
                  shape: CircleBorder()),
              child: Icon(
                Icons.laptop,
                color: Colors.white,
                size: MediaQuery.of(context).size.height * 0.03,
              ),
              onPressed: () {
                setState(() {
                  index = 0;
                });
                fabKey.currentState.close();
              }),
          ElevatedButton(
              style: ElevatedButton.styleFrom(
                  primary: Colors.red[400],
                  padding: EdgeInsets.all(18),
                  shape: CircleBorder()),
              child: Icon(
                Icons.edit,
                color: Colors.white,
                size: MediaQuery.of(context).size.height * 0.03,
              ),
              onPressed: () {
                setState(() {
                  index = 1;
                });
                fabKey.currentState.close();
              }),
          ElevatedButton(
              style: ElevatedButton.styleFrom(
                  primary: Colors.red[400],
                  padding: EdgeInsets.all(18),
                  shape: CircleBorder()),
              child: Icon(
                Icons.photo,
                color: Colors.white,
                size: MediaQuery.of(context).size.height * 0.03,
              ),
              onPressed: () {
                setState(() {
                  index = 2;
                });
                fabKey.currentState.close();
              }),
          ElevatedButton(
              style: ElevatedButton.styleFrom(
                  primary: Colors.red[400],
                  padding: EdgeInsets.all(18),
                  shape: CircleBorder()),
              child: Icon(
                Icons.person,
                color: Colors.white,
                size: MediaQuery.of(context).size.height * 0.03,
              ),
              onPressed: () {
                setState(() {
                  index = 3;
                });
                fabKey.currentState.close();
              }),
        ],
      ),
    );
  }
}

class BottomNavBar extends StatefulWidget {
  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  @override
  Widget build(BuildContext context) {
    return null;
  }
}
