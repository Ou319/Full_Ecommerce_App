import 'package:flutter/material.dart';

class Button extends StatefulWidget {
  final String textInput;
  final Color colorBg;
  bool isBorder=false;
   Button({required this.isBorder,required this.textInput,required this.colorBg,super.key});

  @override
  State<Button> createState() => _ButtonState();
}

class _ButtonState extends State<Button> {
  
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric( horizontal: 30),
      width: double.infinity,
      height: 70,
      decoration: BoxDecoration(
        color: widget.colorBg,
        borderRadius: BorderRadius.circular(10),
        border:widget.isBorder? Border.all(color: Colors.black,width: 1):Border.all(color: Colors.transparent,width: 0),
      ),
      child: Center(
        child: Text(
          
         widget.textInput,
      
          style: TextStyle(color:widget.isBorder?Colors.black: Colors.white, fontSize: 20),
        ),
      ),
    );
  }
}