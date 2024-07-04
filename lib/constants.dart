import 'package:flutter/material.dart';

const kPrimaryColor = Colors.blue;
const kPrimaryLightColor = Color(0xFFFFECDF);
const kPrimaryGradientColor = LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: [Color(0xFFFFA53E), Color.fromRGBO(255, 118, 67, 1)],
);
const kSecondaryColor = Colors.blue;
const kTextColor = Colors.black;

const kAnimationDuration = Duration(milliseconds: 200);

const headingStyle = TextStyle(
  fontSize: 24,
  fontWeight: FontWeight.bold,
  color: Colors.black,
  height: 1.5,
);

const defaultDuration = Duration(milliseconds: 250);

// Form Error
final RegExp emailValidatorRegExp =
    RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
const String kEmailNullError = "Please Enter your login";
const String kInvalidEmailError = "Please Enter Valid Login";
const String kPassNullError = "Please Enter your password";
const String kShortPassError = "Password is too short";
const String kMatchPassError = "Passwords don't match";
const String kNamelNullError = "Please Enter your name";
const String kPhoneNumberNullError = "Please Enter your phone number";
const String kAddressNullError = "Please Enter your address";

final otpInputDecoration = InputDecoration(
  contentPadding: const EdgeInsets.symmetric(vertical: 16),
  border: outlineInputBorder(),
  focusedBorder: outlineInputBorder(),
  enabledBorder: outlineInputBorder(),
);

OutlineInputBorder outlineInputBorder() {
  return OutlineInputBorder(
    borderRadius: BorderRadius.circular(16),
    borderSide: const BorderSide(color: kTextColor),
  );
}

const base = '192.168.1.145:8000';

//const baseURL = 'http://192.168.1.145:8000/api';
const baseURL = 'http://' + base + '/api';
const createGestURL = baseURL + '/createGest';
const loginGestURL = baseURL + '/loginGest';
const logoutGestURL = baseURL + '/logoutGest';
const userdetailURL = baseURL + '/user';

const createCommandeURL = baseURL + '/createCommande';
const listVilleURL = baseURL + '/listVille';

const produitByCategorieURL = 'http://' + base + '/api/produitByCategories/';
const produitListUrl = '/api/produitsList';

const getQuantityURL = 'http://' + base + '/api/getquantity/';
const getCategorienameURL = 'http://' + base + '/api/categories/';
const listCategorieURL = baseURL + '/listCategories';

// ----- Errors -----
const serverError = 'Server Error';
const networkError = 'Network Error';
const unknownError = 'Unknown Error';

const unauthorized = 'Unauthorized';
const somethingWentWrong = 'Something went wrong, try again!';
const defaultPadding = 16.0;
