import 'dart:async';
import 'dart:ui';

import 'package:atelier/blocs/bloc.dart';
import 'package:atelier/blocs/design.dart';
import 'package:atelier/blocs/widgets.dart';
import 'package:atelier/models/orderModel.dart';
import 'package:atelier/screens/home/providerPage.dart';
import 'package:atelier/screens/ordersScreens/MakeOrder.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:image_fade/image_fade.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class AcceptedOrderPage extends StatefulWidget {

  Order order;
  AcceptedOrderPage({this.order});
  @override
  _AcceptedOrderPageState createState() => _AcceptedOrderPageState();
}

class _AcceptedOrderPageState extends State<AcceptedOrderPage> {
  initState() {
     for(int i=0;i<widget.order.product.images.length;i++)
    {
      images.add(
                     FadeInImage(
                                    placeholder:AssetImage('assets/images/placeholder.gif'),

                          image:NetworkImage(widget.order.product.images[i])
                              ,
                          fit: BoxFit.fill));
    }
    super.initState();
  }
  dispose(){
    super.dispose();
  }
  List<Widget> images = [
  ];
  PageController controller = PageController(
    initialPage: 0,
  );
  GlobalKey<ScaffoldState>scaffold=GlobalKey();
  @override
  Widget build(BuildContext context) {
    var data = EasyLocalizationProvider.of(context).data;
    Size size = MediaQuery.of(context).size;
    return EasyLocalizationProvider(
      data: data,
      child: WillPopScope(
        onWillPop: () async {
          Navigator.of(context).pop();
          return false;
        },
        child: Scaffold(
key: scaffold,
          body: Container(
            width: size.width,
            height: size.height,
            child: Stack(
              children: <Widget>[
                SingleChildScrollView(
                  child: Column(
                    // start of page
                    children: <Widget>[
                      Container(
                        width: size.width,
                        height: bloc.size().height / 2,
                        child: Stack(
                          alignment: Alignment.bottomCenter,
                          children: <Widget>[
                            Container(
                              // images
                              height: bloc.size().height / 2,
                              child: PageView(
                                controller: controller,
                                scrollDirection: Axis.horizontal,
                                children: images,
                                reverse: true,
                                pageSnapping: true,
                              ),
                            ),
                            Container(
                              //indicator
                              margin: EdgeInsets.only(bottom: 50),
                              child: SmoothPageIndicator(
                                controller: controller,
                                count: images.length,
                                effect: ExpandingDotsEffect(
                                    dotHeight: 12,
                                    dotWidth: 14,
                                    dotColor: Colors.white.withOpacity(.85),
                                    radius: 2),
                              ),
                            ),
                            Positioned(
                              //decoration
                              top: (bloc.size().height / 2) - 30,
                              child: Container(
                                decoration: BoxDecoration(
                                    color: Color(0xffF9F9F9),
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(45),
                                        topRight: Radius.circular(45))),
                                height: 35,
                                width: size.width,
                              ),
                            ),
                            Positioned(
                              // back button
                              top: 20,
                              child: Container(
                                width: size.width,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    SmallIconButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      icon: Icons.arrow_back_ios,
                                    ),
                                    Container(
                                            height: 30,
                                            width: 66,
                                            alignment: Alignment.center,
                                            margin: EdgeInsets.only(left: 10),
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 10, vertical: 5),
                                            decoration: BoxDecoration(
                                                color:
                                                    widget.order.paid ? bumbiAccent :
                                                    hintAccent,
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(5))),
                                            child: Text(
                                              widget.order.paid?AppLocalizations.of(context).tr("myOrders.paied"):AppLocalizations.of(context).tr("myOrders.notPaied"),
                                              style: TextStyle(
                                                  color:
                                                      widget.order.paid ? bumbi :
                                                      hint,
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.w800),
                                            ),
                                          )
                                       
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ), //images slider

                      Container(
                        constraints: BoxConstraints(minHeight: bloc.size().height/2),
                        child: DetailsWithCustomBottomSheet(
                            detailsBody: detailsBody(context,widget.order),
                            spaceForHeader: 100,
                            headerBottomSheet: headerBottomSheet(context,widget.order),
                            bodyBottomSheet: bodBottomSheet(context,widget.order,scaffold)),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  child:
                   Container(
                    width: bloc.size().width,
                    decoration: BoxDecoration(boxShadow: [
                      BoxShadow(
                          color: Colors.black45,
                          spreadRadius: 5,
                          blurRadius: 15)
                    ]),
                  ),
                  bottom: 0,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Widget detailsBody(BuildContext context,Order order) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
        order.product.title   ,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                order.product.price,
                style: TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 26, color: bumbi),
              ),
              Text(
                AppLocalizations.of(context).tr("payPackage.first.type"),
                style: TextStyle(fontSize: 14, color: bumbi),
              )
            ],
          )
        ],
      ), //فستان اسود
      SizedBox(
        height: 12,
      ),
      Text(
        AppLocalizations.of(context).tr("myProduct.descrip"),
        style: TextStyle(fontSize: 14, color: hint),
      ),
      SizedBox(
        height: 6,
      ),
      Container(
        child: Wrap(
          children: <Widget>[
            Text(
order.product.note,            style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
      SizedBox(
        height: 12,
      ),
      Text(
        AppLocalizations.of(context).tr("myProduct.providerHouse"),
        style: TextStyle(fontSize: 14, color: hint),
      ),
      SizedBox(
        height: 6,
      ),
      InkWell(
         onTap: (){
                                                      Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) =>
                        ProviderPage(providerModel:order.providerModel )));
                                                    },
        child: Text(
          order.product.user_name,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
        ),
      ),
    ],
  );
}

Widget headerBottomSheet(BuildContext context,Order order) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      Padding(
        padding: EdgeInsets.symmetric(horizontal: bloc.size().width / 3),
        child: Divider(
          thickness: 2,
        ),
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(
            children: <Widget>[
              Text(
                AppLocalizations.of(context).tr("myOrders.orderNo"),
                style: TextStyle(fontSize: 16, color: hint),
              ),
              SizedBox(
                width: 5,
              ),
              Text(
                order.id.toString(),
                style: TextStyle(fontSize: 16, color: hint),
              )
            ],
          ),
          Container(
            padding: EdgeInsets.only(left: 20, top: 8, right: 20),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                color: bumbiAccent),
            child: Text(
              order.count.toString(),
              style: TextStyle(
                  fontSize: 26, color: bumbi, fontWeight: FontWeight.bold),
            ),
          )
        ],
      ),
      SizedBox(
        height: 12,
      ),
      Text(
        AppLocalizations.of(context).tr("myProduct.descrip"),
        style: TextStyle(fontSize: 14, color: hint),
      ),
      SizedBox(
        height: 10,
      ),
    ],
  );
}

