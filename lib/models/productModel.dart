import 'dart:io';
import 'package:atelier/blocs/bloc.dart';
import 'package:atelier/models/providerModel.dart';
import 'package:atelier/screens/home/home.dart';
import 'package:flutter/material.dart';
import 'package:mime/mime.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'dart:convert';
import 'dart:async';

class Product {
  final serviceURL = "https://atelierapps.com/api/v1/product/";
  int status;
  int id;
  String title;
  String price;
  String note;
  List images;
  ProviderModel providerModel;
  int user_id;
  String user_name;
  String user_type;
  String user_mobile;
  String user_email;
  String user_image;
  String msg;
  Product(
      {this.id,
      this.images,
      this.msg,
      this.note,
      this.price,
      this.status,
      this.providerModel,
      this.title,
      this.user_email,
      this.user_id,
      this.user_type,
      this.user_image,
      this.user_mobile,
      this.user_name});

  factory Product.fromHomeJson(Map<String, dynamic> product) {
    try {
      return Product(
          id: product['id'],
          images: product['images'],
          note: product['note'],
          price: product['price'].toString(),
          providerModel: ProviderModel(
            id: product['user']['id'],
            email: product['user']['email'],
            image: product['user']['image'],
            mobile: product['user']['mobile'],
            name: product['user']['name'],
            type: product['user']['type']
          ),
          title: product['title'],
          user_email: product['user']['email'],
          user_id: product['user']['id'],
          user_image: product['user']['image'],
          user_mobile: product['user']['mobile'],
          user_name: product['user']['name'],
          user_type: product['user']['type']);
    } catch (e) {
      return Product(status: 501, msg: e.toString());
    }
  }

  ////////////////////////////
  factory Product.fromJson(Map<String, dynamic> product) {
    try {
      if (product['status'] == 200) {
        return Product(
            status: product['status'],
            id: product['data']['id'],
            images: product['data']['images'],
            note: product['data']['note'],
            price: product['data']['price'].toString(),
            title: product['data']['title'],
             providerModel: ProviderModel(
            id: product['data']['user']['id'],
            email: product['data']['user']['email'],
            image: product['data']['user']['image'],
            mobile: product['data']['user']['mobile'],
            name: product['data']['user']['name'],
            type: product['data']['user']['type']
          ),
            user_email: product['data']['user']['email'],
            user_id: product['data']['user']['id'],
            user_image: product['data']['user']['image'],
            user_mobile: product['data']['user']['mobile'],
            user_name: product['data']['user']['name'],
            user_type: product['data']['user']['type']);
      } else
        return Product(status: product['status'], msg: product['msg']);

      //status: product['status'], msg: product['msg']);
    } catch (e) {
      return Product(status: 501, msg: e.toString());
    }
  }

  factory Product.fromProviderJson(Map<String, dynamic> product) {
    try {
      if (product['id'] != null) {
        return Product(
            id: product['id'],
            images: product['images'],
            note: product['note'],
            price: product['price'].toString(),
            title: product['title'],
             providerModel: ProviderModel(
            id: product['user']['id'],
            email: product['user']['email'],
            image: product['user']['image'],
            mobile: product['user']['mobile'],
            name: product['user']['name'],
            type: product['user']['type']
          ),
            user_email: product['user']['email'],
            user_id: product['user']['id'],
            user_image: product['user']['image'],
            user_mobile: product['user']['mobile'],
            user_name: product['user']['name'],
            user_type: product['user']['type']);
      } else
        return null;
      //status: product['status'], msg: product['msg']);
    } catch (e) {
      return Product(status: 501, msg: e.toString());
    }
  }
}
////////////////////////////////////////
/////////////////////////////// methods

