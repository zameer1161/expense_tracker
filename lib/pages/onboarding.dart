import 'package:flutter/material.dart';

class Onboarding extends StatefulWidget{
  const Onboarding({super.key});

  @override
  State<StatefulWidget> createState() => _OnboardingState();
  }

class _OnboardingState extends State<Onboarding>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        child: Column(
          children: [
            SizedBox(height: 50.0,),
            Image.asset('images/onboard.png'),
            SizedBox(height: 50.0,),
            Expanded(
              child: Container(
                margin: EdgeInsets.only(left: 10.0,right: 10.0,bottom: 20.0),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius:BorderRadius.only(topLeft: Radius.circular(60),
                    topRight:Radius.circular(60)),
                ),
                width: MediaQuery.of(context).size.width,
                child: Column(
                  children: [
                    SizedBox(height: 20.0,),
                    Text('manage your Daily\nlife expenses',
                        textAlign: TextAlign.center,
                        style:TextStyle(color: Colors.black)),
                    SizedBox(height: 20.0,),
                    Padding(
                      padding: const EdgeInsets.only(left: 30.0,right:20.0),
                      child: Text('Expense tracker is a simple and efficient personal finanac management app that allows you to track you daily expense and income',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.black,
                      fontWeight: FontWeight.w500,
                      fontSize: 18.0),
                      ),
                    ),
                    SizedBox(height: 20.0,),
                    Container(
                      margin: EdgeInsets.only(left: 40.0,right: 40.0),
                      child: Material(
                        elevation: 3.0,
                        borderRadius: BorderRadius.circular(60),
                        child: Container(
                          margin: EdgeInsets.only(left: 40.0,right: 30.0),
                          height: 80,
                          decoration: BoxDecoration(color: Colors.red,
                          borderRadius: BorderRadius.circular(60)),
                          width: MediaQuery.of(context).size.width,
                          child: Center(
                            child: Text('Get Started',style: TextStyle(color: Colors.white,
                            fontSize: 22.0,
                            fontWeight: FontWeight.bold),),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

