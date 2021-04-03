import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Order extends StatefulWidget {
  @override
  _OrderState createState() => _OrderState();
}

class _OrderState extends State<Order> {
  CollectionReference ref = FirebaseFirestore.instance.collection('TextToImage');

  @override
  Widget build(BuildContext context) {
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Center(
          child: Card(
            elevation: 10,
            color: Colors.white,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15)
            ),
            child: Container(
              height: h/2.8,
              width: w/1.1,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15.0),
                  image: DecorationImage(
                      image: NetworkImage('https://raw.githubusercontent.com/lucidrains/deep-daze/main/samples/Autumn_1875_Frederic_Edwin_Church.jpg'),
                      fit: BoxFit.fill
                  )
              ),
              child: Align(
                alignment: Alignment.bottomRight,
                child: FlatButton(
                  child: Container(
                    child: Center(
                        child: Text(
                          'Create',
                          style: TextStyle(
                              color: Colors.redAccent,
                              letterSpacing: 2,
                              fontSize: 20,
                              fontWeight: FontWeight.bold
                          ),
                        )
                    ),
                    height: 40,
                    width: 100,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15.0)
                    ),
                  ),
                  onPressed: () {
                    var text = '';
                    var image = '';
                    showModalBottomSheet(
                        isScrollControlled: true,
                        context: context,
                        builder: (context){
                          return StatefulBuilder(
                              builder: (BuildContext context, StateSetter seState) {
                                return Container(
                                  color: Color(0xFF737373),
                                  height: h*3/4,
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: Theme
                                            .of(context)
                                            .canvasColor,
                                        borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(15),
                                            topRight: Radius.circular(15)
                                        )
                                    ),
                                    child: Padding(
                                      padding: EdgeInsets.all(24.0),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Stack(
                                            children: [
                                              Center(
                                                child: Text(
                                                  'Painting',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                              Center(
                                                child: Container(
                                                  height: 200,
                                                  width: 200,
                                                  decoration: BoxDecoration(
                                                      image: DecorationImage(
                                                          image: NetworkImage(image),
                                                          fit: BoxFit.fill
                                                      )
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          TextField(
                                            decoration: InputDecoration(
                                                hintText: 'Enter the Text...'
                                            ),
                                            onChanged: (value) {
                                              setState(() {
                                                text = value;
                                              });
                                            },
                                          ),
                                          SizedBox(
                                            height: 16,
                                          ),
                                          FlatButton(
                                            child: Container(
                                              height: 30,
                                              width: 125,
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(15.0),
                                                color: Colors.redAccent,
                                              ),
                                              child: Center(
                                                child: Text(
                                                  'Generate Painting',
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight: FontWeight.bold
                                                  ),
                                                ),
                                              ),
                                            ),
                                            onPressed: () {
                                              ref.doc(text)
                                                  .get()
                                                  .then((DocumentSnapshot documentSnapshot) {
                                                if (documentSnapshot.exists) {
                                                  setState(() {
                                                    image = documentSnapshot['Image'];
                                                    print(image);
                                                  });
                                                } else {
                                                  ref.doc(text)
                                                      .set({
                                                    'Text': text,
                                                    'Image': ''
                                                  })
                                                      .then((value) => print('task Added'))
                                                      .catchError((error) => print('Failed to add'));
                                                  print('unsucsessful');
                                                }
                                              });
                                            },
                                          ),
                                          SizedBox(
                                            height: 48,
                                          ),
                                          Center(
                                            child: FlatButton(
                                              child: Container(
                                                height: 48,
                                                width: 200,
                                                decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius: BorderRadius.circular(15.0),
                                                    border: Border.all(
                                                        color: Colors.redAccent,
                                                        width: 2
                                                    )
                                                ),
                                                child: Center(
                                                  child: Text(
                                                    'Order Now!',
                                                    style: TextStyle(
                                                        color: Colors.redAccent,
                                                        fontWeight: FontWeight.bold,
                                                        fontSize: 24
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              onPressed: () {
                                                Navigator.pop(context);
                                                Fluttertoast.showToast(
                                                    msg: "Order Confirmed",
                                                    toastLength: Toast.LENGTH_SHORT,
                                                    gravity: ToastGravity.BOTTOM,
                                                    timeInSecForIosWeb: 10,
                                                    backgroundColor: Colors.black54,
                                                    textColor: Colors.white,
                                                    fontSize: 13.0);
                                              },
                                            ),
                                          ),
                                          SizedBox(
                                            height: 48,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              });
                        }
                    );
                  },
                ),
              ),
            ),
          ),
        ),
        Center(
          child: Card(
            elevation: 10,
            color: Colors.white,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15)
            ),
            child: Container(
              height: h/2.8,
              width: w/1.1,
              child: Align(
                alignment: Alignment.bottomRight,
                child: FlatButton(
                  child: Container(
                    child: Center(
                        child: Text(
                          'Upload',
                          style: TextStyle(
                              color: Colors.redAccent,
                              letterSpacing: 2,
                              fontSize: 20,
                              fontWeight: FontWeight.bold
                          ),
                        )
                    ),
                    height: 40,
                    width: 100,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15.0)
                    ),
                  ),
                  onPressed: () {
                    var text = '';
                    var image = '';
                    showModalBottomSheet(
                        isScrollControlled: true,
                        context: context,
                        builder: (context){
                          return StatefulBuilder(
                              builder: (BuildContext context, StateSetter seState) {
                                return Container(
                                  color: Color(0xFF737373),
                                  height: h*3/4,
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: Theme
                                            .of(context)
                                            .canvasColor,
                                        borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(15),
                                            topRight: Radius.circular(15)
                                        )
                                    ),
                                    child: Padding(
                                      padding: EdgeInsets.all(24.0),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Stack(
                                            children: [
                                              Center(
                                                child: Text(
                                                  'Painting',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                              Center(
                                                child: Container(
                                                  height: 200,
                                                  width: 200,
                                                  decoration: BoxDecoration(
                                                      image: DecorationImage(
                                                          image: NetworkImage(image),
                                                          fit: BoxFit.fill
                                                      )
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          TextField(
                                            decoration: InputDecoration(
                                                hintText: 'Enter the Text...'
                                            ),
                                            onChanged: (value) {
                                              setState(() {
                                                text = value;
                                              });
                                            },
                                          ),
                                          SizedBox(
                                            height: 16,
                                          ),
                                          FlatButton(
                                            child: Container(
                                              height: 30,
                                              width: 125,
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(15.0),
                                                color: Colors.redAccent,
                                              ),
                                              child: Center(
                                                child: Text(
                                                  'Generate Painting',
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight: FontWeight.bold
                                                  ),
                                                ),
                                              ),
                                            ),
                                            onPressed: () {
                                              ref.doc(text)
                                                  .get()
                                                  .then((DocumentSnapshot documentSnapshot) {
                                                if (documentSnapshot.exists) {
                                                  setState(() {
                                                    image = documentSnapshot['Image'];
                                                    print(image);
                                                  });
                                                } else {
                                                  ref.doc(text)
                                                      .set({
                                                    'Text': text,
                                                    'Image': ''
                                                  })
                                                      .then((value) => print('task Added'))
                                                      .catchError((error) => print('Failed to add'));
                                                  print('unsucsessful');
                                                }
                                              });
                                            },
                                          ),
                                          SizedBox(
                                            height: 48,
                                          ),
                                          Center(
                                            child: FlatButton(
                                              child: Container(
                                                height: 48,
                                                width: 200,
                                                decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius: BorderRadius.circular(15.0),
                                                    border: Border.all(
                                                        color: Colors.redAccent,
                                                        width: 2
                                                    )
                                                ),
                                                child: Center(
                                                  child: Text(
                                                    'Order Now!',
                                                    style: TextStyle(
                                                        color: Colors.redAccent,
                                                        fontWeight: FontWeight.bold,
                                                        fontSize: 24
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              onPressed: () {
                                                Navigator.pop(context);
                                                Fluttertoast.showToast(
                                                    msg: "Order Confirmed",
                                                    toastLength: Toast.LENGTH_SHORT,
                                                    gravity: ToastGravity.BOTTOM,
                                                    timeInSecForIosWeb: 10,
                                                    backgroundColor: Colors.black54,
                                                    textColor: Colors.white,
                                                    fontSize: 13.0);
                                              },
                                            ),
                                          ),
                                          SizedBox(
                                            height: 48,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              });
                        }
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
