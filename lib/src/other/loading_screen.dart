import 'package:flutter/material.dart';
import 'common_widget.dart';

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    body: Center(
      child: Column(
        children: [
          const SizedBox(
            height: 170,
          ),
          Image.asset('assets/images/brac.png',
            height: 100,
            width: 100,),
          const SizedBox(
            height: 10,
          ),
          const SizedBox(
            height: 12,
            child: CircularProgressIndicator(
              color: Color.fromRGBO(225, 0, 134, 1),
            ),
          ),
          const SizedBox(
            height: 220,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Image.asset('assets/images/cs_logo_powered.png',
                height: 100,
                width: 100,),
            ],
          )
        ],
      ),
    )
  );
}
