import 'dart:io';
import 'package:atelier/blocs/design.dart';
import 'package:atelier/models/articleModel.dart';
import 'package:atelier/models/staticData.dart';
import 'package:atelier/screens/home/AtelierProviderCenter.dart';
import 'package:atelier/screens/home/atelierUserCenter.dart';
import 'package:atelier/screens/login&signUp/confirm.dart';
import 'package:atelier/screens/login&signUp/payPackage.dart';
import 'package:atelier/screens/login&signUp/splach.dart';
import 'package:atelier/screens/login&signUp/waitForAccept.dart';
import 'package:flutter/services.dart';

import 'shared_preferences_helper.dart';
import 'package:atelier/models/userModel.dart';
//import 'package:atelier/screens/login&signUp/splach.dart';
import 'package:flutter/cupertino.dart';
import 'package:rxdart/rxdart.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'dart:async';
import 'validators.dart';

class Bloc extends Validators {
  // errors
  BehaviorSubject<UserService> _errorUser = BehaviorSubject<UserService>();
  Function(UserService) get sendErrorUser => _errorUser.sink.add;
  UserService errorUser() => _errorUser.value;
///// done message
  BehaviorSubject<String> _donMSG = BehaviorSubject<String>();
  Function(String) get sendDoneMessage => _donMSG.sink.add;
  String doneMSG() => _donMSG.value;

  // user model
  BehaviorSubject<UserService> _userModel = BehaviorSubject<UserService>();
  Function(UserService) get sendNewUser => _userModel.sink.add;
  UserService currentUser() => _userModel.value;
  Stream<UserService> get userStream => _userModel.stream;
  //.transform(emailValidate);
  
  /// static data
  BehaviorSubject<StaticData> _staticData = BehaviorSubject<StaticData>();
  Function(StaticData) get sendStaticData => _staticData.sink.add;
  StaticData staticData() => _staticData.value;  
  // logged in
  BehaviorSubject<bool> _isLoggedIn = BehaviorSubject<bool>();
  Function(bool) get setLoggedInState => _isLoggedIn.sink.add;
  bool currentUserState() => _isLoggedIn.value;
  Stream<bool> get userLoggedInStateStream => _isLoggedIn.stream;
// user id
  BehaviorSubject<String> _userId = BehaviorSubject<String>();
  Function(String) get setUserId => _userId.sink.add;
  String userId() => _userId.value;
  Stream<String> get userIdStream => _userId.stream;

  // device type and Token and size
  BehaviorSubject<String> _deviceType = BehaviorSubject<String>();
  Function(String) get setDeviceType => _deviceType.sink.add;
  String deviceType() => _deviceType.value;
  BehaviorSubject<String> _deviceToken = BehaviorSubject<String>();
  Function(String) get setDeviceToken => _deviceToken.sink.add;
  String deviceToken() => _deviceToken.value;
  BehaviorSubject<Size> _deviceSize = BehaviorSubject<Size>();
  Function(Size) get setDeviceSize => _deviceSize.sink.add;
  BehaviorSubject<String> _userType = BehaviorSubject<String>();
  Function(String) get setUserType => _userType.sink.add;
  String userType() => _userType.value;
  Size size() => _deviceSize.value;
  double sizeArea() => size().height * size().width / 10000;
  // login
  //email
  BehaviorSubject<String> _emailCtl = BehaviorSubject<String>();
  Function(String) get onEmailChange => _emailCtl.sink.add;
  String email() => _emailCtl.value;
  Stream<String> get emailStream => _emailCtl.stream.transform(emailValidate);
  //password
  BehaviorSubject<String> _passwordCtrl = BehaviorSubject<String>();
  Function(String) get onPasswordChange => _passwordCtrl.sink.add;
  String password() => _passwordCtrl.value;
  Stream<String> get passwordStream =>
      _passwordCtrl.stream.transform(passwordValidate);
  //password
  BehaviorSubject<String> _oldPasswordCtrl = BehaviorSubject<String>();
  Function(String) get onOldPasswordChange => _oldPasswordCtrl.sink.add;
  String oldPassword() => _oldPasswordCtrl.value;
  Stream<String> get oldPasswordStream =>
      _oldPasswordCtrl.stream.transform(oldPasswordValidate);