Widget bodBottomSheet(BuildContext context,Order order,GlobalKey<ScaffoldState>scaffold) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
    Container(
        constraints: BoxConstraints(maxHeight: bloc.size().height/7),
        padding: EdgeInsets.symmetric(horizontal: 20),
        width: bloc.size().width,
        child: SingleChildScrollView(
          child: Wrap(
            children: <Widget>[
              Text(
order.note              ),
            ],
          ),
        ),
      ),
      SizedBox(
        height: 20,
      ),
      Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        width: bloc.size().width,
        height: 40,
        child:
     order.paid?
         Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
           
            
            BumbiButton(
              colored: true,
              text: AppLocalizations.of(context).tr("myOrders.rate"),
              onPressed: () {
                scaffold.currentState.showBottomSheet( ( context) {
                                                    return 
                                                      
                                                        Container(
                                                          child:
                                                              Rate(),
                                                           
                                                        );
                                                  });
              },
            )
          ],
        ): Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            BumbiButton(
              colored: true,
              text: AppLocalizations.of(context).tr("myOrders.pay"),
              onPressed: () {
              },
            ),
            
           
          ],
        ),
      ),
      SizedBox(
        height: 20,
      )
    ],
  );
}

class Rate extends StatefulWidget {
  @override
  _RateState createState() => _RateState();
}

class _RateState extends State<Rate> {
  bool delete = false;
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        Container(
          color: Colors.transparent,
          child: Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(45), topLeft: Radius.circular(45))),
              child: Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Stack(
                    alignment: Alignment.center,
                    children: <Widget>[
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Container(
                              width: 148,
                              height: 100,
                              child: Image.asset('assets/images/rate.png')),
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            AppLocalizations.of(context).tr("myOrders.addRate"),
                            style: TextStyle(
                                fontSize: 18,
                                color: blackAccent,
                                fontWeight: FontWeight.bold),
                          ),
                            SizedBox(
                                height: 10,
                              ),
                              RatingBar(
                                initialRating: 4.5,
                                minRating: 1,
                                glow: false,

                                textDirection: TextDirection.ltr,
                                direction: Axis.horizontal,
                                allowHalfRating: true,
                                itemCount: 5,
                                itemSize: 18,
                                itemPadding:
                                    EdgeInsets.symmetric(horizontal: 2.0),
                                itemBuilder: (context, _) => Icon(
                                  Icons.star,
                                  color: Colors.amber,
                                ),
                                onRatingUpdate: (rating) {},
                              ),                            SizedBox(
                                height: 20,
                              ),
Container(
  padding: EdgeInsets.symmetric(horizontal: 10),
  child: TextFormField(
    cursorColor: bumbi,
    decoration: InputDecoration(border: InputBorder.none
    ,
    
    hintText: AppLocalizations.of(context).tr("myOrders.comment")
    ),
  ),
  height: 50,
  width: bloc.size().width,
  decoration:BoxDecoration(
    color: Color(0xfff9f9f9),
    borderRadius: BorderRadius.all(Radius.circular(15))
  ) ,),
                          SizedBox(
                            height: 30,
                          ),
                          Container(
                            height: 40,
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: <Widget>[
                                BumbiButton(
                                  colored: true,
                                  text: AppLocalizations.of(context)
                                      .tr("myOrders.cancelOrder"),
                                  onPressed: () {
                                  },
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                BumbiButton(
                                  colored: false,
                                  text: AppLocalizations.of(context)
                                      .tr("myOrders.back"),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                )
                              ],
                            ),
                          )
                        ],
                      ),
             delete?         Positioned.fill(
                        child: LoadingFullScreen(),
                      ):SizedBox(),
      
                      
                    ],
                  ))),
        ),
      ],
    );
  }
}

