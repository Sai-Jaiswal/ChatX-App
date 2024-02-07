import 'package:flutter/material.dart';

class ArchivedPage extends StatelessWidget {
  const ArchivedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const ClampingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Container(
            height: 130,
            padding:  const EdgeInsets.only(bottom: 30, top: 50, left: 20, right: 20),
            decoration:  const BoxDecoration(
                gradient: LinearGradient(
                    colors: [
                      Color.fromRGBO(144, 24, 209, 1),
                      Color.fromRGBO(214, 12, 187, 1)
                    ],
                    begin: Alignment.centerLeft, //begin of the gradient color
                    end: Alignment.centerRight, //end of the gradient color
                    stops: [0, 1]
                )
            ),
            child: Center(
              child: Container(
                padding:  EdgeInsets.symmetric(horizontal: 16, ),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white, width: 2),
                  borderRadius: BorderRadius.circular(50),
                ),
                child:  const TextField(
                  cursorColor: Colors.white,
                  style: TextStyle(fontSize: 15, color: Colors.white),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "Search",
                    hintStyle: TextStyle(
                        color: Colors.white
                    ),
                    suffixIcon: Icon(Icons.search, color: Colors.white,),
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(height: 25,),

          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Archived Messages", style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700),),
                SizedBox(height: 10,),
                Text("No Archived Messages", style: TextStyle(fontSize: 14, color: Color.fromARGB(255, 144, 144, 144)),)
              ],
            ),
          ),

          ListView.builder(
            itemCount: 0,
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return InkWell(
                onTap: (){
                  Navigator.pushNamed(context, "/chatting_screen");
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: const ListTile(
                    leading: CircleAvatar(
                      radius: 30,
                      backgroundImage: NetworkImage("https://source.unsplash.com/100x100?person, face"),
                    ),

                    title: Text(
                      "Joe Dude",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text("Hello! How are you", style: TextStyle(fontSize: 18),),
                    trailing: Text("Now", style: TextStyle(color: Colors.grey),),
                  ),
                ),
              );
            },
          )

        ],
      ),
    );
  }
}
