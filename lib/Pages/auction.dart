import 'dart:async';
import 'package:flutter/material.dart';
import 'package:model_viewer/model_viewer.dart';
import 'package:photo_view/photo_view.dart';
import 'package:flutter_icons/flutter_icons.dart';

class AuctionPaintings {
  final String image;
  final String link;
  final String title;
  double price;
  AuctionPaintings(this.image, this.link, this.title, this.price);
}

Timer _timer;
int seconds = 01;
int minutes = 01;
int hours = 24;
List<AuctionPaintings> auctionPaintings = <AuctionPaintings>[
  AuctionPaintings('images/painting1.jpg', "Link", "Shanghai Kingdom", 2.0),
  AuctionPaintings('images/painting2.jpg', "Link", "Forest", 3.0),
  AuctionPaintings('images/painting3.jpg', "Link", "Aliens Lazer", 3.0),
  AuctionPaintings('images/painting4.png', "Link", "Kung Fu panda", 1.0),
];

List<double> bids = [];

class PaintingAuction extends StatefulWidget {
  @override
  PaintingAuctionState createState() => PaintingAuctionState();
}

class PaintingAuctionState extends State<PaintingAuction> {
  @override
  void initState() {
    super.initState();
    for (int c = 0; c < auctionPaintings.length; c++) {
      bids.add(auctionPaintings[c].price);
    }
    startTimer();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Container(
        height: height,
        width: width,
        padding: EdgeInsets.only(left: 15, right: 15),
        child: GridView.builder(
          itemCount: auctionPaintings.length,
          primary: false,
          shrinkWrap: true,
          padding: EdgeInsets.all(0),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            mainAxisSpacing: 10,
            crossAxisSpacing: 8,
            crossAxisCount: 1,
          ),
          itemBuilder: (BuildContext context, int index) {
            return Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                      bottomLeft: Radius.circular(10),
                      bottomRight: Radius.circular(10))),
              child: Column(
                children: [
                  Expanded(
                      child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20)),
                        image: DecorationImage(
                          image: AssetImage(auctionPaintings[index].image),
                          fit: BoxFit.cover,
                        )),
                    child: Stack(
                      children: [
                        Align(
                          alignment: Alignment.topRight,
                          child: TextButton(
                            style: TextButton.styleFrom(
                                primary: Colors.black.withOpacity(0.5)),
                            child: Icon(
                              FlutterIcons.expand_arrows_alt_faw5s,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => PhotoShow(
                                            image:
                                                auctionPaintings[index].image,
                                          )));
                            },
                          ),
                        ),
                      ],
                    ),
                  )),
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 18.0),
                    child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          auctionPaintings[index].title + '\n',
                          style: TextStyle(fontSize: width * 0.05),
                        )),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 20.0, right: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Current bid: \n",
                          style: TextStyle(fontSize: width * 0.04),
                        ),
                        Text(
                            'TAZ ' +
                                auctionPaintings[index].price.toString() +
                                '\n',
                            style: TextStyle(fontSize: width * 0.04))
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 20.0, right: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Time Remaining: ",
                          style: TextStyle(fontSize: width * 0.04),
                        ),
                        Text(
                            hours.toString() +
                                'h ' +
                                minutes.toString() +
                                'm ' +
                                seconds.toString() +
                                's',
                            style: TextStyle(fontSize: width * 0.04))
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 18.0, right: 18, top: 8),
                    child: Divider(
                      thickness: 1.3,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Row(
                        children: [
                          TextButton(
                              onPressed: () {
                                setState(() {
                                  if (bids[index] >
                                      auctionPaintings[index].price) {
                                    bids[index] -= 1;
                                  }
                                });
                              },
                              child: Icon(
                                FlutterIcons.minus_ant,
                                color: Colors.blue,
                              )),
                          Text(
                            'TAZ ' + bids[index].toString(),
                            style: TextStyle(color: Colors.blue),
                          ),
                          TextButton(
                              onPressed: () {
                                setState(() {
                                  bids[index] += 1;
                                });
                              },
                              child: Icon(
                                FlutterIcons.plus_ant,
                                color: Colors.blue,
                              )),
                          TextButton(
                            child: Row(
                              children: [
                                Icon(FlutterIcons.cart_evi),
                                Text(
                                  "   Bid   ",
                                  style: TextStyle(fontSize: width * 0.04),
                                ),
                              ],
                            ),
                            onPressed: () {
                              setState(() {
                                auctionPaintings[index].price = bids[index];
                              });
                            },
                          ),
                        ],
                      ),
                      TextButton(
                        child: Row(
                          children: [
                            Icon(FlutterIcons.eye_ant),
                            Text(
                              "   AR",
                              style: TextStyle(fontSize: width * 0.04),
                            ),
                          ],
                        ),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ModelView(
                                        link: auctionPaintings[index].link,
                                        title: auctionPaintings[index].title,
                                      )));
                        },
                      )
                    ],
                  )
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  void startTimer() {
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneSec,
      (Timer timer) => setState(
        () {
          if (seconds < 0) {
            timer.cancel();
          } else {
            seconds = seconds - 1;
            if (seconds < 0) {
              minutes -= 1;
              seconds = 59;
              if (minutes < 0) {
                hours -= 1;
                minutes = 59;
              }
            }
          }
        },
      ),
    );
  }
}

class PhotoShow extends StatefulWidget {
  final String image;

  const PhotoShow({Key key, this.image}) : super(key: key);

  @override
  _PhotoShowState createState() => _PhotoShowState();
}

class _PhotoShowState extends State<PhotoShow> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: PhotoView(
          imageProvider: AssetImage(widget.image),
        ),
      ),
    );
  }
}

class ModelView extends StatefulWidget {
  final String link;
  final String title;

  const ModelView({Key key, this.link, this.title}) : super(key: key);

  @override
  _ModelViewState createState() => _ModelViewState();
}

class _ModelViewState extends State<ModelView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: ModelViewer(
        src: widget.link,
        alt: widget.title,
        ar: true,
        autoRotate: true,
        arScale: "fixed",
        cameraControls: true,
      ),
    );
  }
}
