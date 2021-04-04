import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:model_viewer/model_viewer.dart';
import 'package:photo_view/photo_view.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:web3dart/web3dart.dart';
import 'Profilepage.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AuctionPaintings {
  final String image;
  final String link;
  final String title;
  int price;
  AuctionPaintings(this.image, this.link, this.title, this.price);
}

Timer _timer;
int seconds = 01;
int minutes = 01;
int hours = 24;
List<AuctionPaintings> auctionPaintings = <AuctionPaintings>[
  AuctionPaintings('images/painting1.jpg', "https://storage.echoar.xyz/raspy-thunder-0385/bea43fa2-7409-4753-a419-9e4e88ec6ba2.glb", "Shanghai Kingdom", 2),
  AuctionPaintings('images/painting2.jpg', "https://storage.echoar.xyz/raspy-thunder-0385/09c4a5cf-97b9-47c6-ab7b-cca87706c18a.glb", "Forest", 3),
  AuctionPaintings('images/painting3.jpg', "https://storage.echoar.xyz/raspy-thunder-0385/9e08e45b-e73a-4a3b-94b0-c03abd7b0f06.glb", "Aliens Lazer", 3),
  AuctionPaintings('images/painting4.png', "https://storage.echoar.xyz/raspy-thunder-0385/76b8fb66-004d-4013-ae40-16c90594c2c0.glb", "Kung Fu panda", 1),
];

List<int> bids = [];

class PaintingAuction extends StatefulWidget {
  @override
  PaintingAuctionState createState() => PaintingAuctionState();
}

class PaintingAuctionState extends State<PaintingAuction> {

  Client httpClient;
  Web3Client ethClient;
  bool data = false;
  final myAddress = "0x20B85673252CAb8D906C11C69Ac85b6122794b8d";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    httpClient = Client();
    ethClient = Web3Client("https://rpc-mumbai.matic.today", httpClient);
    getBalance(myAddress);
    for (int c = 0; c < auctionPaintings.length; c++) {
      bids.add(auctionPaintings[c].price);
    }
    startTimer();
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
      data = true;
    });
  }

  Future<String> submit(String functionName, List<dynamic> args) async {
    EthPrivateKey credentials = EthPrivateKey.fromHex(
        "a9bf134facdd642a02e1f6e008cb21901e28952c0541df466e76cb8cda3ed296");
    DeployedContract contract = await loadContract();
    final ethFunction = contract.function(functionName);
    final result = await ethClient.sendTransaction(
        credentials,
        Transaction.callContract(
            contract: contract, function: ethFunction, parameters: args),
        fetchChainIdFromNetworkId: true);
    return result;
  }

  Future<String> sendCoin() async {
    var bigAmount = BigInt.from(myAmount);
    var response = await submit("depositBalance", [bigAmount]);
    print("Deposited");
    return response;
  }

  Future<String> withdrawCoin() async {
    var bigAmount = BigInt.from(myAmount);
    var response = await submit("withdrawBalance", [bigAmount]);
    print("Withdrawn");
    return response;
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
                                color: Colors.redAccent,
                              )),
                          Text(
                            'TAZ ' + bids[index].toString() +".0",
                            style: TextStyle(color: Colors.redAccent),
                          ),
                          TextButton(
                              onPressed: () {
                                setState(() {
                                  if(bids[index]<int.parse(coinsRemaining.toString()))
                                      bids[index] += 1;
                                  else
                                    Fluttertoast.showToast(
                                        msg: "Insufficient Balance to place a bid",
                                        toastLength: Toast.LENGTH_SHORT,
                                        gravity: ToastGravity.BOTTOM,
                                        timeInSecForIosWeb: 1,
                                        backgroundColor: Colors.redAccent,
                                        textColor: Colors.white,
                                        fontSize: 16.0
                                    );
                                });
                              },
                              child: Icon(
                                FlutterIcons.plus_ant,
                                color: Colors.redAccent,
                              )),
                          TextButton(
                            child: Row(
                              children: [
                                Icon(FlutterIcons.cart_evi , color: Colors.redAccent,),
                                Text(
                                  "   Bid   ",
                                  style: TextStyle(fontSize: width * 0.04 , color: Colors.redAccent),
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
                            Icon(FlutterIcons.eye_ant , color: Colors.redAccent,),
                            Text(
                              "   AR",
                              style: TextStyle(fontSize: width * 0.04 , color: Colors.redAccent),
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

