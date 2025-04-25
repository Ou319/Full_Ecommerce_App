import 'package:ecomme_app/app/app.dart';
import 'package:ecomme_app/app/constant.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await Supabase.initialize(
    url: Appconstant.supabaseUrl,
    anonKey: Appconstant.supabaseKey,
  );
  
  runApp(const MyAPP());
}