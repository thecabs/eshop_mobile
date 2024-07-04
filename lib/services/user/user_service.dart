import 'dart:convert';
import 'package:eshop/constants.dart';
import 'package:eshop/models/api_response.dart';
import 'package:eshop/models/user.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

// login
Future<ApiResponse> login(String login, String password) async {
  ApiResponse apiResponse = ApiResponse();

  try {
    final response = await http.post(
      Uri.parse(loginGestURL),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
      body: json.encode({'login': login, 'password': password}),
    );
    print(response.body);
    switch (response.statusCode) {
      case 200:
        final responseData = json.decode(response.body);
        apiResponse.data = User.fromJson(responseData['user']);
        SharedPreferences pref = await SharedPreferences.getInstance();
        await pref.setString('token', responseData['token']);
        await pref.setString('nomGest', responseData['user']['nomGest']);
        break;
      case 401:
        apiResponse.error = 'Unauthorized';
        break;
      default:
        apiResponse.error = 'Something went wrong. Please try again.';
        break;
    }
  } catch (e) {
    apiResponse.error = 'Server error. Please try again. Exception: $e';
    print(e);
  }

  return apiResponse;
}

// logout
Future<ApiResponse> logout() async {
  ApiResponse apiResponse = ApiResponse();

  try {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String token = pref.getString('token') ?? '';

    final response = await http.post(
      Uri.parse(logoutGestURL),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    switch (response.statusCode) {
      case 200:
        await pref.remove('token');
        await pref.remove('nomGest');
        apiResponse.data = 'Logout successful';
        break;
      default:
        apiResponse.error = 'Something went wrong. Please try again.';
        break;
    }
  } catch (e) {
    apiResponse.error = 'Server error. Please try again.';
  }

  return apiResponse;
}

// get user detail
Future<ApiResponse> getUserDetail() async {
  ApiResponse apiResponse = ApiResponse();

  try {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String token = pref.getString('token') ?? '';

    print('Retrieved Token: $token'); // Debugging output

    final response = await http.get(
      Uri.parse(userdetailURL),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    print('Response Status: ${response.statusCode}'); // Debugging output
    print('Response Body: ${response.body}'); // Debugging output

    switch (response.statusCode) {
      case 200:
        final responseData = json.decode(response.body);
        if (responseData['user'] != null) {
          apiResponse.data = User.fromJson(responseData['user']);
        } else {
          apiResponse.error =
              'No user data found. User might not exist or token is invalid.';
        }
        break;
      case 401:
        apiResponse.error = 'Unauthorized. Token might be invalid or expired.';
        break;
      default:
        apiResponse.error = 'Something went wrong. Please try again.';
        break;
    }
  } catch (e) {
    apiResponse.error = 'Server error. Please try again. Exception: $e';
  }

  return apiResponse;
}

// get token
Future<String> getToken() async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  return pref.getString('token') ?? '';
}

// get user name
Future<String?> getUserName() async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  return pref.getString('nomGest');
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
