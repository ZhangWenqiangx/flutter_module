import 'package:flutter/material.dart';
import 'package:flutter_boost/boost_channel.dart';
import 'package:flutter_boost/boost_navigator.dart';
import 'package:my_flutter/utils/data_utils.dart';
import 'package:my_flutter/utils/http/api_response.dart';

class SingInPage extends StatefulWidget {
  const SingInPage({Key? key}) : super(key: key);

  @override
  _SingInPageState createState() => _SingInPageState();
}

class _SingInPageState extends State<SingInPage> {
  FocusNode emailFocusNode = new FocusNode();
  FocusNode passwordFocusNode = new FocusNode();
  FocusScopeNode focusScopeNode = new FocusScopeNode();
  GlobalKey<FormState> _signInFormKey = new GlobalKey();

  String username = '';
  String password = '';

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 23),
      child: Stack(
        alignment: Alignment.center,
        children: [
          new Column(
            children: [buildSignInTextForm()],
          ),
          Positioned(
            child: buildSignInButton(),
            top: 100,
            left: 245,
          ),
        ],
      ),
    );
  }

  Widget buildSignInTextForm() {
    return new Container(
      decoration: new BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          color: Colors.white),
      width: 280,
      height: 130,
      child: new Form(
        key: _signInFormKey,
        child: new Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Flexible(
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 25, right: 25, top: 0, bottom: 0),
                child: new TextFormField(
                  //关联焦点
                  focusNode: emailFocusNode,
                  onEditingComplete: () {
                    if (null == focusScopeNode) {
                      focusScopeNode = FocusScope.of(context);
                    }
                    focusScopeNode.requestFocus(passwordFocusNode);
                  },
                  decoration: new InputDecoration(
                      icon: new Icon(
                        Icons.person,
                        color: Colors.black,
                      ),
                      labelText: "用户名*",
                      hintText: "用户名或邮箱",
                      border: InputBorder.none),
                  style: new TextStyle(fontSize: 16, color: Colors.black),
                  //验证
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "用户名不能为空";
                    }
                  },
                  onSaved: (value) {
                    username = value!;
                  },
                ),
              ),
            ),
            new Container(
              height: 1,
              width: 230,
              color: Colors.grey[400],
            ),
            Flexible(
              child: Padding(
                padding: const EdgeInsets.only(left: 25, right: 25, top: 0),
                child: new TextFormField(
                  focusNode: passwordFocusNode,
                  decoration: new InputDecoration(
                    icon: new Icon(
                      Icons.lock,
                      color: Colors.black,
                    ),
                    labelText: "密码*",
                    hintText: "你的账号密码",
                    border: InputBorder.none,
                  ),
                  obscureText: true,
                  style: new TextStyle(fontSize: 16, color: Colors.black),
                  validator: (value) {
                    if (value == null || value.isEmpty || value.length < 6) {
                      return "密码不能少于6位";
                    }
                  },
                  onSaved: (value) {
                    password = value!;
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildSignInButton() {
    return Container(
      padding: EdgeInsets.only(left: 0, right: 0, top: 0, bottom: 0),
      child: SizedBox(
        width: 50,
        height: 50,
        child: ElevatedButton(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Colors.black87),
            shape: MaterialStateProperty.all(
                CircleBorder(side: BorderSide(color: Colors.black))),
          ),
          child: Icon(
            Icons.check,
            color: Colors.white,
          ),
          onPressed: () {
            if (_signInFormKey.currentState!.validate()) {
              dologin();
            }
          },
        ),
      ),
    );
  }

  void dologin() {
    _signInFormKey.currentState!.save();
    emailFocusNode.unfocus();
    passwordFocusNode.unfocus();

    DataUtils.doLogin(username, password).then((value) {
      if (value.status == Status.COMPLETED) {
        BoostChannel.instance.sendEventToNative("login_event", {"": ""});
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(value.data!.username!),
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
