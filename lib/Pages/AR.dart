import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:model_viewer/model_viewer.dart';

class Paintings {
  final String image;
  final String link;
  final String title;

  Paintings(this.image, this.link, this.title);
}

List<Paintings> paintings = <Paintings>[
  Paintings(
      'images/painting1.jpg',
      "https://storage.echoar.xyz/raspy-thunder-0385/bea43fa2-7409-4753-a419-9e4e88ec6ba2.glb",
      "Shanghai Kingdom"),
  Paintings(
      'images/painting2.jpg',
      "https://storage.echoar.xyz/raspy-thunder-0385/09c4a5cf-97b9-47c6-ab7b-cca87706c18a.glb",
      "Forest"),
  Paintings(
      'images/painting3.jpg',
      "https://storage.echoar.xyz/raspy-thunder-0385/9e08e45b-e73a-4a3b-94b0-c03abd7b0f06.glb",
      "Aliens Lazer"),
  Paintings(
      'images/painting4.png',
      "https://storage.echoar.xyz/raspy-thunder-0385/76b8fb66-004d-4013-ae40-16c90594c2c0.glb",
      "Kung Fu panda"),
  Paintings(
      'images/painting5.jpg',
      "https://storage.echoar.xyz/raspy-thunder-0385/85169cf1-cee8-446f-84b5-25f0c66c1c08.glb",
      "Deep Space"),
  Paintings(
      'images/painting6.jpg',
      "https://storage.echoar.xyz/raspy-thunder-0385/ab12d3d5-2e06-4b7a-90a0-cca6a914f34f.glb",
      "Forest Gate"),
  Paintings(
      'images/painting7.jpg',
      "https://storage.echoar.xyz/raspy-thunder-0385/afefbe77-8a60-4df9-9bba-9eca49a95aeb.glb",
      "Mountain to Hell"),
  Paintings(
      'images/painting8.png',
      "https://storage.echoar.xyz/raspy-thunder-0385/972cede8-61df-42c7-9cc6-057be5704140.glb",
      "Key"),
  Paintings(
      'images/painting9.jpg',
      "https://storage.echoar.xyz/raspy-thunder-0385/1089cc71-0b3b-482f-a75b-67ec92329be0.glb",
      "Stranded Alone"),
  Paintings(
      'images/painting10.jpg',
      "https://storage.echoar.xyz/raspy-thunder-0385/f10ae0ff-f407-4ec0-9dc4-def2f1a998f0.glb",
      "Treehouse"),
  Paintings(
      'images/painting11.jpg',
      "https://storage.echoar.xyz/raspy-thunder-0385/21efde51-e924-43bd-955b-eb925f23b913.glb",
      "Beach Party"),
  Paintings(
      'images/painting12.jpg',
      "https://storage.echoar.xyz/raspy-thunder-0385/ec1a2078-d065-4d03-8c35-8d2e9ec22361.glb",
      "Saturn through Titan"),
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
                        (paintings[index].title == 'Saturn through Titan' ||
                                paintings[index].title == 'Beach Party')
                            ? Align(
                                alignment: Alignment.topLeft,
                                child: Padding(
                                  padding: const EdgeInsets.all(15.0),
                                  child: Text(
                                    "F",
                                    style: TextStyle(
                                        fontSize: width * 0.07,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                  ),
                                ),
                              )
                            : Container(),
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
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ModelView(
                                        link: paintings[index].link,
                                        title: paintings[index].title,
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
