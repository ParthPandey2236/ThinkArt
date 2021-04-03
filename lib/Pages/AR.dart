import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:flutter_icons/flutter_icons.dart';

class Paintings {
  final String image;
  final String link;
  final String title;
  Paintings(this.image, this.link, this.title);
}

List<Paintings> paintings = <Paintings>[
  Paintings('images/painting1.jpg', "Link", "Shanghai Kingdom"),
  Paintings('images/painting2.jpg', "Link", "Forest"),
  Paintings('images/painting3.jpg', "Link", "Aliens Lazer"),
  Paintings('images/painting4.png', "Link", "Kung Fu panda"),
  Paintings('images/painting5.jpg', "Link", "Deep Space"),
  Paintings('images/painting6.jpg', "Link", "Forest Gate"),
  Paintings('images/painting7.jpg', "Link", "Mountain to Hell"),
  Paintings('images/painting8.png', "Link", "Key"),
  Paintings('images/painting9.jpg', "Link", "Stranded Alone"),
  Paintings('images/painting10.jpg', "Link", "Treehouse"),
  Paintings('images/painting11.jpg', "Link", "Beach Party"),
  Paintings('images/painting12.jpg', "Link", "Saturn through Titan"),
];

class ARModels extends StatefulWidget {
  @override
  _ARModelsState createState() => _ARModelsState();
}

class _ARModelsState extends State<ARModels> {
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
          itemCount: paintings.length,
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
                          image: AssetImage(paintings[index].image),
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
                                            image: paintings[index].image,
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
                          paintings[index].title,
                          style: TextStyle(fontSize: width * 0.05),
                        )),
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
                      TextButton(
                        child: Row(
                          children: [
                            Icon(FlutterIcons.cart_evi),
                            Text(
                              "   Buy",
                              style: TextStyle(fontSize: width * 0.04),
                            ),
                          ],
                        ),
                        onPressed: () {},
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
                        onPressed: () {},
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