  //mobile
  BehaviorSubject<String> _mobile = BehaviorSubject<String>();
  Function(String) get onMobileChange => _mobile.sink.add;
  String mobile() => _mobile.value;
  Stream<String> get mobileStream => _mobile.stream.transform(mobileValidate);
  //name
  BehaviorSubject<String> _name = BehaviorSubject<String>();
  Function(String) get onNameChange => _name.sink.add;
  String name() => _name.value;
  Stream<String> get nameStream => _name.stream.transform(nameValidate);
  //.transform(passwordValidate);
  //web site
  BehaviorSubject<String> _siteCtrl = BehaviorSubject<String>();
  Function(String) get onSiteChange => _siteCtrl.sink.add;
  String site() => _siteCtrl.value;
  Stream<String> get siteStream => _siteCtrl.stream;
  //.transform(passwordValidate);
  //activation code
  BehaviorSubject<String> _codeCtrl = BehaviorSubject<String>();
  Function(String) get onCodeChange => _codeCtrl.sink.add;
  String code() => _codeCtrl.value;
  Stream<String> get codeStream => _codeCtrl.stream;
  //.transform(passwordValidate);
  // house image
  BehaviorSubject<File> _houseImageCtl = BehaviorSubject<File>();
  Function(File) get onHouseImageChange => _houseImageCtl.sink.add;
  File houseImage() => _houseImageCtl.value;
  Stream<File> get houseImageStream => _houseImageCtl.stream;
  //.transform(passwordValidate);
  // user image
  BehaviorSubject<File> _userImageCtl = BehaviorSubject<File>();
  Function(File) get onUserImageChange => _userImageCtl.sink.add;
  File userImage() => _userImageCtl.value;
  Stream<File> get userImageStream => _userImageCtl.stream;
  //.transform(passwordValidate);

  //note
  BehaviorSubject<String> _noteCtrl = BehaviorSubject<String>();
  Function(String) get onNoteChange => _noteCtrl.sink.add;
  String note() => _noteCtrl.value;
  Stream<String> get noteStream => _noteCtrl.stream;
  //.transform(passwordValidate);

  //profile image
  BehaviorSubject<File> _profileImageCtl = BehaviorSubject<File>();
  Function(File) get onProfileImageChange => _profileImageCtl.sink.add;
  File profileImage() => _profileImageCtl.value;
  Stream<File> get profileImageStream => _profileImageCtl.stream;
  //.transform(passwordValidate);

  //package
  BehaviorSubject<String> _selectedPackage = BehaviorSubject<String>();
  Function(String) get selectPackage => _selectedPackage.sink.add;
  String selectedPackage() => _selectedPackage.value;
  Stream<String> get selectedPackageStream => _selectedPackage.stream;

  //.transform(passwordValidate);

  BehaviorSubject<List<ArticleCategory>> _categories = BehaviorSubject<List<ArticleCategory>>();
  Function(List<ArticleCategory>) get getCategories => _categories.sink.add;
  List<ArticleCategory> categories() => _categories.value;

//sign Up
  BehaviorSubject<Map<int, String>> _contactTyp =
      BehaviorSubject<Map<int, String>>();
  Function(Map<int, String>) get addNewcontactTyps => _contactTyp.sink.add;
  Map<int, String> contactTyps() => _contactTyp.value;
  Stream<Map<int, String>> get contactTypStream => _contactTyp.stream;


//atelier center
  BehaviorSubject<String> _selectedScreen = BehaviorSubject<String>();
  Function(String) get selectScreen => _selectedScreen.sink.add;
  Stream<String> get selectedScreenStream => _selectedScreen.stream;
  String selectedScreen() => _selectedScreen.value;
///////
  BehaviorSubject<String> _langCtl = BehaviorSubject<String>();
  Function(String) get sendlang => _langCtl.sink.add;
  String lang() => _langCtl.value;
  ////// اضافة منتج -- اسم الاعلان
  BehaviorSubject<String> _dressName = BehaviorSubject<String>();
  Function(String) get onDressNameChange => _dressName.sink.add;
  Stream<String> get dressNameStream =>
      _dressName.stream.transform(dressNameValidate);
  String dressName() => _dressName.value;
//////السعر
  BehaviorSubject<String> _dressPrice = BehaviorSubject<String>();
  Function(String) get onDressPriceChange => _dressPrice.sink.add;
  Stream<String> get dressPriceStream =>
      _dressPrice.stream.transform(dressPriceValidate);
  String dressPrice() => _dressPrice.value;
/////رقم التواصل
  BehaviorSubject<String> _contactNumber = BehaviorSubject<String>();
  Function(String) get onContactNumberChange => _contactNumber.sink.add;
  Stream<String> get contactNumberStream => _contactNumber.stream;
  String contactNumber() => _contactNumber.value;
/////وصف نصي للمنتج
  BehaviorSubject<String> _dressDescrip = BehaviorSubject<String>();
  Function(String) get onDressDescripChange => _dressDescrip.sink.add;
  Stream<String> get dressDescripStream =>
      _dressDescrip.stream.transform(dressdescripValidate);
  String dressDescrip() => _dressDescrip.value;
  //// صور الفستان
  BehaviorSubject<List<File>> _dressImages = BehaviorSubject<List<File>>();
  Function(List<File>) get onDressImagesChange => _dressImages.sink.add;
  List<File> dressImages() => _dressImages.value;
  Stream<List<File>> get dressImagesStreem => _dressImages.stream;
  Stream<bool> get combineDressAddFields => Rx.combineLatest3(
      dressNameStream, dressPriceStream, dressDescripStream, (n, p, d) => true);
  Stream<bool> get combineDressUserAddFields => Rx.combineLatest4(
      dressNameStream, dressPriceStream,mobileStream, dressDescripStream, (n, p,m, d) => true);

