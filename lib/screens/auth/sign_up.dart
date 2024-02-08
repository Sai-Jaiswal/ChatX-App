import 'package:chatx/widgets/rounded_button.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:email_validator/email_validator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SignUp extends StatefulWidget {
  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final auth = FirebaseAuth.instance;
  final firestore = FirebaseFirestore.instance;

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();
  TextEditingController confirmPassController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool isSigning = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width / 1.25,
                child: const Column(
                  children: [
                    Text(
                      "Sign Up",
                      style:
                          TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      "Remember to get up & stretch once in a while - your friends & chat.",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              Form(
                key: _formKey,
                child: Column(
                  children: [
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
                              const Icon(
                                Icons.account_circle_outlined,
                                size: 30,
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                child: TextFormField(
                                  controller: nameController,
                                  cursorColor: Colors.black,
                                  keyboardType: TextInputType.text,
                                  style: const TextStyle(fontSize: 16),
                                  decoration: const InputDecoration(
                                      border: InputBorder.none,
                                      hintText: "Name"),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
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
                              const Icon(
                                Icons.person_2_outlined,
                                size: 30,
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                child: TextFormField(
                                    controller: emailController,
                                    cursorColor: Colors.black,
                                    keyboardType: TextInputType.emailAddress,
                                    style: const TextStyle(fontSize: 16),
                                    decoration: const InputDecoration(
                                        border: InputBorder.none,
                                        hintText: "Email"),
                                    validator: (value) {
                                      if (!EmailValidator.validate(
                                          emailController.text)) {
                                        return "Enter a valid email";
                                      }
                                    }),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
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
                              const Icon(
                                Icons.lock_outline,
                                size: 30,
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                child: TextFormField(
                                  validator: (value) {
                                    if (value!.length < 6) {
                                      return "Password must be atlest 6 characters";
                                    }
                                  },
                                  controller: passController,
                                  obscureText: true,
                                  cursorColor: Colors.black,
                                  keyboardType: TextInputType.text,
                                  style: const TextStyle(fontSize: 16),
                                  decoration: const InputDecoration(
                                      border: InputBorder.none,
                                      hintText: "Password"),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
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
                              const Icon(
                                Icons.lock_outline,
                                size: 30,
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                child: TextFormField(
                                  validator: (value) {
                                    if (value != passController.text) {
                                      return "Confirm password must be same as Password";
                                    } else if (value!.length < 6) {
                                      return "Password must be atlest 6 characters";
                                    }
                                  },
                                  controller: confirmPassController,
                                  obscureText: true,
                                  cursorColor: Colors.black,
                                  keyboardType: TextInputType.text,
                                  style: const TextStyle(fontSize: 16),
                                  decoration: const InputDecoration(
                                      border: InputBorder.none,
                                      hintText: "Confirm Password"),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    RoundedButton(
                        title: "Sign Up",
                        size: 15,
                        buttonFunc: () async {
                          try {
                            if (_formKey.currentState!.validate()) {
                              setState(() {
                                isSigning = true;
                              });
                              final newUser = await auth
                                  .createUserWithEmailAndPassword(
                                      email: emailController.text,
                                      password: passController.text)
                                  .then((signInUser) {
                                firestore
                                    .collection("users")
                                    .doc(signInUser.user!.uid)
                                    .set({
                                  "name": nameController.text,
                                  "email": emailController.text
                                }).then((value) {
                                  Navigator.pushReplacementNamed(context, "/");
                                }).onError((error, stackTrace) {
                                  setState(() {
                                    isSigning = false;
                                  });
                                });
                              });
                            }
                          } catch (e) {
                            debugPrint("Some Error Occurred");
                            debugPrint(e.toString());
                          }
                        }),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              isSigning
                  ? const CircularProgressIndicator(
                      color: Colors.purple,
                    )
                  : Container(),
              const SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Already Have an Account?",
                    style: TextStyle(fontSize: 14),
                  ),
                  const SizedBox(width: 10),
                  InkWell(
                    onTap: () {
                      Navigator.pushNamed(context, "/login");
                    },
                    child: const Text(
                      "Login",
                      style: TextStyle(color: Colors.purple, fontSize: 14),
                    ),
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
