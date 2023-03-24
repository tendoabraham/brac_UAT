import 'package:flutter/material.dart';

class AccountCardLoad extends StatelessWidget{
  const AccountCardLoad({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Card(
        shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
    //set border radius more than 50% of height and width to make circle
    ),
    elevation: 5,
    shadowColor: Colors.black,
    child: const SizedBox(
      height: 210,
      width: 350,
    ),
    ));
  }

}