import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<StatefulWidget> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Stack(
          children: [
            Image.asset(
              'images/signup.png',
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              fit: BoxFit.cover,
            ),

            Padding(
              padding: const EdgeInsets.only(left: 20.0, top: 50.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Welcome\nBack',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 35.0,
                        fontWeight: FontWeight.w500),
                  ),

                  SizedBox(height: 120.0),

                  // EMAIL
                  Text(
                    'Email',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18.0,
                        fontWeight: FontWeight.w500),
                  ),
                  SizedBox(height: 20.0),
                  Container(
                    margin: EdgeInsets.only(right: 30.0),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(60)),
                    child: TextField(
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          prefixIcon: Icon(Icons.email,
                              size: 28.0, color: Colors.black),
                          hintText: 'Enter the Email',
                          hintStyle: TextStyle(
                              color: Colors.grey, fontSize: 18.0)),
                    ),
                  ),

                  SizedBox(height: 30.0),

                  // PASSWORD
                  Text(
                    'Password',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18.0,
                        fontWeight: FontWeight.w500),
                  ),
                  SizedBox(height: 20.0),
                  Container(
                    margin: EdgeInsets.only(right: 30.0),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(60)),
                    child: TextField(
                      obscureText: true,
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          prefixIcon: Icon(Icons.password,
                              size: 28.0, color: Colors.black),
                          hintText: 'Enter the Password',
                          hintStyle: TextStyle(
                              color: Colors.grey, fontSize: 18.0)),
                    ),
                  ),

                  SizedBox(height: 120.0),

                  // LOGIN BUTTON
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 40.0, right: 50.0),
                    child: Row(
                      mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Login',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 30.0,
                              fontWeight: FontWeight.bold),
                        ),
                        GestureDetector(
                          onTap: () {
                            // Add login logic here
                          },
                          child: Container(
                            height: 100,
                            width: 100,
                            decoration: BoxDecoration(
                                color: Color(0xff984c6e),
                                borderRadius:
                                    BorderRadius.circular(60)),
                            child: Icon(Icons.arrow_forward,
                                color: Colors.white),
                          ),
                        )
                      ],
                    ),
                  ),

                  SizedBox(height: 40),

                  // SIGNUP REDIRECT
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Don’t have an Account?',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 20.0,
                            fontWeight: FontWeight.w500),
                      ),
                      SizedBox(width: 5),
                      GestureDetector(
                        onTap: () {
                          // Navigate to Signup
                        },
                        child: Text(
                          'Sign Up',
                          style: TextStyle(
                              color: Colors.blue,
                              fontSize: 22.0,
                              fontWeight: FontWeight.w500),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}