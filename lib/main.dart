import 'package:ecomme_app/view/provider/Buyproductes.dart';
import 'package:ecomme_app/view/commePage/firstpageComme.dart';
import 'package:ecomme_app/view/homePages/constant/naviagationBottombar/naviagationBottombar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
void main() async{
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url:'https://oyglixysyaunesjgrogx.supabase.co' ,
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im95Z2xpeHlzeWF1bmVzamdyb2d4Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzU0MjY5OTAsImV4cCI6MjA1MTAwMjk5MH0.d01CCa9s8YBkqFOz0AtJtt5E4B3HSFUWVB6VNZ0WE8s',
  );
  
  
  runApp(const MyApp());
}
 
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
 
  @override
  Widget build(BuildContext context) {
    // 
    return ChangeNotifierProvider(
      create: (context) {return Buyproductes();},
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData.light(useMaterial3: true),
        home: Naviagationbottombar(),
        // home: FisrtPageComme(),
      ),
    );
  }
}