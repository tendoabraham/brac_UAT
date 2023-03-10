import 'package:brac_mobile/src/home/dashboard_screen.dart';
import 'package:brac_mobile/src/other/app_state.dart';
import 'package:brac_mobile/src/other/loading_screen.dart';
import 'package:brac_mobile/src/theme/app_theme.dart';
import 'package:craft_dynamic/craft_dynamic.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations(
    [DeviceOrientation.portraitUp],
  );
  await DeviceInfo.performDeviceSecurityScan();
  runApp(ChangeNotifierProvider(
      create: (context) => AppState(),
    child: DynamicCraftWrapper(dashboard: Dashboard(),
        appLoadingScreen: LoadingScreen(),
        appTimeoutScreen: Dashboard(),
        appInactivityScreen: Dashboard(),
        appTheme: AppTheme().appTheme,),
  ));
}
