import 'package:chatx/widgets/rounded_button.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  late String name;
  late String email;
  bool isFetched = false;
  bool switchValue = false;

  void fetchData() async {
    await firestore
        .collection("users")
        .doc(auth.currentUser!.uid)
        .get()
        .then((value) {
      if (auth.currentUser != null) {
        var userData = value.data() as Map;
        setState(() {
          name = userData["name"];
          email = userData["email"];
          isFetched = true;
        });
      }
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
      body: isFetched
          ? SafeArea(
              child: Container(
                margin: const EdgeInsets.only(top: 20),
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    const Text(
                      "Settings",
                      style:
                          TextStyle(fontSize: 25, fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Image.asset("assets/images/account_img.png",
                              width: 120),
                          const SizedBox(
                            height: 20,
                          ),
                          Column(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    name,
                                    style: const TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  Text(email,
                                      style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                          color:
                                              Color.fromRGBO(88, 88, 88, 1.0))),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      RoundedButton(
                                          title: "Edit Profile",
                                          size: 16,
                                          buttonFunc: () {
                                            Navigator.pushNamed(
                                                context, "/edit_profile");
                                          }),
                                      const SizedBox(
                                        width: 25,
                                      ),
                                      IconButton(
                                          onPressed: () {
                                            auth.signOut().then((value) {
                                              Navigator.pushNamedAndRemoveUntil(
                                                  context,
                                                  "/login",
                                                  (route) => false);
                                            });
                                          },
                                          icon: const Icon(
                                            Icons.logout,
                                            color: Colors.purple,
                                          ))
                                    ],
                                  )
                                ],
                              ),
                            ],
                          )
                        ]),
                    const SizedBox(
                      height: 30,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      margin: const EdgeInsets.symmetric(horizontal: 10),
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: const Color.fromRGBO(241, 241, 241, 1.0),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Options",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w500),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Container(
                            margin: const EdgeInsets.symmetric(vertical: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  "Notifications",
                                  style: TextStyle(
                                      fontSize: 15,
                                      color: Color.fromRGBO(91, 91, 91, 1)),
                                ),
                                Switch(
                                  value: switchValue,
                                  onChanged: (value) {
                                    if (value) {
                                      setState(() {
                                        switchValue = true;
                                      });
                                    } else {
                                      setState(() {
                                        switchValue = false;
                                      });
                                    }
                                  },
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            )
          : const Center(
              child: CircularProgressIndicator(color: Colors.purple),
            ),
    );
  }
}
