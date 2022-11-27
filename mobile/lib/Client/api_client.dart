import 'package:http/http.dart' as http;
import 'package:swadesh_challenge/Models/user_data.dart';
import 'package:swadesh_challenge/Models/transaction.dart';

import 'dart:convert';
import 'package:device_info_plus/device_info_plus.dart';
import 'dart:io' as io;

class ApiClient {
  static const baseUrl =
      "https://w6nwswt8dh.execute-api.us-east-1.amazonaws.com/staging/transactions";

  Future<String?> _getId() async {
    var deviceInfo = DeviceInfoPlugin();
    if (io.Platform.isIOS) {
      var iosDeviceInfo = await deviceInfo.iosInfo;
      return iosDeviceInfo.identifierForVendor;
    } else if (io.Platform.isAndroid) {
      var androidDeviceInfo = await deviceInfo.androidInfo;
      return androidDeviceInfo.androidId;
    }
    return "invalid";
  }

  Future<String> _getEndpoint() async {
    final deviceId = await _getId();
    return baseUrl + "?id=" + (deviceId ?? "");
  }

  Future<UserData> fetchData() async {
    final response = await http.get(Uri.parse(await _getEndpoint()));
    if (response.statusCode == 200) {
      return UserData.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load user data');
    }
  }

  Future<http.Response> addTransaction(Transaction transaction) async {
    return http.post(
      Uri.parse(await _getEndpoint()),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: transaction.toJson(),
    );
  }
}
