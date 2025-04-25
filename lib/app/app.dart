import 'package:ecomme_app/app/provider/Buyproductes.dart';
import 'package:ecomme_app/presentation/ressourses/routesmanaget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyAPP extends StatefulWidget {
  const MyAPP({super.key});

  @override
  State<MyAPP> createState() => _MyAPPState();
}

class _MyAPPState extends State<MyAPP> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => Buyproductes(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        onGenerateRoute: Routganarator.getRoute,
        initialRoute: Routes.splaschRoutes,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          fontFamily: "Montserrat",
        ),
      ),
    );
  }
}