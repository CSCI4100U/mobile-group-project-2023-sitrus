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

    return Form(
      child: Material(
        key: formKey,
        child: Column(
          children: [
            TextFormField(
              style: const TextStyle(fontSize: 30),
              decoration: const InputDecoration(
                label: Text("E-mail: "),
                hintText: "name@email.com",
              ),
              validator: (value){
                print("validating email: $value");
                if(value!.length < 7){
                  return "email must not be short";
                }
                return null;
              },
              onSaved: (value){
                print("Saving Email $value");
              },
            ),
            TextFormField(
              style: const TextStyle(fontSize: 30),
              obscureText: true,
              decoration: const InputDecoration(
                label: Text("Password: "),

              ),
              onSaved: (value){
                print("Saving Email $value");
              },
            ),
            DropdownButtonFormField(
                style: const TextStyle(fontSize: 30),
                items: <String>["Canada", "USA", "Mars"]
                    .map<DropdownMenuItem>((String value){
                  return DropdownMenuItem<String>(value: value,child: Text(value));
                }).toList(),
                onChanged: (value){
                  print(value);
                }),
            ElevatedButton(onPressed: (){
              print("Attempting to register");

              if(formKey.currentState!.validate()){
                print("validated");
                formKey.currentState!.save();
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Registered User")));
              } else {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Registration Failed")));
              }
            }, child: const Text("Register", textScaleFactor: 2, style: TextStyle(fontSize: 30),),

            )
          ],
        ),
      )

      );

  }
}
