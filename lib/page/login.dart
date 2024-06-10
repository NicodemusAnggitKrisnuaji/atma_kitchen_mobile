import 'package:flutter/material.dart';
import 'package:atma_kitchen_mobile/model/user.dart';
import 'package:atma_kitchen_mobile/page/profile.dart';
import 'package:atma_kitchen_mobile/data/user_client.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool _isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Form(
          key: formKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'images/logo.png',
                          width: 150,
                          height: 150,
                          color: Colors.black,
                        ),
                        Text(
                          "Atma Kitchen",
                          style: TextStyle(
                            color: Color(0xFFfcc0c0),
                            fontWeight: FontWeight.bold,
                            fontSize: 30),
                        ),
                      ],
                    ),
                  ),
                  TextFormField(
                    controller: emailController,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.email),
                      labelText: 'Email',
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please Enter Your Email';
                      } else if (!value.contains('@')) {
                        return 'Email Must Contain @ Character';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: passwordController,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.lock),
                      labelText: 'Password',
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            _isPasswordVisible = !_isPasswordVisible;
                          });
                        },
                        icon: Icon(
                          _isPasswordVisible ? Icons.visibility_off : Icons.visibility,
                          color: _isPasswordVisible ? Colors.grey : Color(0xFFfcc0c0),
                        ),
                      ),
                    ),
                    obscureText: !_isPasswordVisible,
                    validator: (value) => value == '' ? 'Please Enter Your Password' : null,
                  ),
                  const SizedBox(height: 30),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          _login(emailController.text, passwordController.text);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFFfcc0c0),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
                        child: Text("Login"),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _login(String email, String password) async {
    try {
      print(email);
      Map<String, dynamic>? loginResponse = await UserClient.login(email, password);

      if (loginResponse == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Login failed: response is null'),
          ),
        );
      } else if (loginResponse.containsKey('status') && loginResponse['status'] != 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(loginResponse['message'] ?? 'Unknown error'),
          ),
        );
      } else {
        User userData = User.fromJson(loginResponse['data']);
        await saveLoginData(userData);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Login Success'),
          ),
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => ProfileView(user: userData),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Login Failed: $e'),
        ),
      );
    }
  }

  Future<void> saveLoginData(User userData) async {
    SharedPreferences sharedPrefs = await SharedPreferences.getInstance();
    await sharedPrefs.setInt('userID', userData.id ?? 0);
    await sharedPrefs.setString('nama', userData.nama ?? '');
    await sharedPrefs.setString('email', userData.email ?? '');
    await sharedPrefs.setString('password', userData.password ?? '');
    await sharedPrefs.setString('alamat', userData.alamat ?? '');
    await sharedPrefs.setString('tanggal_lahir', userData.tanggal_lahir ?? '');
    await sharedPrefs.setString('nomor_telepon', userData.nomor_telepon ?? '');
    await sharedPrefs.setString('saldo', userData.saldo ?? '');
  }
}
