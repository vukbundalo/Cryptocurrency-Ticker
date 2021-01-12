import 'package:http/http.dart' as http;
import 'dart:convert';

const List<String> currenciesList = [
//  'BRL',
//  'CAD',
//  'CNY',
//  'HKD',
//  'IDR',
//  'ILS',
//  'INR',
//  'ZAR',
//  'MXN',
//  'NOK',
//  'NZD',
//  'PLN',
//  'RON',
//  'RUB',
//  'SEK',
//  'SGD',
  'AUD',
  'BAM',
  'GBP',
  'USD',
  'EUR',
  'JPY',
];

const List<String> cryptoList = [
  'BTC',
  'ETH',
  'LTC',
];

const apiURL = 'https://rest.coinapi.io/v1/exchangerate/';
const apiKey = ' 21BC4C03-CC32-44F0-A80D-F4C1E3BF1349'; //'AA80AD02-2EC7-40D0-944E-FE0615BA047B';

class CoinData {
  Future getCoinData(String selectedCurrency) async{
    Map<String, String> cryptoPrices = {};
    for (String crypto in cryptoList){
      String requestURL = '$apiURL$crypto/$selectedCurrency?apikey=$apiKey';
      http.Response response = await http.get(requestURL);
      if (response.statusCode == 200){
        var decodedData = jsonDecode(response.body);
        double price = decodedData['rate'];
        cryptoPrices[crypto] = price.toStringAsFixed(0);
      } else{
        print(response.statusCode);
        throw 'Problem with the get request';
      }
    }
    return cryptoPrices;
  }
}
