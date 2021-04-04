import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_credit_card/credit_card_form.dart';
import 'package:flutter_credit_card/credit_card_model.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';
import 'package:http/http.dart';
import 'package:web3dart/web3dart.dart';
import 'Profilepage.dart';

class Deposit extends StatefulWidget {
  @override
  _DepositState createState() => _DepositState();
}

class _DepositState extends State<Deposit> {
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

  Future<String> submit(String functionName , List<dynamic> args) async
  {
    EthPrivateKey credentials = EthPrivateKey.fromHex("a9bf134facdd642a02e1f6e008cb21901e28952c0541df466e76cb8cda3ed296");
    DeployedContract contract = await loadContract();
    final ethFunction = contract.function(functionName);
    final result = await ethClient.sendTransaction(credentials, Transaction.callContract(contract: contract, function: ethFunction, parameters: args) , fetchChainIdFromNetworkId: true);
    return result;
  }

  Future<String> sendCoin() async{
    var bigAmount = BigInt.from(myAmount);
    var response = await submit("depositBalance" , [bigAmount]);
    print("Deposited");
    return response;
  }

  Future<String> withdrawCoin() async{
    var bigAmount = BigInt.from(myAmount);
    var response = await submit("withdrawBalance" , [bigAmount]);
    print("Withdrawn");
    return response;
  }

  String amount = '';
  String cardNumber = '';
  String expiryDate = '';
  String cardHolderName = '';
  String cvvCode = '';
  bool isCvvFocused = false;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Column(
          children: <Widget>[
            CreditCardWidget(
              cardNumber: cardNumber,
              expiryDate: expiryDate,
              cardHolderName: cardHolderName,
              cvvCode: cvvCode,
              showBackView: isCvvFocused,
              obscureCardNumber: true,
              obscureCardCvv: true,
              cardBgColor: Colors.redAccent,
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    CreditCardForm(
                      formKey: formKey,
                      obscureCvv: true,
                      obscureNumber: true,
                      cardNumber: cardNumber,
                      cvvCode: cvvCode,
                      cardHolderName: cardHolderName,
                      expiryDate: expiryDate,
                      themeColor: Colors.redAccent,
                      cardNumberDecoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Number',
                        hintText: 'XXXX XXXX XXXX XXXX',
                      ),
                      expiryDateDecoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Expired Date',
                        hintText: 'XX/XX',
                      ),
                      cvvCodeDecoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'CVV',
                        hintText: 'XXX',
                      ),
                      cardHolderDecoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Card Holder',
                      ),
                      onCreditCardModelChange: onCreditCardModelChange,
                    ),
                    Padding(
                      padding: EdgeInsets.all(16.0),
                      child: TextField(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(4.0)
                          ),
                          labelText: 'Amount'
                        ),
                        onChanged: (value) {
                          setState(() {
                            myAmount = int.parse(value);
                          });
                        },
                      ),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        primary: Colors.redAccent,
                      ),
                      child: Container(
                        margin: const EdgeInsets.all(8),
                        child: const Text(
                          'Deposit',
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'halter',
                            fontSize: 14,
                            package: 'flutter_credit_card',
                          ),
                        ),
                      ),
                      onPressed: () {
                        if (formKey.currentState.validate()) {
                          print('valid!');
                          setState(() {
                            sendCoin();
                          });
                          Navigator.pop(context);
                          // add code
                        } else {
                          print('invalid!');
                        }
                      },
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void onCreditCardModelChange(CreditCardModel creditCardModel) {
    setState(() {
      cardNumber = creditCardModel.cardNumber;
      expiryDate = creditCardModel.expiryDate;
      cardHolderName = creditCardModel.cardHolderName;
      cvvCode = creditCardModel.cvvCode;
      isCvvFocused = creditCardModel.isCvvFocused;
    });
  }
}
