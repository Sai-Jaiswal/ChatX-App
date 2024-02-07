import 'package:flutter/material.dart';

class SearchBar extends StatelessWidget {
  const SearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
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
    );
  }
}
