import 'package:flutter/material.dart';

class Signup  extends StatefulWidget{
  const Signup({super.key});

  @override
  State<StatefulWidget> createState()=> _SignupSatate(); 
  
}

class _SignupSatate extends State<Signup>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Stack(
          children: [
            Image.asset('images/signup.png',height: MediaQuery.of(context).size.height ,width: MediaQuery.of(context).size.width,fit: BoxFit.cover,),
            Padding(
              padding: const EdgeInsets.only(left: 20.0,top: 50.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Create\nAccount', style: TextStyle(color: Colors.white,fontSize:35.0 ,fontWeight: FontWeight.w500),),
                  SizedBox(height: 100.0,),
                  Text('Name',style: TextStyle(color: Colors.white,fontSize: 18.0,fontWeight: FontWeight.w500),),
                  SizedBox(height: 20.0,),
                  Container(
                    margin: EdgeInsets.only(right: 30.0),
                    decoration: BoxDecoration(color: Colors.white,borderRadius: BorderRadius.circular(60)) ,
                    child: TextField(
                      decoration: InputDecoration(border: InputBorder.none,prefixIcon: Icon(Icons.person,size: 28.0, color: Colors.black,),
                      hintText: 'Enter the Name',hintStyle: TextStyle(color: Colors.white,fontSize: 18.0)),
                    ),
                  ),
                  SizedBox(height: 30.0,),
                  Text('Email',style: TextStyle(color: Colors.white,fontSize: 18.0,fontWeight: FontWeight.w500),),
                  SizedBox(height: 20.0,),
                  Container(
                    margin: EdgeInsets.only(right: 30.0),
                    decoration: BoxDecoration(color: Colors.white,borderRadius: BorderRadius.circular(60)) ,
                    child: TextField(
                      decoration: InputDecoration(border: InputBorder.none,prefixIcon: Icon(Icons.email,size: 28.0, color: Colors.black,),
                          hintText: 'Enter the Email',hintStyle: TextStyle(color: Colors.white,fontSize: 18.0)),
                    ),
                  ),
                  SizedBox(height: 30.0,),
                  Text('Passsword',style: TextStyle(color: Colors.white,fontSize: 18.0,fontWeight: FontWeight.w500),),
                  SizedBox(height: 20.0,),
                  Container(
                    margin: EdgeInsets.only(right: 30.0),
                    decoration: BoxDecoration(color: Colors.white,borderRadius: BorderRadius.circular(60)) ,
                    child: TextField(
                      decoration: InputDecoration(border: InputBorder.none,prefixIcon: Icon(Icons.password,size: 28.0, color: Colors.black,),
                          hintText: 'Enter the Password',hintStyle: TextStyle(color: Colors.white,fontSize: 18.0)),
                    ),
                  ),
                  SizedBox(height: 100.0,),
                  Padding(
                    padding: const EdgeInsets.only(left:40.0,right: 50.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Next',style: TextStyle(color: Colors.white,fontSize: 30.0,fontWeight: FontWeight.bold),),
                        Container(
                          height: 100,
                          width: 100,
                          decoration: BoxDecoration(color: Color(0xff984c6e),borderRadius: BorderRadius.circular(60)),
                          child: Icon(Icons.arrow_forward,color: Colors.white,),
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: 40,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Already have an Account?',style: TextStyle(color: Colors.black,fontSize: 20.0,fontWeight: FontWeight.w500),),
                      Text('LogIn',style: TextStyle(color: Colors.blue,fontSize: 22.0,fontWeight: FontWeight.w500),)
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