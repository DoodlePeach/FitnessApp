import 'package:flutter/material.dart';

// Style for inner element text that needs to be de-emphasised.
// e.g you would want to de-emphasise a description in contrast to a title.
TextStyle smallElementTextStyle = TextStyle(
    fontSize: 14,
    fontFamily: 'Roboto',
    fontWeight: FontWeight.w300,
    color: Colors.black);

// Same as smallElementTextStyle, but for emphasising titles and others.
TextStyle bigElementTextStyle = TextStyle(
    fontSize: 16,
    fontFamily: 'Roboto',
    fontWeight: FontWeight.w400,
    color: Colors.black);

// Text style of titles of the cards
TextStyle cardTitleTextStyle = TextStyle(
    fontSize: 18,
    fontFamily: 'Roboto',
    fontWeight: FontWeight.w400,
    color: Colors.black
);

//
TextStyle foodBarTextStyle = TextStyle(
fontSize: 17,
fontFamily: 'Roboto',
fontWeight: FontWeight.w300,
color: Colors.white);



// Specification for gradient of food list items.
// This gradient is applied when the item is selected.
BoxDecoration listElementGradient = BoxDecoration(
    gradient: LinearGradient(
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
        colors: [const Color(0xff74F2CE), const Color(0xff7CFFCB)]));
