import 'package:flutter/material.dart';
import 'package:flutter_boost/boost_navigator.dart';
import 'package:my_flutter/models/CoinListInfo.dart';
import 'package:my_flutter/utils/data_utils.dart';
import 'package:my_flutter/utils/http/api_response.dart';

class CoinPage extends StatefulWidget {
  final Map? params;

  CoinPage({this.params});

  @override
  _CoinPage createState() => _CoinPage();
}

class _CoinPage extends State<CoinPage> {
  var _page = 1;
  bool loading = true;
  List mDatas = <Datas>[];
  var _total;
  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    this.scrollController.addListener(() {
      if (scrollController.position.pixels >=
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
        actions: [
          IconButton(
            icon: Icon(Icons.help_rounded),
            onPressed: () {},
          ),
        ],
        title: Text('积分明细'),
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Container(
              height: 120,
              color: Colors.blue,
              child: Center(
                child: Text(
                  widget.params!['coinCount'].toString().isEmpty
                      ? "----"
                      : widget.params!['coinCount'],
                  textScaleFactor: 1.5,
                  style: TextStyle(color: Colors.white, fontSize: 30),
                ),
              ),
            ),
          ),
          SliverFillRemaining(
            child: _buildContent(),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    if (loading) {
      return _loadMoreWidget();
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
              return _noMoreWidget();
            } else if (index == mDatas.length - 1) {
              return _loadMoreWidget();
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

  Widget _noMoreWidget() {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: new Center(child: Text("我也是有底线的~",style: TextStyle(color: Colors.black45),)),
    );
  }

  Widget _loadMoreWidget() {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: new Center(child: new CircularProgressIndicator()),
    );
  }

  Widget buildItem(Datas data) {
    return SizedBox(
        height: 70,
        child: Padding(
          padding: EdgeInsets.only(left: 10, right: 10, top: 15),
          child: Row(
            children: [
              Expanded(
                flex: 8,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                        flex: 1,
                        child: Text(
                          data.reason!,
                          style: TextStyle(color: Colors.black, fontSize: 15),
                        )),
                    Expanded(
                        flex: 1,
                        child: Text(
                          data.desc!,
                          style: TextStyle(color: Colors.black54, fontSize: 14),
                        ))
                  ],
                ),
              ),
              Expanded(
                  flex: 1,
                  child: Center(
                    child: Text(
                      checkText(data.coinCount),
                      style: TextStyle(color: checkColor(data.coinCount)),
                    ),
                  ))
            ],
          ),
        ));
  }

  Color checkColor(int? str) {
    var result = str?.toString();
    if (result!.startsWith("-")) {
      return Colors.red;
    } else {
      return Colors.blue;
    }
  }

  String checkText(int? str) {
    var result = str?.toString();
    if (result!.startsWith("-")) {
      return result;
    } else {
      return "+$result";
    }
  }

  void _onLoadMore() {
    _page++;
    getCoinList();
  }

  void _onRefresh() {
    _page = 1;
    mDatas.clear();
    getCoinList();
  }

  void getCoinList() {
    DataUtils.getUserCoinList(_page).then((value) {
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

  @override
  void dispose() {
    super.dispose();
    scrollController.dispose();
  }
}
