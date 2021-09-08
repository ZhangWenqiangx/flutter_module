import 'package:flutter/material.dart';
import 'package:flutter_boost/boost_navigator.dart';
import 'package:my_flutter/models/CoinRankInfo.dart';
import 'package:my_flutter/utils/data_utils.dart';
import 'package:my_flutter/utils/http/api_response.dart';
import 'package:my_flutter/widgets/linear_progress_indicator.dart';
import 'package:my_flutter/widgets/load_more.dart';
import 'package:my_flutter/widgets/no_more.dart';

class CoinRankPage extends StatefulWidget {
  @override
  _CoinRankPage createState() => _CoinRankPage();
}

class _CoinRankPage extends State<CoinRankPage> {
  var _page = 1;
  bool loading = true;
  int maxValue = 0;
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
        title: Text('积分排行'),
      ),
      body: _buildContent(),
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
          addAutomaticKeepAlives: true,
          itemCount: mDatas.length,
          itemBuilder: (BuildContext context, int index) {
            if (index >= _total - 1) {
              return NoMore();
            } else if (index == mDatas.length - 1) {
              return LoadMore();
            } else {
              return buildItem(mDatas[index], index);
            }
          },
          separatorBuilder: (BuildContext context, int index) => Divider(
            height: 1,
          ),
        ),
      );
    }
  }

  Widget buildItem(Datas data, int index) {
    GlobalObjectKey<LineProgressIndicatorState> refreshKey =
        GlobalObjectKey<LineProgressIndicatorState>(index);
    return SizedBox(
        height: 45,
        child: Stack(fit: StackFit.expand, children: [
          LineProgressIndicator(
              key: refreshKey, maxValue: data.coinCount! / maxValue),
          Padding(
            padding: EdgeInsets.only(left: 20),
            child: Row(
              children: [
                Expanded(
                    flex: 1,
                    child: Text(
                      data.rank!,
                      style: TextStyle(color: Colors.black38, fontSize: 15),
                    )),
                Expanded(
                    flex: 7,
                    child: Text(
                      data.username!,
                      style: TextStyle(color: Colors.black, fontSize: 15),
                    )),
                Expanded(
                  flex: 2,
                  child: Text(
                    data.coinCount.toString(),
                    style: TextStyle(color: Color(0xFFF37D20)),
                  ),
                )
              ],
            ),
          )
        ]));
  }

  void _onLoadMore() {
    _page++;
    getCoinRank();
  }

  void _onRefresh() {
    _page = 1;
    mDatas.clear();
    getCoinRank();
  }

  void getCoinRank() {
    DataUtils.getCoinRank(_page).then((value) {
      if (loading) {
        setState(() {
          maxValue = value.data!.datas![0].coinCount!;
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
