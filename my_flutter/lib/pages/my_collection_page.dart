import 'package:flutter/material.dart';
import 'package:flutter_boost/boost_navigator.dart';
import 'package:my_flutter/common/Constance.dart';
import 'package:my_flutter/models/CollectionArticleInfo.dart';
import 'package:my_flutter/utils/data_utils.dart';
import 'package:my_flutter/utils/http/api_response.dart';
import 'package:my_flutter/widgets/LoadMore.dart';
import 'package:my_flutter/widgets/NoMore.dart';

class MyCollectionPage extends StatefulWidget {
  @override
  _CollectionPage createState() => _CollectionPage();
}

class _CollectionPage extends State<MyCollectionPage>
    with SingleTickerProviderStateMixin {
  var _page = 0;
  var _total;
  bool loading = true;
  List mDatas = <Datas>[];
  ScrollController scrollController = ScrollController();

  static const Icon _unLikeIcon = Icon(
    IconData(0xe8bc, fontFamily: 'myIcon'),
    color: Colors.black,
    size: 20,
  );
  static const Icon _likeIcon =
      Icon(IconData(0xe620, fontFamily: 'myIcon'), color: Colors.red, size: 20);
  late AnimationController _animationController;
  late Animation<double> _iconAnimation;

  @override
  void initState() {
    super.initState();
    _animationController =
        AnimationController(duration: Duration(milliseconds: 300), vsync: this);

    _iconAnimation = Tween(begin: 1.0, end: 1.3).animate(_animationController);

    _iconAnimation = TweenSequence([
      TweenSequenceItem(
          tween: Tween(begin: 1.0, end: 1.3)
              .chain(CurveTween(curve: Curves.easeIn)),
          weight: 50),
      TweenSequenceItem(tween: Tween(begin: 1.3, end: 1.0), weight: 50),
    ]).animate(_animationController);

    this.scrollController.addListener(() {
      if (mDatas.length < _total &&
          scrollController.position.pixels >=
              scrollController.position.maxScrollExtent) {
        _onLoadMore();
      }
    });
    _onRefresh();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            BoostNavigator.instance.pop("");
          },
        ),
        title: Text('我的收藏'),
      ),
      body: CustomScrollView(
        slivers: [
          SliverFillRemaining(
            child: _buildContent(),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    if (loading) {
      return LoadMore();
    } else {
      return RefreshIndicator(
        onRefresh: () {
          _onRefresh();
          return Future.delayed(Duration(seconds: 1), () {});
        },
        child: ListView.separated(
          controller: scrollController,
          itemCount: mDatas.length,
          itemBuilder: (BuildContext context, int index) {
            if (index >= _total - 1) {
              return NoMore();
            } else if (index == mDatas.length - 1) {
              return LoadMore();
            } else {
              return buildItem(index);
            }
          },
          separatorBuilder: (BuildContext context, int index) => Divider(
            height: 5,
          ),
        ),
      );
    }
  }

  Widget buildItem(int index) {
    Datas data = mDatas[index];
    return GestureDetector(
      child: Container(
        padding: EdgeInsets.only(top: 7, right: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _text(data.title!, Colors.black, 15),
            Row(
              children: [
                _text(data.author!, Colors.black54, 13),
                _text(data.niceDate!, Colors.black54, 13),
                _text(data.chapterName!, Colors.black54, 13),
                Spacer(flex: 1),
                _checkIcon(data.visible!, index)
              ],
            )
          ],
        ),
      ),
      onTap: () {
        print(data.link);
        BoostNavigator.instance.push(
          FLUTTER_PAGE_WEB, //required
          withContainer: false, //optional
          arguments: {"url": data.link}, //optional
          opaque: true, //optional,default value is true
        );
      },
    );
  }

  Widget _checkIcon(int flag, int index) {
    Datas data = mDatas[index];
    return ScaleTransition(scale: _iconAnimation,child: IconButton(
      icon: 0 == flag ? _likeIcon : _unLikeIcon,
      onPressed: () {
        unCollect(index, data.id!, data.originId!);
      },
    ),);
  }

  Widget _text(String text, Color color, double fontSize) {
    return Padding(
      padding: EdgeInsets.only(left: 15),
      child: Text(
        text,
        style: TextStyle(color: color, fontSize: fontSize),
      ),
    );
  }

  void _onLoadMore() {
    _page++;
    getData();
  }

  void _onRefresh() {
    _page = 0;
    mDatas.clear();
    getData();
  }

  void getData() {
    DataUtils.getCollectionArticles(_page).then((value) {
      if (loading) {
        setState(() {
          loading = false;
        });
      }
      if (value.status == Status.COMPLETED) {
        _total = value.data!.total;
        setState(() {
          mDatas.addAll(value.data!.datas!);
        });
      } else {
        setState(() {});
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(value.exception!.message!),
        ));
      }
    });
  }

  void unCollect(int index, int id, int orgId) {
    DataUtils.unCollect(id, orgId).then((value) {
      if (value.status == Status.COMPLETED) {
        if (_iconAnimation.status == AnimationStatus.forward ||
            _iconAnimation.status == AnimationStatus.reverse) {
          return;
        }
        setState(() {
          mDatas.removeAt(index);
          _total = mDatas.length;
        });
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("删除成功"),
        ));
        // if (_iconAnimation.status == AnimationStatus.dismissed) {
        //   _animationController.forward();
        // } else if (_iconAnimation.status == AnimationStatus.completed) {
        //   _animationController.reverse();
        // }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(value.exception!.message!),
        ));
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    scrollController.dispose();
  }
}
