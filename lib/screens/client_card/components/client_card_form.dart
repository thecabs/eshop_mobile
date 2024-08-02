import 'package:eshop/screens/client_card/components/client_cart_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:eshop/models/client_carte.dart';
import 'package:eshop/services/user/user_service.dart';
import 'package:eshop/constants.dart';
import 'package:eshop/helper/keyboard.dart';
import 'package:eshop/screens/components/custom_surfix_icon.dart';
import 'package:eshop/screens/components/form_error.dart';

class ClientCardForm extends StatefulWidget {
  const ClientCardForm({super.key});

  @override
  _ClientCardFormState createState() => _ClientCardFormState();
}

class _ClientCardFormState extends State<ClientCardForm> {
  final _formKey = GlobalKey<FormState>();
  String? matr;
  String? mobile;

  TextEditingController txtMatrController = TextEditingController();
  TextEditingController txtMobileController = TextEditingController();
  final List<String?> errors = [];
  Client? _clientInfo;
  bool loading = false;
  final ApiService _apiService = ApiService();
  bool rememberMatr = false;

  void addError({String? error}) {
    if (!errors.contains(error)) {
      setState(() {
        errors.add(error);
      });
    }
  }

  void removeError({String? error}) {
    if (errors.contains(error)) {
      setState(() {
        errors.remove(error);
      });
    }
  }

  Future<void> _fetchClientInfo() async {
    setState(() {
      loading = true;
    });

    final apiResponse = await _apiService.fetchClient(
        txtMatrController.text, txtMobileController.text);

    if (apiResponse.data != null) {
      setState(() {
        _clientInfo = apiResponse.data as Client;
        loading = false;
      });
    } else {
      setState(() {
        _clientInfo = null;
        loading = false;
      });
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(apiResponse.error ?? 'Error')));
    }

    if (rememberMatr) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('savedMatr', txtMatrController.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            controller: txtMatrController,
            keyboardType: TextInputType.name,
            onSaved: (newValue) => matr = newValue,
            onChanged: (value) {
              if (value.isNotEmpty) {
                removeError(error: kMatrNullError);
              }
            },
            validator: (value) {
              if (value!.isEmpty) {
                addError(error: kMatrNullError);
                return "";
              }
              return null;
            },
            decoration: const InputDecoration(
              labelText: "Matricule",
              hintText: "Enter your Matricule",
              floatingLabelBehavior: FloatingLabelBehavior.always,
              suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Lock.svg"),
            ),
          ),
          const SizedBox(height: 20),
          TextFormField(
            controller: txtMobileController,
            keyboardType: TextInputType.phone,
            onSaved: (newValue) => mobile = newValue,
            onChanged: (value) {
              if (value.isNotEmpty) {
                removeError(error: kMobileNullError);
              }
            },
            validator: (value) {
              if (value!.isEmpty) {
                addError(error: kMobileNullError);
                return "";
              }
              return null;
            },
            decoration: const InputDecoration(
              labelText: "Mobile",
              hintText: "Enter your Mobile Number",
              floatingLabelBehavior: FloatingLabelBehavior.always,
              suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Phone.svg"),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Checkbox(
                value: rememberMatr,
                onChanged: (value) {
                  setState(() {
                    rememberMatr = value!;
                  });
                },
              ),
              const Text("Remember Matricule"),
            ],
          ),
          FormError(errors: errors),
          const SizedBox(height: 16),
          loading
              ? const Center(child: CircularProgressIndicator())
              : ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      KeyboardUtil.hideKeyboard(context);
                      _fetchClientInfo().then((_) {
                        if (_clientInfo != null) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ClientCardScreen(
                                client: _clientInfo!,
                                rememberMatr: rememberMatr,
                              ),
                            ),
                          );
                        }
                      });
                    }
                  },
                  child: const Text("View Loyalty Card"),
                ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
