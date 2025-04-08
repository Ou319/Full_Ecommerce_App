

// import 'package:ecomme_app/view/authpages/loginPages/interface/button/button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


// this for title
TextStyle getstyleTitle( double fontSize, FontWeight fontWeight, Color color) {
  return GoogleFonts.inder(
    fontSize: fontSize,
    fontWeight: fontWeight,
    color: color,
  );
}


// this for suptitle
TextStyle getTextStylesubetitle(double fontSize, FontWeight fontWeight, Color color) {
  return GoogleFonts.montserrat(
    fontSize: fontSize,
    fontWeight: fontWeight,
    color: color,
  );
}
// this for long text
TextStyle getTextStylelongtext(double fontSize, FontWeight fontWeight, Color color) {
  return GoogleFonts.siemreap(
    fontSize: fontSize,
    fontWeight: fontWeight,
    color: color,
  );
}

Container getstyleButton(
  String text,
  Color color,
  Color textColor,
  double fontSize,
  FontWeight fontWeight,
  double borderRadius,
  double height,
  double width,
  bool isBorder,
  String textInput,
  Color colorBg,
    VoidCallback onPressed,
) 
{
  return Container(
    height: height,
    width: width,
    decoration: BoxDecoration(
      color: colorBg,
      borderRadius: BorderRadius.circular(borderRadius),
      border: isBorder ? Border.all(color: color) : null,
    ),
    child: Center(
      child: TextButton(
        onPressed: () => onPressed(),


        child: Text(
          textInput,
          style: getstyleTitle( fontSize, fontWeight, textColor),
        ),
      ),
    ),
  );
}