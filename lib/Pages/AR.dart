import 'package:flutter/material.dart';

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
            return Column(
              children: [
                Expanded(
                    child: Container(
                  decoration: BoxDecoration(
                      image: DecorationImage(
                    image: AssetImage(paintings[index].image),
                    fit: BoxFit.cover,
                  )),
                  child: TextButton(
                    onPressed: () {},
                    child: Container(),
                  ),
                )),
                Text(
                  paintings[index].title + '\n',
                  style: TextStyle(fontSize: width * 0.055),
                )
              ],
            );
          },
        ),
      ),
    );
  }
}
