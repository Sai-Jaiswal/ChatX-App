// import 'package:chatx/screens/homepage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class GroupMsgInfo extends StatefulWidget {
  const GroupMsgInfo({super.key});

  @override
  State<GroupMsgInfo> createState() => _GroupMsgInfoState();
}

class _GroupMsgInfoState extends State<GroupMsgInfo> {
  FirebaseFirestore databaseStore = FirebaseFirestore.instance;

  String? groupId;
  String? groupName;
  String? groupDesc;

  @override
  void didChangeDependencies() {
    Map data = Get.arguments;
    setState(() {
      groupId = data["group id"];
      groupName = data["group name"];
      groupDesc = data["group desc"];
    });
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.only(right: 20, left: 20, top: 20),
            width: double.infinity,
            child: Column(
              children: [
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.deepPurple, width: 2),
                      image: const DecorationImage(
                        image: AssetImage("assets/images/group_logo.png"),
                      ),
                      borderRadius: BorderRadius.circular(100)),
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  groupName.toString(),
                  style: const TextStyle(
                      fontSize: 25, fontWeight: FontWeight.w600),
                ),
                const SizedBox(
                  height: 30,
                ),
                SizedBox(
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Description",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            groupDesc.toString(),
                            style: const TextStyle(
                              fontSize: 17,
                            ),
                          ),
                          const Icon(Icons.edit)
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                Container(
                  padding: const EdgeInsets.all(10),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: const Color.fromRGBO(240, 240, 240, 1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Participants",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      ListView.builder(
                        itemCount: 3,
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return Container(
                            margin: const EdgeInsets.symmetric(vertical: 5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Row(
                                  children: [
                                    CircleAvatar(
                                      radius: 20,
                                      backgroundImage: AssetImage(
                                          "assets/images/account_img.png"),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      "Sai",
                                      style: TextStyle(fontSize: 23),
                                    ),
                                  ],
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 5, vertical: 2),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.purple, width: 2),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: const Text("Admin"),
                                )
                              ],
                            ),
                          );
                        },
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                GestureDetector(
                  onTap: () async {
                    // QuerySnapshot snapshot = await databaseStore.collection("groups").doc(groupId).collection("messages").get();
                    // print(snapshot.docs);
                    // databaseStore.collection("groups").doc(groupId).delete().then((value){
                    //   Get.offAll(() => Homepage());
                    // });
                  },
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.delete,
                        color: Colors.red,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        "Delete Group",
                        style: TextStyle(color: Colors.red, fontSize: 18),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
