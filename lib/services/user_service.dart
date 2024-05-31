import 'dart:convert';
import 'dart:io';
import 'package:eshop/constants.dart';
import 'package:eshop/models/api_response.dart';
import 'package:eshop/models/User.dart';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

// login

Future<ApiResponse> login(String login, String password) async {
  ApiResponse apiResponse = ApiResponse();

  try {
    final response = await http.post(Uri.parse(loginGestURL),
        headers: {'Accept': 'application/json'},
        body: json.encode({'login': login, 'password': password}));
    print(response.body);
    switch (response.statusCode) {
      case 200:
        apiResponse.data = User.fromJson(json.decode(response.body));
        break;
      case 422:
        final errors = jsonDecode(response.body)['errors'];
        apiResponse.error = errors[errors.keys.elementAt(0)][0];
        break;
      case 401:
        apiResponse.error = jsonDecode(response.body)['message'];
        break;

      default:
        apiResponse.error = somethingWentWrong;
        break;
    }
  } catch (e) {
    apiResponse.error = serverError;
    // print(e.toString());
  }

  return apiResponse;
}

// register

Future<ApiResponse> createGest(String nomGest, int typeGest, String login,
    String password, String mobile) async {
  ApiResponse apiResponse = ApiResponse();
  try {
    final response = await http.post(Uri.parse(createGestURL), headers: {
      'Accept': 'application/json'
    }, body: {
      'nomGest': nomGest,
      'typeGest': typeGest,
      'login': login,
      'password': password,
      'mobile': mobile,
    });
    //print(response.body);

    switch (response.statusCode) {
      case 201:
        apiResponse.data = User.fromJson(json.decode(response.body));
        break;
      case 422:
        final errors = jsonDecode(response.body)['errors'];
        apiResponse.error = errors[errors.keys.elementAt(0)][0];
        break;
      default:
        apiResponse.error = somethingWentWrong;
        break;
    }
  } catch (e) {
    print(e.toString());
    //apiResponse.error = serverError;
  }

  return apiResponse;
}

// get user detail

Future<ApiResponse> getUserDetail() async {
  ApiResponse apiResponse = ApiResponse();

  try {
    String token = await getToken();
    final response = await http.get(
      Uri.parse(userdetailURL),
      headers: {'Accept': 'application/json', 'Authorization': 'Bearer $token'},
    );

    switch (response.statusCode) {
      case 200:
        apiResponse.data = User.fromJson(json.decode(response.body));
        break;
      case 401:
        apiResponse.error = unauthorized;

      default:
        apiResponse.error = somethingWentWrong;
        break;
    }
  } catch (e) {
    apiResponse.error = serverError;
  }

  return apiResponse;
}

// update user

// // Update user
// Future<ApiResponse> updateUser(String name, String? image) async {
//   ApiResponse apiResponse = ApiResponse();
//   try {
//     String token = await getToken();
//     final response = await http.put(
//       Uri.parse(userdetailURL),
//       headers: {
//         'Accept': 'application/json',
//         'Authorization': 'Bearer $token'
//       },
//       body: image == null ? {
//         'name': name,
//       } : {
//         'name': name,
//         'image': image
//       });
//       // user can update his/her name or name and image

//     switch(response.statusCode) {
//       case 200:
//         apiResponse.data =jsonDecode(response.body)['message'];
//         break;
//       case 401:
//         apiResponse.error = unauthorized;
//         break;
//       default:
//         print(response.body);
//         apiResponse.error = somethingWentWrong;
//         break;
//     }
//   }
//   catch (e) {
//     apiResponse.error = serverError;
//   }
//   return apiResponse;
// }

// get token
Future<String> getToken() async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  return pref.getString('token') ?? '';
}

// get user id
Future<int> getUserId() async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  return pref.getInt('userId') ?? 0;
}

// logout
Future<bool> logout() async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  return await pref.remove('token');
}

// Get base64 encoded image
String? getStringImage(File? file) {
  if (file == null) return null;
  return base64Encode(file.readAsBytesSync());
}
