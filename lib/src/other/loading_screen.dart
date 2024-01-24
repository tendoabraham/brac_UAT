import 'package:craft_dynamic/craft_dynamic.dart';
import 'package:flutter/material.dart';
import 'common_widget.dart';

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.3,
                ),
                Image.asset(
                  'assets/images/brac.png',
                  height: 100,
                  width: 100,
                ),
                // const SizedBox(
                //   height: 10,
                // ),
                // LoadUtil(),
                const SizedBox(
                  height: 12,
                  child: CircularProgressIndicator(
                    color: Color.fromRGBO(225, 0, 134, 1),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
              ],
            ),
            Padding(padding: EdgeInsets.symmetric(horizontal: 20),
            child:             Row(
              children: [
                Image.asset(
                    'assets/images/flag7.jpg',
                    height: 30,
                    width: 30,
                  ),
                Spacer(),
                  Image.asset(
                    'assets/images/cs.png',
                    height: 100,
                    width: 150,
                  ),
              ],
            ),)
          ],
        ),
      ),
    );
  }
}