  //// ويدجتز صور الفستان
  //   BehaviorSubject<List<Widget>> _dressImagesWidgets = BehaviorSubject<List<Widget>>();
  // Function(List<Widget>) get ondressImagesWidgetsChange => _dressImagesWidgets.sink.add;
  // List<Widget> dressImagesWidgets() => _dressImagesWidgets.value;
  // Stream<List<Widget>> get dressImagesWidgetsStreem  => _dressImagesWidgets.stream;

  Stream<bool> get combineEmailandPassword =>
      Rx.combineLatest2(emailStream, passwordStream, (e, p) => true);
  Stream<bool> get combineSinUpFields => Rx.combineLatest5(
      nameStream,
      emailStream,
      mobileStream,
      siteStream,
      passwordStream,
      (a, b, c, d, e) => true);
  Stream<bool> get combineEditProfileFields => Rx.combineLatest3(
      nameStream, emailStream, mobileStream, (a, b, c) => true);
  Stream<bool> get combineTwoPasswordFields =>
      Rx.combineLatest2(oldPasswordStream, passwordStream, (a, b) => true);

//


  BehaviorSubject<int> _selectedFilter = BehaviorSubject<int>();
  Function(int) get selectFilter => _selectedFilter.sink.add;
  int selectedFilter() => _selectedFilter.value;

  BehaviorSubject<List<Widget>> _fashionCards = BehaviorSubject<List<Widget>>();
  Function(List<Widget>) get updateFasionCards => _fashionCards.sink.add;
  List<Widget> get fashionCards => _fashionCards.value;
  Stream<List<Widget>>get fashionCardsStream=>_fashionCards.stream;
  BehaviorSubject<bool> _closeFilters = BehaviorSubject<bool>();
  Function(bool) get changeCloseFilters => _closeFilters.sink.add;
  bool get closeFilters => _closeFilters.value;
  Stream<bool>get closeFiltersStream=>_closeFilters.stream;


  dispose() {
    _donMSG.close();
    _closeFilters.close();
    _fashionCards.close();
    _userType.close();
    _selectedFilter.close();
    _selectedPackage.close();
    _errorUser.close();
    _profileImageCtl.close();
    _deviceToken.close();
    _userId.close();
    _dressImages.close();
    _deviceType.close();
    _deviceSize.close();
    _dressDescrip.close();
    _contactTyp.close();
    _dressName.close();
    _contactNumber.close();
    _dressPrice.close();
    _emailCtl.close();
    _userModel.close();
    _noteCtrl.close();
    _langCtl.close();
    _oldPasswordCtrl.close();
    _houseImageCtl.close();
    _userImageCtl.close();
    _categories.close();
    _isLoggedIn.close();
    _passwordCtrl.close();
    _selectedScreen.close();
    _codeCtrl.close();
    _mobile.close();
    _siteCtrl.close();
    _staticData.close();
    _name.close();
  }

  Future<bool> onWillPop(BuildContext context) {
    return
        // showDialog(
        //       context: context,
        //       builder: (context) => new AlertDialog(
        //         title: new Text(AppLocalizations.of(context).tr("onPop.title")),
        //         content: new Text(AppLocalizations.of(context).tr("onPop.logOut")),
        //         actions: <Widget>[
        //           new FlatButton(
        //               onPressed: () => Navigator.of(context).pop(false),
        //               child: new Text(AppLocalizations.of(context).tr("onPop.no"))),
        //           new FlatButton(
        //             onPressed: () {
        //               Navigator.of(context).pop();
        //               return false;
        //             },
        //             child: new Text(AppLocalizations.of(context).tr("onPop.yes")),
        //           ),
        //         ],
        //       ),
        //     ) ??
        Future.value(false);
  }
static Future<void> pop({bool animated}) async {
  await SystemChannels.platform.invokeMethod<void>('SystemNavigator.pop', animated);
}
  Future<bool> onClose(BuildContext context) {
    return showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            title: new Text(AppLocalizations.of(context).tr("onPop.title")),
            content: new Text(AppLocalizations.of(context).tr("onPop.content")),
            actions: <Widget>[
              new FlatButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: new Text(AppLocalizations.of(context).tr("onPop.no"),style: TextStyle(color: bumbi),),),
              new FlatButton(
                onPressed: () {
                pop(animated: false);
                  return false;
                },
                child: new Text(AppLocalizations.of(context).tr("onPop.yes"),style: TextStyle(color: bumbi),),
              ),
            ],
          ),
        ) ??
        false;
  }
}

