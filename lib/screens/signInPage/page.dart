import 'package:evenager/services/authentication_service.dart';
import 'package:evenager/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SignInPage extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: double.infinity,
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color.fromRGBO(180, 85, 255, 1),
                  Color.fromRGBO(160, 65, 240, 1),
                  Color.fromRGBO(130, 25, 227, 1),
                ],
              ),
            ),
          ),
          Container(
            height: double.infinity,
            padding: EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset('assets/images/logo_transparent.png'),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 30,
                    ),
                    Text(
                      'Email',
                      style: kLabelStyle,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    _buildEmailInput(),
                    SizedBox(
                      height: 30,
                    ),
                    Text(
                      'Senha',
                      style: kLabelStyle,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    _buildPasswordInput(),
                    SizedBox(
                      height: 30,
                    ),
                    _buildSubmitButton(context),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Container _buildEmailInput() {
    return Container(
      alignment: Alignment.centerLeft,
      decoration: kBoxDecorationStyle,
      height: 60,
      child: TextField(
        controller: emailController,
        keyboardType: TextInputType.emailAddress,
        style: TextStyle(
          color: Colors.white,
          fontFamily: 'OpenSans',
        ),
        decoration: InputDecoration(
          border: InputBorder.none,
          contentPadding: EdgeInsets.only(top: 15),
          prefixIcon: Icon(
            Icons.email,
            color: Colors.white,
          ),
          hintText: 'Digite seu email',
          hintStyle: kHintTextStyle,
        ),
      ),
    );
  }

  Container _buildPasswordInput() {
    return Container(
      alignment: Alignment.centerLeft,
      decoration: kBoxDecorationStyle,
      height: 60,
      child: TextField(
        controller: passwordController,
        obscureText: true,
        style: TextStyle(
          color: Colors.white,
          fontFamily: 'OpenSans',
        ),
        decoration: InputDecoration(
          border: InputBorder.none,
          contentPadding: EdgeInsets.only(top: 15),
          prefixIcon: Icon(
            Icons.vpn_key,
            color: Colors.white,
          ),
          hintText: 'Digite sua senha',
          hintStyle: kHintTextStyle,
        ),
      ),
    );
  }

  Container _buildSubmitButton(BuildContext context) {
    return Container(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          context.read<AuthenticationService>().signIn(
                email: emailController.text.trim(),
                password: passwordController.text.trim(),
              );
        },
        style: ButtonStyle(
          padding: MaterialStateProperty.all(EdgeInsets.all(15)),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          ),
          backgroundColor: MaterialStateProperty.all(Colors.white),
        ),
        child: Text(
          "ENTRAR",
          style: TextStyle(
            color: Color.fromRGBO(160, 65, 240, 1),
            fontWeight: FontWeight.bold,
            fontSize: 18,
            letterSpacing: 2.5,
            fontFamily: "OpenSans",
          ),
        ),
      ),
    );
  }
}
