import 'package:atelier/blocs/bloc.dart';
import 'package:atelier/blocs/design.dart';
import 'package:atelier/models/userModel.dart';
import 'package:atelier/screens/home/AtelierProviderCenter.dart';
import 'package:atelier/screens/login&signUp/login.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:atelier/blocs/widgets.dart';

class PayPAckage extends StatefulWidget {
  @override
  _PayPAckageState createState() => _PayPAckageState();
}

class _PayPAckageState extends State<PayPAckage> {
  bool validate = false;
  final emailNode = new FocusNode();
  final passwordNode = new FocusNode();
  GlobalKey<ScaffoldState> scaffold = GlobalKey();
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double safe = MediaQuery.of(context).padding.top;
    bloc.setDeviceSize(Size(size.width, size.height - safe));

    var data = EasyLocalizationProvider.of(context).data;
    String localCode = Localizations.localeOf(context).languageCode.toString();
    return EasyLocalizationProvider(
      data: data,
      child: WillPopScope(
          onWillPop: () {
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => Login()));
            return Future.value(false);
          },
          child: SafeArea(
            child: Scaffold(
              key: scaffold,
              body: GestureDetector(
                onTap: () {
                  FocusScope.of(context).requestFocus(FocusNode());
                },
                child: Container(
                    width: size.width,
                    height: size.height,
                    child: Stack(
                      alignment: Alignment.topRight,
                      children: <Widget>[
                        SingleChildScrollView(
                          physics: BouncingScrollPhysics(),
                          child: Container(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Container(
                                  width: bloc.size().width,
                                  margin: EdgeInsets.only(
                                      top: bloc.size().height / 6),
                                  padding: EdgeInsets.symmetric(horizontal: 15),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        AppLocalizations.of(context)
                                            .tr("payPackage.header"),
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 25,
                                            fontWeight: FontWeight.w800),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        AppLocalizations.of(context)
                                            .tr("payPackage.underHeader"),
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 15,
                                            fontWeight: FontWeight.w700),
                                      ),
                                      SizedBox(
                                        height: bloc.sizeArea() * 2.9,
                                      ),
                                      PackageCard(
                                        title: AppLocalizations.of(context)
                                            .tr("payPackage.first.name"),
                                        desc: AppLocalizations.of(context)
                                            .tr("payPackage.first.period"),
                                        cost: AppLocalizations.of(context)
                                            .tr("payPackage.first.cost"),
                                        moneyType: AppLocalizations.of(context)
                                            .tr("payPackage.first.type"),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      PackageCard(
                                        title: AppLocalizations.of(context)
                                            .tr("payPackage.second.name"),
                                        desc: AppLocalizations.of(context)
                                            .tr("payPackage.second.period"),
                                        cost: AppLocalizations.of(context)
                                            .tr("payPackage.second.cost"),
                                        moneyType: AppLocalizations.of(context)
                                            .tr("payPackage.second.type"),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      PackageCard(
                                        title: AppLocalizations.of(context)
                                            .tr("payPackage.third.name"),
                                        desc: AppLocalizations.of(context)
                                            .tr("payPackage.third.period"),
                                        cost: AppLocalizations.of(context)
                                            .tr("payPackage.third.cost"),
                                        moneyType: AppLocalizations.of(context)
                                            .tr("payPackage.third.type"),
                                      ),
                                      SizedBox(
                                        height: 40,
                                      ),
                                      Container(
                                        width: 400,
                                        height: 40,
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            BumbiButton(
                                              colored: false,
                                              child: Container(),
                                            ),
                                            Expanded(
                                              child: SizedBox(
                                                width: 10,
                                              ),
                                            ),
                                            BumbiButton(
                                              colored: true,
                                              text: AppLocalizations.of(context)
                                                  .tr(
                                                "payPackage.pay",
                                              ),
                                              onPressed: ()async {
                                                if (bloc.selectedPackage() ==
                                                    null)
                                                  showSnackBarContent(
                                                      Text(AppLocalizations.of(
                                                              context)
                                                          .tr("validators.payPackage")),
                                                      scaffold);
                                                else {
                                                  var alrt = AlertDialog(
                                                    title: Text(
                                                        "هذه رسالة تجريبية لتوضيح سبب استمرار ظهور هذه الشاشة .. الدفع لم يتم بعد فالمستخدم لم يشترك بالفعل في أي باقة ولهذا تستمر في الظهور"),
                                                  actions: <Widget>[FlatButton(onPressed: (){Navigator.of(context).pop();}, child: Text("حسناً"))],
                                                  );
                                                  await showDialog(context: context,child: alrt); 
                                                  Navigator.of(context)
                                                      .pushReplacement(
                                                          MaterialPageRoute(
                                                              builder: (context) =>
                                                                  AtelierProviderCenter(
                                                                    index: 0,
                                                                  )));
                                                }
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        height: 20,
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    )),
              ),
            ),
          )),
    );
  }
}
