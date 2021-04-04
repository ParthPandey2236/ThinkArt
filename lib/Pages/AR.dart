import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:photo_view/photo_view.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:model_viewer/model_viewer.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:web3dart/web3dart.dart';

import 'Profilepage.dart';

class Paintings {
  final String image;
  final String link;
  final String title;
  final int price;
  Paintings(this.image, this.link, this.title , this.price);
}

List<Paintings> paintings = <Paintings>[
  Paintings(
      'images/painting1.jpg',
      "https://storage.echoar.xyz/raspy-thunder-0385/bea43fa2-7409-4753-a419-9e4e88ec6ba2.glb",
      "Shanghai Kingdom",500),
  Paintings(
      'images/painting2.jpg',
      "https://storage.echoar.xyz/raspy-thunder-0385/09c4a5cf-97b9-47c6-ab7b-cca87706c18a.glb",
      "Forest",700),
  Paintings(
      'images/painting3.jpg',
      "https://storage.echoar.xyz/raspy-thunder-0385/9e08e45b-e73a-4a3b-94b0-c03abd7b0f06.glb",
      "Aliens Lazer",400),
  Paintings(
      'images/painting4.png',
      "https://storage.echoar.xyz/raspy-thunder-0385/76b8fb66-004d-4013-ae40-16c90594c2c0.glb",
      "Kung Fu panda",300),
  Paintings(
      'images/painting5.jpg',
      "https://storage.echoar.xyz/raspy-thunder-0385/85169cf1-cee8-446f-84b5-25f0c66c1c08.glb",
      "Deep Space",900),
  Paintings(
      'images/painting6.jpg',
      "https://storage.echoar.xyz/raspy-thunder-0385/ab12d3d5-2e06-4b7a-90a0-cca6a914f34f.glb",
      "Forest Gate",450),
  Paintings(
      'images/painting7.jpg',
      "https://storage.echoar.xyz/raspy-thunder-0385/afefbe77-8a60-4df9-9bba-9eca49a95aeb.glb",
      "Mountain to Hell",550),
  Paintings(
      'images/painting8.png',
      "https://storage.echoar.xyz/raspy-thunder-0385/972cede8-61df-42c7-9cc6-057be5704140.glb",
      "Key",700),
  Paintings(
      'images/painting9.jpg',
      "https://storage.echoar.xyz/raspy-thunder-0385/1089cc71-0b3b-482f-a75b-67ec92329be0.glb",
      "Stranded Alone",850),
  Paintings(
      'images/painting10.jpg',
      "https://storage.echoar.xyz/raspy-thunder-0385/f10ae0ff-f407-4ec0-9dc4-def2f1a998f0.glb",
      "Treehouse",750),
  Paintings(
      'images/painting11.jpg',
      "https://storage.echoar.xyz/raspy-thunder-0385/21efde51-e924-43bd-955b-eb925f23b913.glb",
      "Beach Party",650),
  Paintings(
      'images/painting12.jpg',
      "https://storage.echoar.xyz/raspy-thunder-0385/ec1a2078-d065-4d03-8c35-8d2e9ec22361.glb",
      "Saturn through Titan",750),
];

class ARModels extends StatefulWidget {
  @override
  _ARModelsState createState() => _ARModelsState();
}

class _ARModelsState extends State<ARModels> {

  int rp_amt;
  Razorpay _razorpay;

  @override
  void initState() {
    super.initState();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    httpClient = Client();
    ethClient = Web3Client("https://rpc-mumbai.matic.today", httpClient);
    getBalance(myAddress);
  }

  @override
  void dispose() {
    super.dispose();
    _razorpay.clear();
  }

