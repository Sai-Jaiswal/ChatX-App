import 'package:chatx/widgets/rounded_button.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditProfile extends StatefulWidget {

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  FirebaseAuth auth = FirebaseAuth.instance;

  FirebaseFirestore databaseStore = FirebaseFirestore.instance;

  final TextEditingController nameController = TextEditingController();

  final TextEditingController emailController = TextEditingController();

  final TextEditingController locationController = TextEditingController();

  Future<void> fetchData() async{
    await databaseStore.collection("users").doc(auth.currentUser!.uid).get().then((value){
      Map userData = value.data() as Map;
      setState(() {
        nameController.text = userData["name"];
        emailController.text = userData["email"];
        locationController.text = userData["location"];
      });
    });
  }

  @override
  void initState() {
    fetchData();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: Icon(Icons.arrow_back_outlined, size: 28,),
                    ),
                    Text("Edit Profile", style: TextStyle(fontSize: 25, fontWeight: FontWeight.w600),),
                    SizedBox(width: 40,)
                  ],
                ),

                SizedBox(height: 20,),

                Image.asset("assets/images/account_img.png", width: 150,),

                SizedBox(height: 20,),

                Container(
                  child: Column(
                    children: [
                      TextField(
                        controller: nameController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.black)),
                          focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.black)),
                          labelText: "Name",
                          labelStyle: TextStyle(
                            color: Colors.black
                          )
                        ),
                      ),

                      SizedBox(height: 20,),

                      TextField(
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.black)),
                            focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.black)),
                            labelText: "Email",
                            labelStyle: TextStyle(
                                color: Colors.black
                            )
                        ),
                      ),

                      SizedBox(height: 20,),

                      TextField(
                        controller: locationController,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.black)),
                            focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.black)),
                            labelText: "Location",
                            labelStyle: TextStyle(
                                color: Colors.black
                            )
                        ),
                      ),

                      SizedBox(height: 30,),

                      RoundedButton(title: "Update", size: 16, buttonFunc: () {
                        databaseStore.collection("users").doc(auth.currentUser!.uid).update({
                          "name": nameController.text,
                          "email": emailController.text,
                          "location": locationController.text
                        }).then((value){
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Profile Updated Successfully"),
                                backgroundColor: Colors.purple,
                                shape: RoundedRectangleBorder(),
                                duration: Duration(seconds: 1),
                              )
                          );
                        });
                      })

                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      )
    );
  }
}