Future<List<String>> uploadimages(List<File> images) async {
  final mimeTypeData =
      lookupMimeType(images[0].path, headerBytes: [0xFF, 0xD8]).split('/');
  final imageUploadRequest = http.MultipartRequest('POST',
      Uri.parse("https://atelierapps.com/api/v1/product/upload_images"))
    ..headers.addAll({
      "apiToken": "sa3d01${bloc.currentUser().apiToken}",
      "lang": bloc.lang() ?? "ar"
    });
  List<http.MultipartFile> filesList = new List<http.MultipartFile>();
  for (int i = 0; i < images.length; i++) {
    final file = await http.MultipartFile.fromPath("file[$i]", images[i].path,
        contentType: MediaType(mimeTypeData[0], mimeTypeData[1]));
    filesList.add(file);
  }
  imageUploadRequest.files.addAll(filesList);
  try {
    final streamedResponse = await imageUploadRequest.send();
    final response = await http.Response.fromStream(streamedResponse);
    final imagesURLJson = json.decode(response.body);
    if (imagesURLJson['status'] == 200) {
      List<String> url = [];
      for (int i = 0; i < imagesURLJson['data'].length; i++)
        url.add(imagesURLJson['data'][i]);
      return url;
    } else {
      return [];
    }
  } catch (e) {
    return [];
  }
}

Future sendDress() async {
  try {
    List<String> imagesURL = [];
    if (bloc.dressImages().isEmpty) bloc.onDressImagesChange([]);
    if (bloc.dressImages().length > 0)
      imagesURL = await uploadimages(bloc.dressImages());
    Map<String, dynamic> body = {
      "title": bloc.dressName(),
      "price": bloc.dressPrice(),
      "note": bloc.dressDescrip(),
    };
    for (int i = 0; i < imagesURL.length; i++) {
      body["images[$i]"] = imagesURL[i];
    }
    http.Response response = await http
        .post("https://atelierapps.com/api/v1/product", body: body, headers: {
      "apiToken": "sa3d01${bloc.currentUser().apiToken}",
      "lang": bloc.lang() ?? "ar"
    });
    final productJson = json.decode(response.body);
    Product newProduct = Product.fromJson(productJson);
    if (newProduct.status == 200) {
      bloc.sendDoneMessage(newProduct.id.toString());
    } else {
      bloc.sendDoneMessage(newProduct.msg);
    }
  } catch (e) {
    bloc.sendDoneMessage(e.toString());
  }
}

Future editDress(int id, List<String> oldImages) async {
  try {
    List<String> imagesURL = [];
    if (bloc.dressImages() != null) {
      if (bloc.dressImages().isEmpty) bloc.onDressImagesChange([]);
    }
    if (bloc.dressImages() != null) {
      if (bloc.dressImages().length > 0)
        imagesURL = await uploadimages(bloc.dressImages());
    }

    imagesURL.addAll(oldImages);
    Map<String, String> body = {
      "title": bloc.dressName(),
      "price": bloc.dressPrice(),
      "note": bloc.dressDescrip(),
    };
    for (int i = 0; i < imagesURL.length; i++) {
      body["images[$i]"] = imagesURL[i];
    }
    http.Response response = await http.post(
        "https://atelierapps.com/api/v1/product/$id",
        body: body,
        headers: {"apiToken": "sa3d01${bloc.currentUser().apiToken}"});
    final productJson = json.decode(response.body);
    Product newProduct = Product.fromJson(productJson);
    if (newProduct.status == 200) {
      bloc.sendDoneMessage("done");
    } else {
      bloc.sendDoneMessage(newProduct.msg.toString());
    }
  } catch (e) {
    print(e);
    print(bloc.currentUser().apiToken);
    bloc.sendDoneMessage(e.toString());
  }
}

Future deletDress(int id) async {
  try {
    final http.Response allRemainedDressesJson = await http.delete(
        "https://atelierapps.com/api/v1/product/$id",
        headers: {"apiToken": "sa3d01${bloc.currentUser().apiToken}"});
  } catch (e) {
    bloc.sendDoneMessage(e.toString());
  }
}

Future<List<Widget>> getAllUsedProducts() async {
  List<Widget> products = [];
  http.Response response =
      await http.get("https://atelierapps.com/api/v1/used_products");
  final productJson = json.decode(response.body);
  if (productJson['status'] == 200) {
    List allProducts = productJson['data'];
    for (int i = 0; i < allProducts.length; i++)
      products.add(HouseCard(
        product: Product.fromHomeJson(allProducts[i]),
      ));
    return products;
  } else
    return products;
}
