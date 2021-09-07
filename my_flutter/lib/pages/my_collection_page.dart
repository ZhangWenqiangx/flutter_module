import 'package:flutter/material.dart';
import 'package:flutter_boost/boost_navigator.dart';
import 'package:my_flutter/models/CollectionArticleInfo.dart';
import 'package:my_flutter/utils/data_utils.dart';
import 'package:my_flutter/utils/http/api_response.dart';
import 'package:my_flutter/widgets/ItemCollectionList.dart';
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
    return ItemCollectList(
      data: data,
      onCollectCallback: () {
        setState(() {
          unCollect(index, data.id!, data.originId!);
        });
      },
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
        setState(() {
          mDatas.removeAt(index);
          _total = mDatas.length;
        });
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("删除成功"),
        ));
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
