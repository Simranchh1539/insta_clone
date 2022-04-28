import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:instagramclone/providers/theme_provider.dart';
import 'package:instagramclone/providers/user_provider.dart';
import 'package:instagramclone/responsive/mobile_screen.dart';
import 'package:instagramclone/responsive/responsive.dart';
import 'package:instagramclone/responsive/web_screen.dart';
import 'package:instagramclone/screens/log_in.dart';
import 'package:instagramclone/utils/colors.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
      options: FirebaseOptions(
          apiKey: 'AIzaSyBN8PpTaG-FDrtX3T0nxu-Gbiy_CGOoe08',
          appId: '1:501207459834:web:050e48bc3ce206d3b5e643',
          messagingSenderId: '501207459834',
          projectId: 'instagram-e3ef5',
          storageBucket: 'instagram-e3ef5.appspot.com'),
    );
  } else {
    await Firebase.initializeApp();
  }
  SharedPreferences.getInstance().then((prefs) {
    var darkModeOn = prefs.getBool('darkMode') ?? false;

    //Set Navigation bar color

    runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => UserProvider()),
          ChangeNotifierProvider<ThemeNotifier>(
              create: (context) =>
                  ThemeNotifier(darkModeOn ? darkTheme : lightTheme))
        ],
        child: MyApp(),
      ),
    );
  });
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  Widget _getScreenId() {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          if (snapshot.hasData) {
            return ResponsiveFeature(
              mobileScreenDesign: MobileScreen(),
              webScreenDesign: WebScreen(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('${snapshot.error}'),
            );
          }
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.white,
            ),
          );
        }

        return LogIn();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    return MaterialApp(
      title: 'Instagram',
      debugShowCheckedModeBanner: false,
      theme: themeNotifier.getTheme(),
      home: _getScreenId(),
    );
  }
}
