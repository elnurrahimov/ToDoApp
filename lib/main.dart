import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:todoapp/pages/home_page.dart';

void main(){
  runApp(MyToDo());
}

class MyToDo extends StatelessWidget {
  const MyToDo({super.key});

  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      home:  HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

