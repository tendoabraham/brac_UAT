import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class BaseScreen extends StatelessWidget {
  final Widget child;
  final AppBar? appBar;

  const BaseScreen({super.key, required this.child, this.appBar});

  @override
  Widget build(BuildContext context) => AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(statusBarColor: Color.fromRGBO(225, 0, 134, 0.7)),
      child: Scaffold(appBar: appBar, body: SafeArea(child: child)));
}
