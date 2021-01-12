import 'package:flutter/material.dart';
import 'coin_data.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io' show Platform;
import 'constants.dart';

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  String selectedCurrency = 'AUD';

  @override
  void initState() {
    super.initState();
    getData();
  }

  Map<String, String> coinPrices = {};
  Map<String, Color> coinColors = {
    'BTC': Color(0xFFDEE2FF),
    'ETH': Color(0xFFFEEAFA),
    'LTC': Color(0xFFEFD3D7),
  };
  bool isWaiting = false;

  void getData() async {
    isWaiting = true;
    try {
      var data = await CoinData().getCoinData(selectedCurrency);
      isWaiting = false;
      setState(() {
        coinPrices = data;
      });
    } catch (e) {
      print(e);
    }
  }


  DropdownButton<String> androidDropdown(){
    List<DropdownMenuItem<String>> dropDownMenuItems = [];
    for(String currency in currenciesList){
      dropDownMenuItems.add(
          DropdownMenuItem(
            child: Text(currency),
            value: currency),
      );
    }
    return DropdownButton(
      value: selectedCurrency,
      items: dropDownMenuItems,
      onChanged: (value){
        setState(() {
          selectedCurrency = value;
          getData();
        });
      },
    );
  }
  CupertinoTheme iOSPicker(){
    List<Text> pickerItems = [];
    for(String currency in currenciesList){
      pickerItems.add(Text(currency));
    }
    return CupertinoTheme(
      data: CupertinoThemeData(
        textTheme: CupertinoTextThemeData(
            pickerTextStyle: TextStyle(color: textBackColor, fontSize:  20),
      ),
      ),
      child: CupertinoPicker(
        backgroundColor: barColor,
        itemExtent: 32,
        onSelectedItemChanged: (selectedIndex){
          setState(() {
            selectedCurrency = currenciesList[selectedIndex];
            getData();
          });
        },
        children: pickerItems,
      ),
    );
  }

  Column makeCards(){
      List<CryptoCard> cryptoCards = [];
      for (String crypto in cryptoList){
        cryptoCards.add(CryptoCard(
          cryptoCurrency: crypto,
          value: isWaiting ? '?' : coinPrices[crypto],
          selectedCurrency: selectedCurrency,
          color: coinColors[crypto],
        ),
        );
      }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: cryptoCards,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: barColor,
        title: Center(child: Text('Coin Ticker',style: TextStyle(color: textBackColor),)),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          makeCards(),
          Container(
            height: 150.0,
            alignment: Alignment.center,
            padding: EdgeInsets.only(bottom: 30.0),
            color: barColor,
            child: Platform.isIOS ? iOSPicker() : androidDropdown(),
          ),
        ],
      ),
    );
  }
}

class CryptoCard extends StatelessWidget {
  const CryptoCard({
    this.value,
    this.selectedCurrency,
    this.cryptoCurrency,
    this.color,
  });

  final String value;
  final String selectedCurrency;
  final String cryptoCurrency;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(1.0, 18.0, 1.0, 0),
      child: Card(
        color: color,
        elevation: 5.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 28.0),
          child: Row(
            children: <Widget>[
              Image.asset('images/$cryptoCurrency.png', width: 100, height: 100,),
              Text(
                '1 $cryptoCurrency = $value $selectedCurrency',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20.0,
                  color: textBackColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


