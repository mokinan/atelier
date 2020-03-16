import 'dart:io' show Platform;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'blocs/bloc.dart';
import 'dart:async';
import 'blocs/design.dart';
import 'package:easy_localization/easy_localization.dart';

void main() {

  runApp(EasyLocalization(child: Atelier()));

}

class Atelier extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var data = EasyLocalizationProvider.of(context).data;
    return EasyLocalizationProvider(
      data: data,
      child: MaterialApp(
        theme: ThemeData(
          accentColor: blackAccent,
          primaryColor: bumbi,
          backgroundColor: backGround,
          buttonColor: bumbi,
          hintColor: hint,
          fontFamily: 'Tajawal',
        ),
        supportedLocales: [Locale("ar", "SA"), Locale("en", "US")],
        locale: data.savedLocale,
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
          EasylocaLizationDelegate(locale: data.locale, path: 'assets/lang')
        ],
        home: Open(),
        title: 'Atelier',
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

class Open extends StatefulWidget {
  @override
  _OpenState createState() => _OpenState();
}

class _OpenState extends State<Open> {
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  setUserData() async {}
///////////////////////////////////////////////////////////////////
  Future _fcm_listener() async {
    ///
    if (Platform.isIOS) ios_permission();

    ///
    await _firebaseMessaging.getToken().then((token) {
      ///
      bloc.setDeviceType(Platform.operatingSystem);

      ///
      bloc.setDeviceToken(token);

      ///
    });

    ///
    _firebaseMessaging.configure(

        ///
        onMessage: (Map<String, dynamic> message) async {
      ///
      print('on message $message');

      ///
    }, onResume: (Map<String, dynamic> message) async {
      ///
      print('on Resume $message');

      ///
    }, onLaunch: (Map<String, dynamic> message) async {
      ///
      print('on Launch $message');

      ///
    });

    ///
  }

  ///
  ///
  void ios_permission() {
    ///
    _firebaseMessaging.requestNotificationPermissions(///////////
        IosNotificationSettings(sound: true, badge: true, alert: true));

    ///
    _firebaseMessaging.onIosSettingsRegistered

        ///
        .listen((IosNotificationSettings settings) {
      ///
      print("Settings registered: $settings");

      ///
    });

    ///
  }

  ///
  /////////////////////////////////////////////////////////////////////////

  @override
  void initState() {
    _fcm_listener();
    chooseScreen(context);
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    bloc.setDeviceSize(Size(width, height));
    return Scaffold(
        body: Container(
      width: width,
      height: height,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            color: backGround,
            width: 100,
            height: 100,
            child: Image.asset('assets/images/logo.png'),
          ),
          Padding(
            padding: EdgeInsets.only(top: 10),
            child: Theme(
                data: ThemeData(accentColor: bumbi),
                child: CircularProgressIndicator()),
          )
        ],
      ),
    ));
  }
}

