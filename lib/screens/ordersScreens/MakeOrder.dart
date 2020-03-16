import 'package:atelier/blocs/design.dart';
import 'package:atelier/models/orderModel.dart';
import 'package:atelier/screens/home/atelierUserCenter.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:atelier/blocs/bloc.dart';
import 'package:atelier/blocs/widgets.dart';
import 'dart:async';

import 'package:url_launcher/url_launcher.dart';

class MakeOrder extends StatefulWidget {
  int id;
  Order order;
  MakeOrder({this.id, this.order});
  @override
  _MakeOrderState createState() => _MakeOrderState();
}

class _MakeOrderState extends State<MakeOrder> {
  @override
  void initState() {
    if(widget.order!=null)
    setState(() {
      counter=widget.order.count;
      if(widget.order.note!=null)
      {
      _textEditingController.text=widget.order.note;
note=widget.order.note;
      }
    });
    super.initState();
  }
bool empty=false;
TextEditingController _textEditingController=TextEditingController();
  void whatsAppOpen(String mobile) async {
    var whatsappUrl = "whatsapp://send?phone=$mobile";
    if (await canLaunch(whatsappUrl)) {
      await launch(whatsappUrl);
    } else {
      await launch("tel:$mobile");
    }
  }

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      print('Could not launch $url');
    }
  }

  GlobalKey<ScaffoldState> scaffold = GlobalKey();
  bool loading = false;
  String note;
  int counter = 1;
  @override
  Widget build(BuildContext context) {
    var data = EasyLocalizationProvider.of(context).data;
    Size size = MediaQuery.of(context).size;
    double safe = MediaQuery.of(context).padding.top;
    bloc.setDeviceSize(Size(size.width, size.height - safe));
    String girle = AppLocalizations.of(context).tr("splach.girle").toString();
    String localCode = Localizations.localeOf(context).languageCode.toString();
    // String code =Localizations.localeOf(context).languageCode;
    return EasyLocalizationProvider(
      data: data,
      child: WillPopScope(
        onWillPop: () {
          return Future.value(true);
        },
        child: SafeArea(
          child: Scaffold(
            key: scaffold,
            body: GestureDetector(
              onTap: (){
                FocusScope.of(context).requestFocus(FocusNode());
              },
              child: Container(
                  width: size.width,
                  height: size.height,
                  child: Stack(
                    alignment: bloc.lang() == "ar"
                        ? Alignment.topRight
                        : Alignment.topLeft,
                    children: <Widget>[
                      Positioned(
                        bottom: 0,
                        left: localCode == "ar" ? 0 : null,
                        right: localCode == "ar" ? null : 0,
                        child: Opacity(
                          opacity: 0.2,
                          child: Container(
                              alignment: localCode == "ar"
                                  ? Alignment.bottomLeft
                                  : Alignment.bottomRight,
                              width: size.width - 50,
                              height: size.height - 50,
                              child: Image.asset(
                                'assets/images/$girle',
                                fit: BoxFit.fill,
                              )),
                        ),
                      ),
                      SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              margin: EdgeInsets.only(top: 20),
                              child: Row(
                                children: <Widget>[
                                  SmallIconButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    icon: Icons.arrow_back_ios,
                                  ),
                                  Text(
                                    AppLocalizations.of(context)
                                        .tr("myOrders.makeOrder"),
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  )
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  right: 20, top: 10, left: 20),
                              child: Wrap(
                                children: <Widget>[
                                  Text(
                                    AppLocalizations.of(context)
                                        .tr("myOrders.hint"),
                                    style: TextStyle(
                                        fontSize: 26,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 60,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 20),
                                  child: Text(
                                    AppLocalizations.of(context)
                                        .tr("myOrders.count"),
                                    style: TextStyle(fontSize: 16, color: hint),
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.symmetric(horizontal: 20),
                                  height: 40,
                                  width: 120,
                                  child: Stack(
                                    overflow: Overflow.visible,
                                    alignment: Alignment.center,
                                    children: <Widget>[
                                      Container(
                                          alignment: Alignment.center,
                                          color: Colors.white,
                                          width: 100,
                                          height: 35,
                                          child: Text(
                                            "$counter",
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold),
                                          )),
                                      CounterButton(
                                        left: -5,
                                        iconData: Icons.remove,
                                        onLongPressed: () {
                                          setState(() {
                                            counter = 1;
                                          });
                                        },
                                        onPressed: () {
                                          setState(() {
                                            if (counter > 1) counter--;
                                          });
                                        },
                                      ),
                                      CounterButton(
                                        right: -5,
                                        iconData: Icons.add,
                                        onPressed: () {
                                          setState(() {
                                            counter++;
                                          });
                                        },
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                            Container(
                              margin: EdgeInsets.all(20),
                              padding: EdgeInsets.symmetric(horizontal: 20),
                              child: TextFormField(
                                onChanged: (v) {
                                  setState(() {
                                    note = v;
                                  });
                                },
                                cursorColor: bumbi,
                                maxLines: 5,
                                controller: _textEditingController,
                                style: TextStyle(
                                    fontSize: 17, fontWeight: FontWeight.w600),
                                decoration: InputDecoration(
                                    hintStyle: TextStyle(
                                        fontSize: 16,
                                        color: empty?Colors.red:Colors.grey,
                                        fontWeight: FontWeight.normal),
                                    border: InputBorder.none,
                                    hintText:empty? AppLocalizations.of(context)
                                        .tr("myOrders.note"):AppLocalizations.of(context)
                                        .tr("myProduct.descrip")),
                              ),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(15))),
                            ),
                            Container(
                              height: 40,
                              margin: EdgeInsets.all(20),
                              child: MaterialButton(
                                color: bumbi,
                                shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5))),
                                highlightColor: Colors.redAccent.withOpacity(.5),
                                splashColor: Colors.red[50],
                                colorBrightness: Brightness.light,
                                padding: EdgeInsets.all(0),
                                child: Container(
                                    height: 40,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.all(Radius.circular(5))),
                                    child: Text(
                                      AppLocalizations.of(context)
                                          .tr("myOrders.confirm"),
                                      style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    )),
                                onPressed: () async {
                                  if(note==null||note.isEmpty)
                                  setState(() {
                                    empty=true;
                                  });
                                  else{

                                    setState(() {
                                    loading = true;
                                  });

                                if(widget.order==null)
                                    await createOrder(
                                      context: context,
                                      count: counter,
                                      product_id: widget.id,
                                      note: note);
                                    else
                                      await updateOrderBeforeAccept(
                                      context: context,
                                      count: counter,
                                      id: widget.order.id,
                                      note: note);

                                
                                  setState(() {
                                    loading = false;
                                  });
                                  if (bloc.doneMSG() != null)
                                    showSnackBarContent(
                                        Text(bloc.doneMSG()), scaffold);
                                  else {
                                    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>AtelierCenter(
                                      screen: 1,
                                      index: 0,
                                    )));
                                  }
                                  }
                                },
                              ),
                            )
                          ],
                        ),
                      ),
                      loading ? LoadingFullScreen() : SizedBox()
                    ],
                  )),
            ),
          ),
        ),
      ),
    );
  }
}

class CounterButton extends StatelessWidget {
  CounterButton(
      {this.iconData,
      this.onPressed,
      this.left,
      this.right,
      this.onLongPressed});
  IconData iconData;
  Function onPressed;
  Function onLongPressed;
  double left;
  double right;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: left,
      right: right,
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            boxShadow: [
              BoxShadow(
                  color: Colors.grey[200], blurRadius: .2, spreadRadius: .2),
              BoxShadow(color: Colors.white)
            ]),
        width: 36,
        height: 36,
        child: MaterialButton(
          splashColor: Colors.white,
          onLongPress: onLongPressed,
          highlightColor: bumbiAccent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          onPressed: onPressed,
          padding: EdgeInsets.all(0),
          child: Icon(
            iconData,
            color: bumbi,
          ),
        ),
      ),
    );
  }
}
