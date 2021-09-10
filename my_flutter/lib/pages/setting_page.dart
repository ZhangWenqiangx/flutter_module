import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_boost/boost_channel.dart';
import 'package:flutter_boost/boost_navigator.dart';
import 'package:my_flutter/utils/data_utils.dart';
import 'package:my_flutter/utils/http/api_response.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({Key? key}) : super(key: key);

  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.4,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            BoostNavigator.instance.pop("");
          },
        ),
        title: Text('设置'),
      ),
      body: ListView(
        children: <Widget>[
          new ListTile(
            trailing: Icon(Icons.chevron_right),
            title: new Row(
              children: <Widget>[
                Icon(Icons.login_outlined,
                    color: Theme.of(context).primaryColor),
                Padding(
                  padding: EdgeInsets.only(left: 10.0),
                  child: Text('退出登录'),
                )
              ],
            ),
            onTap: () {
              showDialog(context: context, builder: (context) => AlertDialog(
                  title: Text('提示'),
                  content: Text(('确定要退出登录吗?')),
                  actions: <Widget>[
                    new TextButton(
                      child: new Text("取消"),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    new TextButton(
                      child: new Text("确定"),
                      onPressed: () {
                        logout();
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
              ));
            },
          ),
        ],
      ),
    );
  }

  void logout(){
    DataUtils.logout().then((value) {
      if (value.status == Status.COMPLETED) {
        BoostChannel.instance.sendEventToNative("login_event", {"flutter_event_type": "type_logout"});
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("退出成功"),
        ));
        BoostNavigator.instance.pop("");
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(value.exception!.message!),
        ));
      }
    });
  }
}
