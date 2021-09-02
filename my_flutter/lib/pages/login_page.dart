import 'package:flutter/material.dart';
import 'package:my_flutter/pages/signin_page.dart';
import 'package:my_flutter/pages/signout_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  int _currentPage = 0;
  PageView? _pageView;
  PageController? _pageController;

  @override
  void initState() {
    _pageController =
        new PageController(initialPage: 0, viewportFraction: 0.85);
    _pageView = new PageView(
      controller: _pageController,
      children: <Widget>[
        new SingInPage(),
        new SingOutPage(),
      ],
      onPageChanged: (index) {
        setState(() {
          _currentPage = index;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Colors.lightBlueAccent, Colors.blueAccent])),
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            //头部 图片 Logo
            Padding(
              padding: EdgeInsets.only(top: 65, bottom: 20),
              child: Image(
                width: 180,
                height: 160,
                image: AssetImage("./assets/imgs/nothing.png"),
              ),
            ),
            //中间切换状态
            new Container(
              width: 300,
              height: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(25)),
                color: Color(0x552B2B2B),
              ),
              child: new Row(
                children: <Widget>[
                  buildTextButton(0, "Sign in"),
                  buildTextButton(1, "Sign up")
                ],
              ),
            ),
            //登录/注册page
            new Expanded(child: _pageView!),
          ],
        ),
      ),
    ));
  }

  /// build Text Button
  /// @param page ->position
  Widget buildTextButton(int page, String data) {
    return Expanded(
        child: SizedBox(
      height: 50,
      child: TextButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(
              _currentPage == page ? Colors.white : null),
          shape: MaterialStateProperty.all(RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25.0))),
        ),
        child: Text(data,
            style: TextStyle(
              fontSize: 16,
              color: _currentPage == page ? Colors.blue : Colors.white60,
            )),
        onPressed: () {
          _pageController?.animateToPage(page,
              duration: Duration(milliseconds: 300), curve: Curves.decelerate);
        },
      ),
    ));
  }
}
