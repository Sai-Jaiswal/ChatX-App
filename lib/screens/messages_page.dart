import 'package:chatx/widgets/rounded_button.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MessagePage extends StatefulWidget {
  const MessagePage({Key? key}) : super(key: key);

  @override
  State<MessagePage> createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage> {
  FirebaseFirestore databaseStore = FirebaseFirestore.instance;
  var firestore = FirebaseFirestore.instance.collection("groups").snapshots();
  FirebaseAuth auth = FirebaseAuth.instance;

  TextEditingController groupNameController = TextEditingController();
  TextEditingController groupDescController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const ClampingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 130,
            padding:
                const EdgeInsets.only(bottom: 30, top: 50, left: 20, right: 20),
            decoration: const BoxDecoration(
                gradient: LinearGradient(
                    colors: [
                      Color.fromRGBO(144, 24, 209, 1),
                      Color.fromRGBO(214, 12, 187, 1)
                    ],
                    begin: Alignment.centerLeft, //begin of the gradient color
                    end: Alignment.centerRight, //end of the gradient color
                    stops: [0, 1])),
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                ),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white, width: 2),
                  borderRadius: BorderRadius.circular(50),
                ),
                child: const TextField(
                  cursorColor: Colors.white,
                  textInputAction: TextInputAction.search,
                  style: TextStyle(fontSize: 15, color: Colors.white),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "Search",
                    hintStyle: TextStyle(color: Colors.white),
                    suffixIcon: Icon(
                      Icons.search,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 25),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Messages",
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    // Text("You have 2 new messages", style: TextStyle(fontSize: 14, color: Color.fromARGB(255, 144, 144, 144)),)
                  ],
                ),
                InkWell(
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (index) {
                          return Dialog(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            child: Container(
                              height: 350,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 20,
                              ),
                              child: Column(
                                children: [
                                  const Text(
                                    "Create Group",
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  const SizedBox(
                                    height: 25,
                                  ),
                                  TextField(
                                    controller: groupNameController,
                                    maxLength: 15,
                                    decoration: const InputDecoration(
                                      border: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10))),
                                      focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10)),
                                          borderSide: BorderSide(
                                              color: Color(0xFF434343))),
                                      hintText: "Group name",
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  TextField(
                                    controller: groupDescController,
                                    maxLength: 40,
                                    decoration: const InputDecoration(
                                      border: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10))),
                                      focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10)),
                                          borderSide: BorderSide(
                                              color: Color(0xFF434343))),
                                      hintText: "Description",
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  RoundedButton(
                                      title: "Create",
                                      size: 17,
                                      buttonFunc: () async {
                                        if (groupNameController.text != "") {
                                          String groupName = groupNameController
                                                  .text[0]
                                                  .toUpperCase() +
                                              groupNameController.text
                                                  .substring(
                                                      1,
                                                      groupNameController
                                                          .text.length);

                                          String groupId = DateTime.now()
                                              .millisecondsSinceEpoch
                                              .toString();
                                          await databaseStore
                                              .collection("groups")
                                              .doc(groupId)
                                              .set({
                                            "group id": groupId,
                                            "group name": groupName,
                                            "group desc":
                                                groupDescController.text,
                                            "created by":
                                                auth.currentUser!.email,
                                          }).then((value) {
                                            Navigator.pop(context);
                                            groupNameController.clear();
                                            groupDescController.clear();
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(const SnackBar(
                                              content: Text(
                                                  "Group Created Successfully"),
                                              backgroundColor: Colors.purple,
                                              shape: RoundedRectangleBorder(),
                                              duration: Duration(seconds: 1),
                                            ));
                                          });
                                        }
                                      })
                                ],
                              ),
                            ),
                          );
                        });
                  },
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.purple,
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: const Icon(
                      Icons.add,
                      size: 20,
                      color: Colors.white,
                    ),
                  ),
                )
              ],
            ),
          ),
          StreamBuilder(
              stream: firestore,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: Colors.purple,
                    ),
                  );
                }

                if (snapshot.hasError) {
                  debugPrint("Some Error Occured");
                }

                return ListView.builder(
                  itemCount: snapshot.data?.docs.length ?? 0,
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        // String groupId =
                        // snapshot.data!.docs[index]["group id"].toString();
                        String groupName =
                            snapshot.data!.docs[index]["group name"].toString();
                        String groupDesc =
                            snapshot.data!.docs[index]["group desc"].toString();
                        Navigator.pushNamed(context, "/chatting_screen",
                            arguments: {
                              // "group id": groupId,
                              "group name": groupName,
                              "group desc": groupDesc != ""
                                  ? groupDesc
                                  : "Add group Description",
                            });
                      },
                      onLongPress: () {},
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: ListTile(
                          leading: const CircleAvatar(
                            backgroundColor: Colors.white,
                            radius: 30,
                            backgroundImage:
                                AssetImage("assets/images/group_logo.png"),
                          ),
                          title: Text(
                            snapshot.data!.docs[index]["group name"].toString(),
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: const Text(
                            "",
                            style: TextStyle(fontSize: 18),
                          ),
                          trailing: const Text(
                            "Now",
                            style: TextStyle(color: Colors.grey),
                          ),
                        ),
                      ),
                    );
                  },
                );
              }),
        ],
      ),
    );
  }
}
