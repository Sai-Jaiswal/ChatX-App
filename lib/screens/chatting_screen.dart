import 'dart:async';
import 'package:get/get.dart';

import 'package:chatx/screens/group_message_info.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChattingScreen extends StatefulWidget {
  const ChattingScreen({super.key});

  @override
  State<ChattingScreen> createState() => _ChattingScreenState();
}

class _ChattingScreenState extends State<ChattingScreen> {
  // Firebase Variables
  FirebaseAuth auth = FirebaseAuth.instance;

  // Int Variables
  double inputHeight = 70;

  // Checking Variables
  bool timerClose = false;
  bool isSearchVisible = false;

  // Main Variables
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _sendInputController = TextEditingController();
  ScrollController scrollController = ScrollController();

  String? groupId;
  String? groupName;
  String? groupDesc;

  void fetchRouteData() {
    Map data = ModalRoute.of(context)!.settings.arguments as Map;
    setState(() {
      groupId = data["group id"];
      groupName = data["group name"];
      groupDesc = data["group desc"];
    });
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    fetchRouteData();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      scrollController.animateTo(scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 10),
          curve: Curves.fastOutSlowIn);
    });
  }

  @override
  Widget build(BuildContext context) {
    var firestore = FirebaseFirestore.instance
        .collection("groups")
        .doc(groupName.toString());

    return WillPopScope(
      onWillPop: () async {
        setState(() {
          timerClose = true;
        });
        return true;
      },
      child: Scaffold(
        appBar: chatAppBar(context),
        body: Column(
          children: [
            Stack(
              children: [
                Visibility(
                  visible: isSearchVisible,
                  child: TextField(
                    controller: _searchController,
                    textInputAction: TextInputAction.search,
                    cursorColor: Colors.grey,
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey)),
                      focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Color.fromARGB(255, 62, 62, 62))),
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            _searchController.clear();
                          });
                        },
                        icon: const Icon(
                          Icons.clear,
                          color: Colors.grey,
                        ),
                      ),
                      hintText: "Search",
                    ),
                    style: const TextStyle(fontSize: 14),
                  ),
                )
              ],
            ),
            Expanded(
              child: StreamBuilder(
                  stream: firestore.collection("messages").snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      debugPrint("Some Error Occured");
                    }

                    return ListView.builder(
                      controller: scrollController,
                      physics: const BouncingScrollPhysics(),
                      itemCount: snapshot.data?.docs.length ?? 0,
                      itemBuilder: (context, index) {
                        bool isAuthCheck = auth.currentUser!.email ==
                            snapshot.data!.docs[index]["email"];
                        return Container(
                          margin: EdgeInsets.only(
                              top: 10,
                              bottom: 10,
                              left: isAuthCheck ? 20 : 5,
                              right: isAuthCheck ? 5 : 20),
                          // padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            color: const Color(0xFF8202A5),
                            borderRadius: BorderRadius.only(
                                topLeft: const Radius.circular(10),
                                topRight: const Radius.circular(10),
                                bottomLeft: isAuthCheck
                                    ? const Radius.circular(10)
                                    : const Radius.circular(0),
                                bottomRight: isAuthCheck
                                    ? const Radius.circular(0)
                                    : const Radius.circular(10)),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 5),
                                decoration: const BoxDecoration(
                                    color: Color(0xFF5C0079),
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(10),
                                        topRight: Radius.circular(10))),
                                width: double.infinity,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      snapshot.data!.docs[index]["name"]
                                          .toString(),
                                      style: const TextStyle(
                                        fontSize: 16,
                                        color: Color(0xFFCDD3F6),
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    const Text(
                                      "2:30 PM",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 14),
                                    )
                                  ],
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 5),
                                child: Text(
                                  snapshot.data!.docs[index]["message"]
                                      .toString(),
                                  style: const TextStyle(
                                      fontSize: 16, color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  }),
            ),
          ],
        ),
        bottomNavigationBar: customBottomBar(context),
      ),
    );
  }

  AppBar chatAppBar(context) {
    return AppBar(
        elevation: 1.8,
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                if (isSearchVisible) {
                  isSearchVisible = false;
                } else {
                  isSearchVisible = true;
                }
              });
            },
            icon: const Icon(
              Icons.search,
              size: 28,
            ),
          ),
        ],
        iconTheme: const IconThemeData(color: Colors.grey),
        leading: IconButton(
          onPressed: () {
            setState(() {
              timerClose = true;
            });
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios_new),
        ),
        backgroundColor: Colors.white,
        toolbarHeight: 80,
        title: InkWell(
          highlightColor: Colors.transparent,
          splashColor: Colors.transparent,
          onTap: () {
            Get.to(() => const GroupMsgInfo(),
                transition: Transition.downToUp,
                arguments: {
                  "group id": groupId,
                  "group name": groupName,
                  "group desc": groupDesc,
                });
          },
          child: Row(children: [
            const CircleAvatar(
              backgroundColor: Colors.white,
              radius: 25,
              backgroundImage: AssetImage("assets/images/group_logo.png"),
            ),
            const SizedBox(
              width: 20,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  groupName.toString(),
                  style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Colors.black),
                ),
                const Text(
                  "Click here to get info",
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                )
              ],
            ),
          ]),
        ));
  }

  BottomAppBar customBottomBar(context) {
    return BottomAppBar(
      child: Container(
        alignment: Alignment.topCenter,
        height: inputHeight == 70 ? 70 : inputHeight + 70,
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                  color: Colors.purple, borderRadius: BorderRadius.circular(7)),
              child: Transform.rotate(
                  angle: 10,
                  child: const Icon(
                    Icons.attach_file,
                    size: 18,
                    color: Colors.white,
                  )),
            ),
            const SizedBox(
              width: 20,
            ),
            Expanded(
              child: InkWell(
                child: TextField(
                  controller: _sendInputController,
                  keyboardType: TextInputType.multiline,
                  onTap: () {
                    Timer.periodic(const Duration(milliseconds: 5), (timer) {
                      setState(() {
                        inputHeight = MediaQuery.of(context).viewInsets.bottom;
                        if (timerClose) {
                          timer.cancel();
                        }
                      });
                    });
                  },
                  // autofocus: true,
                  cursorColor: Colors.grey,
                  decoration: const InputDecoration(
                    hintText: "Type...",
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            IconButton(
                onPressed: () async {
                  DateTime dateTimeNow = DateTime.now();
                  try {
                    if (_sendInputController.text != "") {
                      String docId =
                          DateTime.now().millisecondsSinceEpoch.toString();
                      var userStorage = await FirebaseFirestore.instance
                          .collection("users")
                          .doc(auth.currentUser!.uid)
                          .get();
                      Map userData = userStorage.data() as Map;
                      String name = userData["name"];
                      await FirebaseFirestore.instance
                          .collection("groups")
                          .doc(groupName.toString())
                          .collection("messages")
                          .doc(docId)
                          .set({
                        "message": _sendInputController.text,
                        "time":
                            "${dateTimeNow.hour.toString()} :${dateTimeNow.minute.toString()}",
                        "email": auth.currentUser!.email,
                        "name": name,
                      }).then((value) {
                        _sendInputController.clear();
                        scrollController.animateTo(
                            scrollController.position.maxScrollExtent,
                            duration: const Duration(milliseconds: 10),
                            curve: Curves.fastOutSlowIn);
                      });
                    }
                  } catch (e) {
                    debugPrint("Something went wrong");
                  }
                },
                icon: const Icon(
                  Icons.send,
                  color: Colors.purple,
                  size: 26,
                ))
          ],
        ),
      ),
    );
  }
}
