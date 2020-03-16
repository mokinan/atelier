import 'package:http/http.dart'as http;
import 'dart:convert';
import 'package:atelier/blocs/bloc.dart';
class StaticData {
  String about;
  String terms;
  String mobile;
  String email;
  String f;
  String t;
  String s;
  StaticData(
      {this.about,
      this.email,
      this.f,
      this.mobile,
      this.s,
      this.t,
      this.terms});
  factory StaticData.fromJson(Map<String, dynamic> setting) {
    if (setting['status'] == 200)
      return StaticData(
          about: setting['data']['about'],
          email: setting['data']['email'],
          terms: setting['data']['terms'],
          mobile: setting['data']['mobile'],
          f: setting['data']['facebook'],
          t: setting['data']['twitter'],
          s: setting['data']['snap'] ?? setting['data']['insta']);
    else
      return StaticData(
          about: "", email: "", terms: "", mobile: "", f: "", t: "", s: "");
  }
}

Future staticData() async {
  http.Response response =
      await http.get("https://atelierapps.com/api/v1/setting");
  final staticData = json.decode(response.body);
  StaticData data=  StaticData.fromJson(staticData);
  bloc.sendStaticData(data);
}
  getContactTyps()async{
     http.Response response =
      await http.get("https://atelierapps.com/api/v1/contact/reason",
      headers: {"apiToken":"sa3d01${bloc.currentUser().apiToken}"});
  final reasonsData = json.decode(response.body);
  Map<int,String>reasons={};
  if(reasonsData['status']==200){
for(int i=0;i<reasonsData['data'].length;i++)
{
  reasons[reasonsData['data'][i]['id']]=reasonsData['data'][i]['name'];
}
  }
  bloc.addNewcontactTyps(reasons);
return reasons;

  }

  contactUs(int id,String reason)async{
     http.Response response =
      await http.post("https://atelierapps.com/api/v1/contact",
      body: {"reason_id":id.toString(),"message":reason},
      headers: {"apiToken":"sa3d01${bloc.currentUser().apiToken}"});
  final reasonsData = json.decode(response.body);
  if (reasonsData['status'] == 200) {
    return "تم الإرسال";
  } else if (reasonsData['status'] == 401)
    return 401;
  else
    return reasonsData['msg'];

  }
