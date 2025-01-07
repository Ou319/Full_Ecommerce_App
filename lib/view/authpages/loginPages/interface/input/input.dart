import 'package:flutter/material.dart';

class InputAuth extends StatefulWidget {
  final String TextInput;
  final TextEditingController controllerName;
  final Icon iconInput;
  final bool isKayn;
  const InputAuth({ this.isKayn=false,required this.controllerName,required this.TextInput,required this.iconInput,super.key});

  @override
  State<InputAuth> createState() => _InputAuthState();
}

class _InputAuthState extends State<InputAuth> {
  
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 75,
      width:widget.isKayn? MediaQuery.of(context).size.width /2:MediaQuery.of(context).size.width,
      padding:widget.isKayn?EdgeInsets.only(right: 30, left: 30): EdgeInsets.only(right: 30, left: 30),
      child: TextField(
        controller:widget.controllerName,

        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(vertical: 25, horizontal: 10),
          label: Text(widget.TextInput),
          hintStyle: TextStyle(color: Colors.grey),
          prefixIcon: widget.iconInput,
          enabledBorder: OutlineInputBorder(
            
            borderSide: const BorderSide(color: Colors.grey),
            borderRadius: BorderRadius.circular(10),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
            borderSide: BorderSide(color: Colors.black),
          ),
        ),
      ),
    );
  }
}
