import 'package:atelier/blocs/bloc.dart';
import 'package:atelier/blocs/design.dart';
import 'package:atelier/blocs/widgets.dart';
import 'package:atelier/models/articleModel.dart';
import 'package:atelier/screens/home/providerPage.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:image_fade/image_fade.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:url_launcher/url_launcher.dart';

class FashionArticle extends StatefulWidget {
  Article article;
  FashionArticle({this.article});
  @override
  _FashionArticleState createState() => _FashionArticleState();
}

class _FashionArticleState extends State<FashionArticle> {
  bool more = false;
  ProgressDialog loading;
  TextEditingController _controller = TextEditingController();
  GlobalKey<ScaffoldState> scaffold = GlobalKey();
  initState() {
    super.initState();
    loading = ProgressDialog(context, type: ProgressDialogType.Normal);

    for (int i = 0; i < widget.article.images.length; i++)
      images.add(
                     FadeInImage(
                                    placeholder:AssetImage('assets/images/placeholder.gif'),
          image: NetworkImage(widget.article.images[i]),
          height: 350,
          fit: BoxFit.fill,
        ),
      );
    refreshComments();
    for (int i = 0; i < 3; i++) {
      if (allComments[i] != null) subComment.add(allComments[i]);
    }
  }

  refreshComments() {
    List<Widget> comments = [];
    for (int i = 0; i < widget.article.comments.length; i++) {
      comments.add(
        CommentWidget(
          comment: widget.article.comments[i],
        ),
      );
      setState(() {
        allComments = comments;
      });
    }
  }

  _launchCaller(String mobile) async {
    String url = "tel:$mobile";
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      scaffold.currentState.showSnackBar(SnackBar(
        content: Text("حاول مجدداً"),
      ));
    }
  }

  String comment;
  List<Widget> allComments = [];
  List<Widget> images = [];
  List<Widget> subComment = [];
  PageController controller = PageController(
    initialPage: 0,
  );
  @override
  Widget build(BuildContext context) {
    loading.style(
        progressWidget: LoadingFullScreen(),
        message: AppLocalizations.of(context).tr("comments.send"));

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
            child: SingleChildScrollView(
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                SmallIconButton(
                                  icon: Icons.arrow_back_ios,
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                                SizedBox()
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ), //images slider

                  //////////////////////////////////////////////////////////////////////////////////////
                  Container(
                    padding: EdgeInsets.only(left: 20, right: 20),
                    alignment: bloc.lang() == "ar"
                        ? Alignment.topRight
                        : Alignment.topLeft,
                    constraints:
                        BoxConstraints(minHeight: bloc.size().height / 2),
                    child: Stack(
                      overflow: Overflow.visible,
                      alignment: Alignment.bottomCenter,
                      children: <Widget>[
                        Column(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              widget.article.title ?? "",
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              height: 12,
                            ),
                            Wrap(
                              children: <Widget>[
                                Text(
                                  widget.article.note ?? "",
                                  style: TextStyle(
                                    fontSize: 16,
                                  ),
                                )
                              ],
                            ),
                            Container(
                              alignment: Alignment.topRight,
                              padding: EdgeInsets.all(20),
                              margin: EdgeInsets.only(top: 20),
                              width: bloc.size().width,
                              decoration: BoxDecoration(
                                  color: Colors.grey.withOpacity(.08),
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(25),
                                      topRight: Radius.circular(25))),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    AppLocalizations.of(context)
                                        .tr("comments.comments"),
                                    style: TextStyle(fontSize: 14, color: hint),
                                  ),

                                  //////// comments
                                  Column(
                                      children:
                                          more ? allComments : subComment),
                                  FlatButton(
                                      // highlightColor:
                                      //     bumbiAccent.withOpacity(.5),
                                      // splashColor: Colors.red[50],
                                      onPressed: () {
                                        setState(() {
                                          subComment.clear();
                                          for (int i = 0; i < 3; i++) {
                                            if (allComments[i] != null)
                                              subComment.add(allComments[i]);
                                          }
                                          more = !more;
                                        });
                                      },
                                      child: Text(
                                        more
                                            ? AppLocalizations.of(context)
                                                .tr("comments.less")
                                            : AppLocalizations.of(context)
                                                .tr("comments.more"),
                                      )),

                                  Text(
                                    AppLocalizations.of(context)
                                        .tr("comments.add"),
                                    style: TextStyle(fontSize: 14, color: hint),
                                  ),
                                  SizedBox(
                                    height: 6,
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(15)),
                                        color: Colors.white),
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 15),
                                    width: bloc.size().width,
                                    child: TextFormField(
                                      controller: _controller,
                                      onChanged: (v) {
                                        setState(() {
                                          comment = v;
                                        });
                                      },
                                      style: TextStyle(fontSize: 14),
                                      maxLines: 4,
                                      minLines: 1,
                                      cursorColor: bumbi,
                                      decoration: InputDecoration(
                                          border: InputBorder.none,
                                          hintText: AppLocalizations.of(context)
                                              .tr("comments.addHint"),
                                          hintStyle: TextStyle(fontSize: 14)),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Container(
                                      height: 40,
                                      width: bloc.size().width,
                                      child: Row(
                                        children: <Widget>[
                                          Expanded(child: SizedBox()),
                                          BumbiButton(
                                            text: AppLocalizations.of(context)
                                                .tr("comments.comment"),
                                            colored: true,
                                            onPressed: () async {
                                              if (comment != null &&
                                                  comment.isNotEmpty) {
                                                Comment newComment =
                                                    await addComment(
                                                        comment: comment,
                                                        id: widget.article.id
                                                            .toString(),
                                                        context: context,
                                                        loading: loading);
                                                setState(() {
                                                  comment = null;
                                                  allComments.add(CommentWidget(
                                                    comment: newComment,
                                                  ));
                                                  _controller.clear();
                                                  more = true;
                                                });
                                              }
                                            },
                                          )
                                        ],
                                      ))
                                ],
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class CommentWidget extends StatelessWidget {
  Comment comment;
  CommentWidget({this.comment});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.all(0),
      leading: ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          child: FadeInImage(
                                                                      placeholder:AssetImage('assets/images/placeholder.gif'),

            image:NetworkImage(comment.user.image))),
      title: Padding(
        padding: const EdgeInsets.only(top: 10),
        child: InkWell(
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) =>
                    ProviderPage(providerModel: comment.user)));
          },
          child: Text(
            comment.user.name ?? "",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
        ),
      ),
      subtitle: Text(
        comment.comment ?? "",
        style: TextStyle(fontSize: 14, color: blackAccent),
      ),
    );
  }
}
/*
 
                  
*/
