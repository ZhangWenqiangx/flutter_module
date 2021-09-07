import 'package:flutter/material.dart';
import 'package:flutter_boost/boost_navigator.dart';
import 'package:my_flutter/common/Constance.dart';
import 'package:my_flutter/models/ShareArticleInfo.dart';
import 'package:my_flutter/utils/data_utils.dart';
import 'package:my_flutter/utils/http/api_response.dart';
import 'package:my_flutter/widgets/LoadMore.dart';
import 'package:my_flutter/widgets/NoMore.dart';

class MySharePage extends StatefulWidget {
  @override
  _MySharePage createState() => _MySharePage();
}

class _MySharePage extends State<MySharePage> {
  var _page = 1;
  bool loading = true;
  List mDatas = <Datas>[];
  var _total;
  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
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
        title: Text('我的分享'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {},
          ),
        ],
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
              return buildItem(mDatas[index]);
            }
          },
          separatorBuilder: (BuildContext context, int index) => Divider(
            height: 5,
          ),
        ),
      );
    }
  }

  Widget buildItem(Datas data) {
    return GestureDetector(
      child: SizedBox(
          height: 60,
          child: Padding(
            padding: EdgeInsets.only(top: 7, bottom: 7),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _textExpand(1, data.title!, Colors.black, 15),
                Expanded(
                    child: Flex(
                  direction: Axis.horizontal,
                  children: [
                    _text(data.shareUser!, Colors.black54, 13),
                    _text(data.niceDate!, Colors.black54, 13),
                    _text(data.superChapterName! + "/" + data.chapterName!,
                        Colors.black54, 13),
                  ],
                )),
              ],
            ),
          )),
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

  Widget _text(String text, Color color, double fontSize) {
    return Padding(
      padding: EdgeInsets.only(left: 15),
      child: Text(
        text,
        style: TextStyle(color: color, fontSize: fontSize),
      ),
    );
  }

  Widget _textExpand(int? flex, String text, Color color, double fontSize) {
    return Padding(
      padding: EdgeInsets.only(left: 15),
      child: Expanded(
        flex: flex == null ? 1 : flex,
        child: Text(
          text,
          style: TextStyle(color: color, fontSize: fontSize),
        ),
      ),
    );
  }

  void _onLoadMore() {
    _page++;
    getData();
  }

  void _onRefresh() {
    _page = 1;
    mDatas.clear();
    getData();
  }

  void getData() {
    DataUtils.getShareArticles(_page).then((value) {
      if (loading) {
        setState(() {
          loading = false;
        });
      }
      if (value.status == Status.COMPLETED) {
        var articles = value.data!.shareArticles!;
        _total = articles.datas!.length;
        setState(() {
          mDatas.addAll(articles.datas!);
        });
      } else {
        setState(() {});
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
