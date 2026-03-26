import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'home.dart';
import 'signup.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<StatefulWidget> createState() => _LoginState();
}

class _LoginState extends State<Login> {

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool isLoading = false;

  /// 🔐 LOGIN FUNCTION
  Future<void> login() async {

    if (emailController.text.isEmpty ||
        passwordController.text.isEmpty) {

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill all fields")),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {

      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Login Successful")),
      );

      /// 🚀 Navigate to Home
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const Home()),
      );

    } on FirebaseAuthException catch (e) {

      String message = "Login failed";

      if (e.code == 'user-not-found') {
        message = "User not found";
      } else if (e.code == 'wrong-password') {
        message = "Wrong password";
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
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
          
                    const Text(
                      'Welcome\nBack',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 35,
                          fontWeight: FontWeight.w500),
                    ),
          
                    const SizedBox(height: 120),
          
                    /// EMAIL
                    const Text('Email',
                        style: TextStyle(color: Colors.white, fontSize: 18)),
                    const SizedBox(height: 10),
          
                    inputField(
                      controller: emailController,
                      hint: "Enter Email",
                      icon: Icons.email,
                    ),
          
                    const SizedBox(height: 20),
          
                    /// PASSWORD
                    const Text('Password',
                        style: TextStyle(color: Colors.white, fontSize: 18)),
                    const SizedBox(height: 10),
          
                    inputField(
                      controller: passwordController,
                      hint: "Enter Password",
                      icon: Icons.lock,
                      isPassword: true,
                    ),
          
                    const SizedBox(height: 80),
          
                    /// LOGIN BUTTON
                    Padding(
                      padding: const EdgeInsets.only(left: 40, right: 50),
                      child: Row(
                        mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                        children: [
          
                          const Text(
                            'Login',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 30,
                                fontWeight: FontWeight.bold),
                          ),
          
                          GestureDetector(
                            onTap: isLoading ? null : login,
                            child: Container(
                              height: 80,
                              width: 80,
                              decoration: BoxDecoration(
                                  color: const Color(0xff984c6e),
                                  borderRadius: BorderRadius.circular(60)),
                              child: isLoading
                                  ? const Center(
                                      child: CircularProgressIndicator(
                                          color: Colors.white))
                                  : const Icon(Icons.arrow_forward,
                                      color: Colors.white),
                            ),
                          )
                        ],
                      ),
                    ),
          
                    const SizedBox(height: 40),
          
                    /// SIGNUP REDIRECT
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('Don’t have an Account?',
                            style: TextStyle(color: Colors.black)),
                        const SizedBox(width: 5),
          
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => const Signup()),
                            );
                          },
                          child: const Text(
                            'Sign Up',
                            style: TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.bold),
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
      ),
    );
  }

  /// 🔧 INPUT FIELD
  Widget inputField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool isPassword = false,
  }) {
    return Container(
      margin: const EdgeInsets.only(right: 30),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(60)),
      child: TextField(
        controller: controller,
        obscureText: isPassword,
        decoration: InputDecoration(
          border: InputBorder.none,
          prefixIcon: Icon(icon, color: Colors.black),
          hintText: hint,
        ),
      ),
    );
  }
}