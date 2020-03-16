import 'package:atelier/blocs/bloc.dart';
import 'package:atelier/blocs/widgets.dart';
import 'package:atelier/models/articleModel.dart';
import 'package:atelier/screens/home/fashionArticle.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:atelier/screens/more/more.dart';
import 'package:atelier/blocs/design.dart';

class UserFashion extends StatefulWidget {
  GlobalKey<ScaffoldState> scaffold;
    PersistentBottomSheetController controller; // <------ Instance variable
  UserFashion({this.scaffold,this.controller});
  @override
  _UserFashionState createState() => _UserFashionState();
}

class _UserFashionState extends State<UserFashion> {
  @override
  void initState() {
            getArticlesOfCategory();

    super.initState();

  }
      getArticlesOfCategory()async{
List<Widget> cards=[];
        bloc.updateFasionCards([LoadingFullScreen()]);
cards=await getAllArticles(category:bloc.selectedFilter(),context: context);
 if(mounted)
bloc.updateFasionCards(cards);
_refreshController.refreshCompleted();
  }
    RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  List<Widget> fashionCard = [
    LoadingFullScreen(),
  ];
  @override
  Widget build(BuildContext context) {
    
    var data = EasyLocalizationProvider.of(context).data;
    return EasyLocalizationProvider(
      data: data,
      child: SafeArea(
          child: Scaffold(
               appBar: AppBar(
          elevation: 0,
            automaticallyImplyLeading: false,
            backgroundColor: backGround,
            title: Row(
              children: <Widget>[
                      SmallIconButton(
                              icon: Icons.arrow_back_ios,
                             onPressed: (){          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>More()));
},
                            ),
                Text(
                 AppLocalizations.of(context).tr("more.new"),
                  style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold),
                ),
                      
              ],
            ),
        ),
      
        key: widget.scaffold,
        body: Container(
          width: bloc.size().width,
          height: bloc.size().height,
          child: Container(
            height: MediaQuery.of(context).size.height,
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            alignment: Alignment.center,
            width: bloc.size().width,
            child: SmartRefresher(
        onRefresh:()async{
          await getAllArticles(category: bloc.selectedFilter(),context: context);
          _refreshController.refreshCompleted();
       },
            header: BezierCircleHeader(),
            controller: _refreshController,
            enablePullDown: true,
        child: StreamBuilder<List<Widget>>(
          stream: bloc.fashionCardsStream,
          initialData: fashionCard,
          builder:(context,s){
            
            return StaggeredGridView.countBuilder(
                  itemCount:s.data.length??bloc.fashionCards.length,
                  crossAxisCount: 4,
                  staggeredTileBuilder: (int index) =>
                      new StaggeredTile.count(2, index.isEven ? 2.5 : 1.53),
                  mainAxisSpacing: 4.0,
                  crossAxisSpacing: 4.0,
                  physics: BouncingScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  itemBuilder: (context, index) => s.data[index]);},
        ),
          ),)
        ),
      )),
    );
  }
}

