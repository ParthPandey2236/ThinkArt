import 'package:flutter/material.dart';
import 'package:think_art/authentication.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

int coinsRemaining = 2000;

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Container(
      width: width,
      height: height,
      child: Stack(
        children: [
          Padding(
            padding: EdgeInsets.only(left: width * 0.07, top: height * 0.19),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.orange,
                  radius: 40,
                  child: TextButton(
                    onPressed: () {
                      print("HELLO");
                    },
                    child: Container(),
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
                Text(
                  email,
                  style: TextStyle(fontSize: width * 0.05, color: Colors.white),
                )
              ],
            ),
          ),
          CustomPaint(
            size: Size(width, height),
            painter: CurvePainter(),
          ),
          Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.only(left: width * 0.07),
                child: RichText(
                    text: TextSpan(children: [
                  TextSpan(
                      text: "Coins Remaining\n\n",
                      style: TextStyle(
                          color: Colors.red[400],
                          fontSize: width * 0.07,
                          fontWeight: FontWeight.bold)),
                  TextSpan(
                      text: ' TAZ ' + coinsRemaining.toString(),
                      style: TextStyle(
                          color: Colors.red[400],
                          fontSize: width * 0.05,
                          fontWeight: FontWeight.w400))
                ])),
              )),
          Align(
            alignment: Alignment.center,
            child: Padding(
              padding: EdgeInsets.only(top: height * 0.25),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        primary: Colors.red[400],
                        elevation: 8,
                        shadowColor: Colors.red[200],
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(15)))),
                    onPressed: () {},
                    child: Container(
                        width: 100,
                        height: 50,
                        child: Center(child: Text("Deposit"))),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        primary: Colors.red[400],
                        elevation: 8,
                        shadowColor: Colors.red[200],
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(15)))),
                    onPressed: () {},
                    child: Container(
                        width: 100,
                        height: 50,
                        child: Center(child: Text("Refresh"))),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class CurvePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint();
    paint.color = Colors.white;
    paint.style = PaintingStyle.fill;

    var path = Path();

    path.moveTo(0, size.height * 0.3);
    path.lineTo(0, size.height);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, size.height * 0.45);
    // path.moveTo(0, size.height);
    // path.lineTo(size.width, size.height);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