final bloc = Bloc();
////////////////////////////////////////////////////////////////////////////////////////////////////////////
// final storage = new FlutterSecureStorage();
Future updateLocalUser(UserService userService) async {
  await removeSharedOfKey("userData");
await addSharedListOfString("userData", userService.toListData());
await addSharedString("lang",bloc.lang());
}

//
Future loginData() async {
  List<String> userData = await getSharedListOfStringOfKey("userData");
  String lang = await getSharedStringOfKey("lang");
  if(lang!=null)
  bloc.sendlang(lang);
  else
  bloc.sendlang("ar");
  if (userData != null)
    await bloc.sendNewUser(UserService.fromList(userData));
  else
    bloc.sendNewUser(null);
}

Future clearUserData() async {
  await removeSharedOfKey("userData");
}
//////////////////////////////////

///////////////////////////////
chooseScreen(BuildContext context) async {
  await staticData();
  await loginData();
  bool forget =await getSharedBoolOfKey("forget");
  await getAllArticleCategories(context);
  //user
  if (bloc.currentUser() == null)
    Navigator.of(context)
        .pushReplacement(MaterialPageRoute(builder: (context) => Splach()));
  else if (bloc.currentUser().type == "user") {
bloc.setUserType("user");
    if(forget!=null){
    if (bloc.currentUser().admin_status == "approved")
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => AtelierCenter(
                screen: 0,
              )));
    else if (int.tryParse(bloc.currentUser().activation_code) != null) {
      bloc.onEmailChange(bloc.currentUser().email);
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => Confirm(
                from: "signUp",
              )));
    } else
      Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (context) => Splach()));
    }
    else{
      if (int.tryParse(bloc.currentUser().activation_code) != null) {
      bloc.onEmailChange(bloc.currentUser().email);
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => Confirm(
                from: "signUp",
              )));}
      else if (bloc.currentUser().admin_status == "approved")
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => AtelierCenter(
                screen: 0,
              )));
    }
  }
  //user
  //provider
  else if (bloc.currentUser().type == "provider") {
        bloc.setUserType("provider");
        if(forget!=null){
    if (bloc.currentUser().admin_status == "approved" &&
        int.tryParse(bloc.currentUser().package_id) == null)
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => PayPAckage()));
    else if (bloc.currentUser().admin_status == "approved")
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => AtelierProviderCenter(
                screen: 0,
              )));
    else if (bloc.currentUser().admin_status == "pinned")
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => WaitForAccept()));
    else if (int.tryParse(bloc.currentUser().activation_code) != null) {
      bloc.onEmailChange(bloc.currentUser().email);
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => Confirm(
                from: "signUp",
              )));
    } else
      Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (context) => Splach()));
  }
  else{
    if (int.tryParse(bloc.currentUser().activation_code) != null) {
      bloc.onEmailChange(bloc.currentUser().email);
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => Confirm(
                from: "signUp",
              )));
    } 
      else  if (bloc.currentUser().admin_status == "approved" &&
        int.tryParse(bloc.currentUser().package_id) == null)
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => PayPAckage()));
    else if (bloc.currentUser().admin_status == "approved")
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => AtelierProviderCenter(
                screen: 0,
              )));
    else if (bloc.currentUser().admin_status == "pinned")
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => WaitForAccept()));
 else
      Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (context) => Splach()));

  }
  }
  //provider

  else
    return Splach();

}

/////////////////////////////////////////
showSnackBarErrorMessage(GlobalKey<ScaffoldState> scaffold) {
  scaffold.currentState.showSnackBar(SnackBar(
    content: Text(bloc.errorUser().msg),
  ));
}

showSnackBarContent(Widget content, GlobalKey<ScaffoldState> scaffold) {
  scaffold.currentState.showSnackBar(SnackBar(content: content));
}

//Widget loadingScreen(bool loading) =>
//    loading ? LoadingFullScreen() : SizedBox();
String localType(BuildContext context) =>
    Localizations.localeOf(context).languageCode.toString();
focusOn(FocusNode focusNode, BuildContext context) {
  FocusScope.of(context).requestFocus(focusNode);
}
