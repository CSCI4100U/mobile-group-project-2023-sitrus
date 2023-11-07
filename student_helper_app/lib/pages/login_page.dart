//should use school's login?
//have the standards for login pages
import 'package:flutter/material.dart';


class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(

            key: formKey,
            child: Column(
              
              mainAxisAlignment: MainAxisAlignment.center,

              children: [

                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 35),
                  child: TextFormField(
                    style: const TextStyle(fontSize: 40, ),
                    decoration: const InputDecoration(
                      label: Text("Username: ", textScaleFactor: 2),
                      hintText: "username",
                    ),
                    validator: (value){
                      print("validating email: $value");
                      if(value!.length < 7){
                        return "email must not be short";
                      }
                      return null;
                    },
                    onSaved: (value){
                      print("Saving username $value");
                    },
                  ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 30, horizontal: 35),
                  child: TextFormField(
                    style: const TextStyle(fontSize: 30),
                    obscureText: true,
                    decoration: const InputDecoration(
                      label: Text("Password: ", textScaleFactor: 2),

                    ),
                    onSaved: (value){
                      print("Saving password $value");
                    },
                  ),
                ),

                ElevatedButton(

                  onPressed: (){
                  print("Attempting to login");

                  if(formKey.currentState!.validate()){
                    print("validated");
                    formKey.currentState!.save();
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("User Logged In")));
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Incorrect username or password")));
                  }
                }, child: const Text("Login", textScaleFactor: 1.5, style: TextStyle(fontSize: 30),  ),

                )
              ],
            ),


      ),
    );


  }
}
