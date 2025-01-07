import 'package:ecomme_app/view/provider/Buyproductes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Producteselected extends StatefulWidget {
  const Producteselected({super.key});

  @override
  State<Producteselected> createState() => _ProducteselectedState();
}

class _ProducteselectedState extends State<Producteselected> {
  @override
  Widget build(BuildContext context) {
    final classInstancee = Provider.of<Buyproductes>(context);
    return Scaffold(body: ListView.builder(
      itemCount: classInstancee.ProducteSelected.length,
      itemBuilder: (context, index) {
        final F_item=classInstancee.ProducteSelected[index];
        return ListTile(
          title: Text(F_item.Type),
          subtitle: Text(F_item.Title.toString()),
          onTap: () {
            // TODO: Navigate to product details page
          },
        );
        
      }
      )
      );
  }
}