  void openCheckout() async {
    var options = {
      'key': 'rzp_test_RyfDbq015IzSkf',
      'amount': rp_amt,
      'name': 'Think Art',
      'description': 'Payment',
      'prefill': {'contact': '', 'email': 'test@razorpay.com'},
      'external': {
        'wallets': ['paytm']
      }
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint(e);
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    Fluttertoast.showToast(
        msg: "SUCCESS: " + response.paymentId, timeInSecForIosWeb: 4);
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    Fluttertoast.showToast(
        msg: "ERROR: " + response.code.toString() + " - " + response.message,
        timeInSecForIosWeb: 4);
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    Fluttertoast.showToast(
        msg: "EXTERNAL_WALLET: " + response.walletName, timeInSecForIosWeb: 4);
  }

  Client httpClient;
  Web3Client ethClient;
  bool data = false;
  final myAddress = "0x20B85673252CAb8D906C11C69Ac85b6122794b8d";

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

  Future<String> SellCoin() async {
    var bigAmount = BigInt.from(myAmount);
    var response = await submit("withdrawBalance", [bigAmount]);
    print("Withdrawn");
    return response;
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 18.0),
                        child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              paintings[index].title,
                              style: TextStyle(fontSize: width * 0.05, fontWeight: FontWeight.w700),
                            )),
                      ),
                      Padding(
                        padding: EdgeInsets.only(right: 15.0),
                        child: Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              "TAZ " + paintings[index].price.toString(),
                              style: TextStyle(fontSize: width * 0.04 , color: Colors.redAccent , fontWeight: FontWeight.w500),
                            )),
                      ),
                    ],
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
                            Icon(FlutterIcons.cart_evi, color: Colors.redAccent),
                            Text(
                              "   Buy",
                              style: TextStyle(fontSize: width * 0.04 , color: Colors.redAccent),
                            ),
                          ],
                        ),
                        onPressed: () {
                          showModalBottomSheet(
                              isScrollControlled: true,
                              context: context,
                              builder: (context){
                                return StatefulBuilder(
                                    builder: (BuildContext context, StateSetter seState) {
                                      return Container(
                                        color: Color(0xFF737373),
                                        height: 150,
                                        child: Container(
                                          decoration: BoxDecoration(
                                              color: Theme.of(context).canvasColor,
                                              borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(15),
                                                  topRight: Radius.circular(15)
                                              )
                                          ),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              FlatButton(
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    CircleAvatar(
                                                        child: Center(child: Icon(FlutterIcons.rupee_sign_faw5s, color: Colors.white, size: 30)),
                                                      backgroundColor: Colors.redAccent,
                                                      radius: 30,
                                                    ),
                                                    SizedBox(height: 16),
                                                    Text('RazorPay'),
                                                  ],
                                                ),
                                                onPressed: () {
                                                  rp_amt = paintings[index].price*100;
                                                  openCheckout();
                                                },
                                              ),
                                              FlatButton(
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    CircleAvatar(
                                                      child: Center(child: Icon(FlutterIcons.chain_faw, color: Colors.white, size: 30)),
                                                      backgroundColor: Colors.redAccent,
                                                      radius: 30,
                                                    ),
                                                    SizedBox(height: 16),
                                                    Text('ThinkArt COIN'),
                                                  ],
                                                ),
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                  showModalBottomSheet(
                                                      isScrollControlled: true,
                                                      context: context,
                                                      builder: (context){
                                                        return StatefulBuilder(
                                                            builder: (BuildContext context, StateSetter seState) {
                                                              return Container(
                                                                color: Color(0xFF737373),
                                                                height: 150,
                                                                child: Container(
                                                                  decoration: BoxDecoration(
                                                                      color: Theme.of(context).canvasColor,
                                                                      borderRadius: BorderRadius.only(
                                                                          topLeft: Radius.circular(15),
                                                                          topRight: Radius.circular(15)
                                                                      )
                                                                  ),
                                                                  child: Column(
                                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                                    children: [
                                                                      Text(
                                                                          'Are you sure you want to pay using ThinkArt Coins?',
                                                                        style: TextStyle(
                                                                          fontWeight: FontWeight.bold
                                                                        ),
                                                                      ),
                                                                      SizedBox(height: 16),
                                                                      Row(
                                                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                                        crossAxisAlignment: CrossAxisAlignment.center,
                                                                        children: [
                                                                          FlatButton(
                                                                            child: Container(
                                                                              child: Center(
                                                                                child: Text(
                                                                                  'No',
                                                                                  style: TextStyle(
                                                                                    fontWeight: FontWeight.bold,
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                              height: 40,
                                                                              width: 80,
                                                                              decoration: BoxDecoration(
                                                                                borderRadius: BorderRadius.circular(15.0),
                                                                                color: Colors.redAccent,
                                                                              ),
                                                                            ),
                                                                            onPressed: () {
                                                                              Navigator.pop(context);
                                                                            },
                                                                          ),
                                                                          FlatButton(
                                                                            child: Container(
                                                                              child: Center(
                                                                                child: Text(
                                                                                    'Yes',
                                                                                  style: TextStyle(
                                                                                      fontWeight: FontWeight.bold
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                              height: 40,
                                                                              width: 80,
                                                                              decoration: BoxDecoration(
                                                                                borderRadius: BorderRadius.circular(15.0),
                                                                                color: Colors.redAccent,
                                                                              ),
                                                                            ),
                                                                            onPressed: () {
                                                                              //write code
                                                                              if(int.parse(coinsRemaining.toString())>=paintings[index].price) {
                                                                                setState(() {
                                                                                  myAmount =
                                                                                      paintings[index]
                                                                                          .price;
                                                                                  SellCoin();
                                                                                  Navigator.pop(context);
                                                                                  paintings.remove(paintings[index]);
                                                                                  Fluttertoast.showToast(
                                                                                      msg: "Order Placed - "+paintings[index].title,
                                                                                      toastLength: Toast.LENGTH_SHORT,
                                                                                      gravity: ToastGravity.BOTTOM,
                                                                                      timeInSecForIosWeb: 1,
                                                                                      backgroundColor: Colors.redAccent,
                                                                                      textColor: Colors.white,
                                                                                      fontSize: 16.0
                                                                                  );
                                                                                });
                                                                              }
                                                                              else
                                                                                {
                                                                                  Fluttertoast.showToast(
                                                                                      msg: "Insufficient Balance to buy the painting",
                                                                                      toastLength: Toast.LENGTH_SHORT,
                                                                                      gravity: ToastGravity.BOTTOM,
                                                                                      timeInSecForIosWeb: 1,
                                                                                      backgroundColor: Colors.redAccent,
                                                                                      textColor: Colors.white,
                                                                                      fontSize: 16.0
                                                                                  );
                                                                                }
                                                                            },
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              );
                                                            });
                                                      }
                                                  );
                                                },
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    });
                              }
                          );
                        },
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
