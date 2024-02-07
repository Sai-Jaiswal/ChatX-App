import 'package:chatx/widgets/rounded_button.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Login extends StatefulWidget {

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  FirebaseAuth auth = FirebaseAuth.instance;

  final TextEditingController emailController = TextEditingController();

  final TextEditingController passController = TextEditingController();

  bool obscureText = true;
  bool isAuthenticating = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: MediaQuery.of(context).size.width/1.25,
               child: const Column(
                 children: [
                   Text("Login", style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),),
                   SizedBox(height: 20,),
                   Text("Remember to get up & stretch once in a while - your friends & chat.", textAlign: TextAlign.center, style: TextStyle(fontSize: 14, color: Colors.grey),)
                 ],
               ),
              ),

              const SizedBox(height: 30,),

              Container(
                margin: const EdgeInsets.symmetric(horizontal: 30),
                padding: const EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black, width: 2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.person_2_outlined, size: 30,),
                        const SizedBox(width: 10,),
                        Expanded(
                          child: TextField(
                            controller: emailController,
                            cursorColor: Colors.black,
                            keyboardType: TextInputType.emailAddress,
                            style: const TextStyle(
                              fontSize: 16
                            ),
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: "Email"
                            ),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20,),

              Container(
                margin: const EdgeInsets.symmetric(horizontal: 30),
                padding: const EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black, width: 2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.lock_outline, size: 30,),
                        const SizedBox(width: 10,),
                        Expanded(
                          child: TextField(
                            controller: passController,
                            obscureText: obscureText,
                            cursorColor: Colors.black,
                            keyboardType: TextInputType.text,
                            style: const TextStyle(
                                fontSize: 16
                            ),
                            decoration: const InputDecoration(
                                border: InputBorder.none,
                                hintText: "Password"
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: (){
                            setState(() {
                              if(obscureText){
                                obscureText = false;
                              }else{
                                obscureText = true;
                              }
                            });
                          },
                            splashRadius: 20,
                          icon: obscureText ? const Icon(Icons.visibility) : const Icon(Icons.visibility_off)
                        )
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30,),

              RoundedButton(title: "Sign In", size: 15,buttonFunc: () async {
                try{
                  setState(() {
                    isAuthenticating = true;
                  });
                  await auth.signInWithEmailAndPassword(email: emailController.text, password: passController.text).then((value){
                    Navigator.pushNamedAndRemoveUntil(context, "/", (route) => false);
                  }).onError((error, stackTrace){
                    setState(() {
                      isAuthenticating = false;
                    });
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text("Please Enter the correct Credentials"),
                      backgroundColor: Colors.red,
                      shape: RoundedRectangleBorder(),
                      duration: Duration(seconds: 2),
                    ));
                    passController.clear();
                  });
                }catch (e) {
                  print("Some Error Occurred");
                  print(e);
                }
              }),

              SizedBox(height: 20,),

              isAuthenticating ?
                  CircularProgressIndicator(color: Colors.purple,)
              : Container(),

              const SizedBox(height: 20,),

              InkWell(
                onTap: (){},
                child: const Text("Forgot Password?", style: TextStyle(color: Colors.purple, fontSize: 14),),
              ),

              const SizedBox(height: 30,),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Dont't have an Account?", style: TextStyle(fontSize: 14),),
                  const SizedBox(width: 10,),
                  InkWell(
                    onTap: () {
                      Navigator.pushNamed(context, "/sign_up");
                    },
                    child: const Text("Sign Up Here", style: TextStyle(color: Colors.purple, fontSize: 14),),
                  )
                ],
              )

            ],
          ),
        ),
      ),
    );
  }
}
