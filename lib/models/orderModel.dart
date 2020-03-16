
import 'package:atelier/blocs/bloc.dart';
import 'package:atelier/models/productModel.dart';
import 'package:atelier/models/providerModel.dart';
import 'package:atelier/screens/home/AtelierProviderCenter.dart';
import 'package:atelier/screens/login&signUp/splach.dart';
import 'package:flutter/cupertino.dart';
import 'package:atelier/blocs/widgets.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart'as http;
import 'dart:convert';
import 'dart:async';

import 'package:progress_dialog/progress_dialog.dart';
class Order {
  int id;
  String status; //": "waiting",
  Product product;
  String note; // "عاوزه من ده يا حزومبل",
  int count; //": 2,
  UserData userData;
  String cancel_reason;
  ProviderModel providerModel;
  bool paid;
  String creation_time;
  Order(
      {this.id,
      this.product,
      this.count,
      this.cancel_reason,
      this.creation_time,
      this.note,
      this.providerModel,
      this.paid,
      this.status,
      this.userData});
      factory Order.fromJson(Map<String,dynamic> orderData){
     try {
        return Order(
          id: orderData['id'],
          product: Product.fromHomeJson(orderData['product']),
          note: orderData['note'],
          cancel_reason: orderData['cancel_reason'],
          count: orderData['count'],
          userData: UserData.fromJson(orderData['user_id']),
          paid: orderData['paid'],
 providerModel: ProviderModel(
            id: orderData['user_id']['id'],
            email: orderData['user_id']['email'],
            image: orderData['user_id']['image'],
            mobile: orderData['user_id']['mobile'],
            name: orderData['user_id']['name'],
            type: orderData['user_id']['type']
          ),
          creation_time: orderData['creation_time'],
          status: orderData['status']
        );}
        catch(e)
{
  bloc.sendDoneMessage(e);
  return Order();
  }
      }
}

class UserData {
  int id;
  String name;
  String type;
  String mobile;
  String email;
  String image;
  UserData(
      {this.email, this.id, this.image, this.mobile, this.name, this.type});
  factory UserData.fromJson(Map<String, dynamic> user) {
    return UserData(
      id: user['id'],
      name: user['name'],
      email: user['email'],
      image: user['image'],
      mobile: user['mobile'],
      type: user['type'],
    );
  }
}
Future createOrder({int count,int product_id,String note,BuildContext context}) async {
  http.Response response = await http.post("https://atelierapps.com/api/v1/order", body: {
   "count":count.toString(),
   "product_id":product_id.toString(),
   "note":note??"",
  }, headers: {
    "apiToken":"sa3d01${bloc.currentUser().apiToken}",
    "lang": bloc.lang() ?? "ar"
  });
  final createdJson = json.decode(response.body);
  if (createdJson["status"] == 200) {
    bloc.sendDoneMessage(null);
    print(product_id);
    return null;
  } else
  if(createdJson['status']==401)
  {
   await clearUserData();
   Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>Splach()));
  }
  else{
    bloc.sendDoneMessage(createdJson['msg']);
  }
    
}

Future updateOrderBeforeAccept({int count,int id,String note,BuildContext context}) async {
  http.Response response = await http.post("https://atelierapps.com/api/v1/order/$id", body: {
   "count":count.toString(),
   "note":note??"",
  }, headers: {
    "apiToken":"sa3d01${bloc.currentUser().apiToken}",
    "lang": bloc.lang() ?? "ar"
  });
  final createdJson = json.decode(response.body);
  if (createdJson["status"] == 200) {
    bloc.sendDoneMessage(null);
    return null;
  } else
  if(createdJson['status']==401)
  {
   await clearUserData();
   Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>Splach()));
  }
  else{
    bloc.sendDoneMessage(createdJson['msg']);
  }
    
}


Future<List<OrderCard>> getAllOrdersOfStatus(String status,BuildContext context)async{
 
 try{ http.Response response =await http.get("https://atelierapps.com/api/v1/order/$status",headers: {
    "apiToken":"sa3d01${bloc.currentUser().apiToken}"
  });
  final allOrders=json.decode(response.body);
  if(allOrders['status']==200)
  {
    List orders=allOrders['data'];
    List<OrderCard> orderCards=[];
    for(int i=0;i<orders.length;i++){
      Order order =Order.fromJson(orders[i]);
      OrderCard orderCard =OrderCard(order: order);
      if(order.status==status&&order.product.title!=null&&order.product.user_name!=null&&order.id!=null)
      orderCards.add(orderCard);
    }
    return orderCards;
  }
  
  else if(allOrders['status']==401){
await clearUserData();
Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>Splach()));
  }else{
    bloc.sendDoneMessage(allOrders['msg']);
    return [];
  }
  }
  catch(e){
    print(e);
    return [];
  }
    return [];
}



Future acceptOrder({int id,BuildContext context,ProgressDialog loading}) async {
  if(loading!=null)
  loading.show();
  http.Response response = await http.post("https://atelierapps.com/api/v1/order/$id/accept",  headers: {
    "apiToken":"sa3d01${bloc.currentUser().apiToken}",
    "lang": bloc.lang() ?? "ar"
  });
  final createdJson = json.decode(response.body);
  if (createdJson["status"] == 200) {
    bloc.sendDoneMessage(null);
      if(loading!=null)
  await loading.hide();
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) => AtelierProviderCenter(
                          screen: 0,
                          index: 1,
                        )));

    return null;
  } else
  if(createdJson['status']==401)
  {
   await clearUserData();
         if(loading!=null)
  await loading.hide();

   Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>Splach()));
  }
  else{
          if(loading!=null)
  await loading.hide();

    bloc.sendDoneMessage(createdJson['msg']);
  }
    
}
Future cancelOrder({int id,String reason,BuildContext context}) async {
  http.Response response = await http.post("https://atelierapps.com/api/v1/order/${id.toString()}/cancel",body: {
    "cancel_reason":reason
  },  headers: {
    "apiToken":"sa3d01${bloc.currentUser().apiToken}",
  });
  final createdJson = json.decode(response.body);
  if (createdJson["status"] == 200) {
    bloc.sendDoneMessage(null);
Navigator.of(context).pushReplacement(MaterialPageRoute(builder:(context)=> AtelierProviderCenter(screen: 0,index: 2,)));
    return null;
  } else
  if(createdJson['status']==401)
  {
   await clearUserData();
   Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>Splach()));
  }
  else{
    bloc.sendDoneMessage(createdJson['msg']);
  }
    
}
