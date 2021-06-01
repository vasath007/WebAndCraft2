import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

class ApiServices
{
  var _baseUrl = "http://www.mocky.io/v2";
  var headers = {
    HttpHeaders.acceptHeader: "application/json",
    HttpHeaders.contentTypeHeader: "application/x-www-form-urlencoded",
  };
  getUserDetails() async
  {
    var url = Uri.parse(_baseUrl+"/5d565297300000680030a986");
    try
        {
          var response = await http.get(url);
          print(response.statusCode);
          if(response.statusCode == 200)
            {
              var decodeResponse = jsonDecode(response.body);
              return decodeResponse;
            }else{
            response.statusCode;
          }
        }
        catch(error){
          print(error);
        }
  }
}