import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'inote_view.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    Future.delayed(const Duration(seconds: 1)).then((value) =>
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => InoteView())));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            SizedBox(
              height: 100,
              width: double.infinity,
              child: Image(image: AssetImage('lib/assets/images/icon.png')),
            ), // Assets.images.logo.image(height: 64, width: double.infinity),
            SpinKitThreeBounce(
              color: Colors.cyan,
              size: 30.0,
            )
          ],
        ),
      ),
    );
  }
}
