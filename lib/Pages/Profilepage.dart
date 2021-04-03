import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:think_art/authentication.dart';
import 'package:web3dart/web3dart.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

var coinsRemaining ;

class _ProfileState extends State<Profile> {

  Client httpClient;
  Web3Client ethClient;
  bool data = false;
  final myAddress = "0x20B85673252CAb8D906C11C69Ac85b6122794b8d";
  int myAmount = 0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    httpClient = Client();
    ethClient = Web3Client(
        "https://rpc-mumbai.matic.today",
        httpClient);
    getBalance(myAddress);
  }

  Future<DeployedContract> loadContract() async {
    String abi = await rootBundle.loadString("assets/abi.json");
    String contractAddress = "0xeA5F86c31dBCe98d10b62529d328b206190756C9";
    final contract = DeployedContract(ContractAbi.fromJson(abi, "TAZcoin"),
        EthereumAddress.fromHex(contractAddress));
    return contract;
  }

  Future<List<dynamic>> query(String functionName, List<dynamic> args) async {
    final contract = await loadContract();
    final ethFunction = contract.function(functionName);
    final result = await ethClient.call(
        contract: contract, function: ethFunction, params: args);
    return result;
  }

  Future<void> getBalance(String targetaddress) async {
    EthereumAddress address = EthereumAddress.fromHex(targetaddress);
    List<dynamic> result = await query("getBalance", []);
    coinsRemaining = result[0];
    setState(() {
      data=true;
    });
  }

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
                          fontWeight: FontWeight.w700))
                ])),
              )),
          Padding(
            padding: EdgeInsets.only(top: height * 0.35),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
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
                      onPressed: () {
                        setState(() {
                          getBalance(myAddress);
                        });
                      },
                      child: Container(
                          width: 100,
                          height: 50,
                          child: Center(child: Text("Refresh"))),
                    ),
                  ],
                ),
                SizedBox(height: width * 0.08),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      primary: Colors.red[400],
                      elevation: 8,
                      shadowColor: Colors.red[200],
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(15)))),
                  onPressed: () async {
                    final prefs = await SharedPreferences.getInstance();
                    await FirebaseAuth.instance.signOut();
                    prefs.setString('think_art_email', '');
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Authentication()));
                  },
                  child: Container(
                      width: 100,
                      height: 50,
                      child: Center(child: Text("Logout"))),
                ),
              ],
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
    paint.color = Colors.white.withOpacity(0.8);
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
