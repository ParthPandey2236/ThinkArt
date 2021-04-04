import 'package:flutter/material.dart';
import 'package:fab_circular_menu/fab_circular_menu.dart';
import 'package:think_art/Pages/Profilepage.dart';
import 'package:think_art/Pages/auction.dart';
import 'AR.dart';
import 'order.dart';
import 'package:flutter_icons/flutter_icons.dart';

class CircularNavBar extends StatefulWidget {
  @override
  _CircularNavBarState createState() => _CircularNavBarState();
}

int index = 0;

class _CircularNavBarState extends State<CircularNavBar> {
  final GlobalKey<FabCircularMenuState> fabKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
          image: DecorationImage(
        image: AssetImage('images/background.jpg'),
        fit: BoxFit.cover,
      )),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: (index == 0)
            ? PaintingAuction()
            : (index == 1)
                ? ARModels()
                : (index == 2)
                    ? Order()
                    : (index == 3)
                        ? Profile()
                        : Container(
                            child: Center(
                              child: Text("Another page"),
                            ),
                          ),
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
                  FlutterIcons.blackboard_ent,
                  color: Colors.white,
                  size: MediaQuery.of(context).size.height * 0.03,
                ),
                onPressed: () {
                  setState(() {
                    index = 0;
                  });
                  if (fabKey.currentState.isOpen) {
                    fabKey.currentState.close();
                  }
                }),
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
                    index = 1;
                  });
                  if (fabKey.currentState.isOpen) {
                    fabKey.currentState.close();
                  }
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
                    index = 2;
                  });
                  if (fabKey.currentState.isOpen) {
                    fabKey.currentState.close();
                  }
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
                  if (fabKey.currentState.isOpen) {
                    fabKey.currentState.close();
                  }
                }),
          ],
        ),
      ),
    );
  }
}
