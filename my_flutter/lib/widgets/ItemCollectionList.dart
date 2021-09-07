import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_boost/boost_navigator.dart';
import 'package:my_flutter/common/Constance.dart';
import 'package:my_flutter/models/CollectionArticleInfo.dart';

import 'LikeButtonWidget.dart';

class ItemCollectList extends StatefulWidget {
  Datas data;

  /// 收藏的回调函数
  Function onCollectCallback;

  ItemCollectList({required this.data, required this.onCollectCallback});

  @override
  _ItemCollectListState createState() => _ItemCollectListState();
}

class _ItemCollectListState extends State<ItemCollectList> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        padding: EdgeInsets.only(top: 7, right: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _text(widget.data.title!, Colors.black, 15),
            Row(
              children: [
                _text(widget.data.author!, Colors.black54, 13),
                _text(widget.data.niceDate!, Colors.black54, 13),
                _text(widget.data.chapterName!, Colors.black54, 13),
                Spacer(flex: 1),
                LikeButtonWidget(
                  isLike: 0 == widget.data.visible,
                  onClick: () {
                    widget.onCollectCallback();
                  },
                )
              ],
            )
          ],
        ),
      ),
      onTap: () {
        print(widget.data.link);
        BoostNavigator.instance.push(
          FLUTTER_PAGE_WEB, //required
          withContainer: false, //optional
          arguments: {"url": widget.data.link}, //optional
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
}
