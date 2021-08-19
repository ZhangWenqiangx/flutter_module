import 'package:flutter/material.dart';

class SingOutPage extends StatefulWidget {
  const SingOutPage({Key? key}) : super(key: key);

  @override
  _SingOutPageState createState() => _SingOutPageState();
}

class _SingOutPageState extends State<SingOutPage> {
  @override
  Widget build(BuildContext context) {
    return new Container(
        padding: EdgeInsets.only(top: 23),
        child: new Column(
          children: <Widget>[
            new Container(
                decoration: new BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                  color: Colors.white,
                ),
                width: 300,
                height: 200,
                child: buildSignUpTextForm()),
            buildTextButton("NEXT")
          ],
        ));
  }

  Widget buildSignUpTextForm() {
    return new Form(
        child: new Column(
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        //用户名字
        Expanded(
          child: Padding(
            padding:
                const EdgeInsets.only(left: 25, right: 25, top: 0, bottom: 0),
            child: new TextFormField(
              decoration: new InputDecoration(
                  icon: new Icon(
                    Icons.person,
                    color: Colors.black,
                  ),
                  hintText: "Name",
                  border: InputBorder.none),
              style: new TextStyle(fontSize: 16, color: Colors.black),
            ),
          ),
        ),
        new Container(
          height: 1,
          width: 250,
          color: Colors.grey[400],
        ),
        //邮箱
        Expanded(
          child: Padding(
            padding:
                const EdgeInsets.only(left: 25, right: 25, top: 0, bottom: 0),
            child: new TextFormField(
              decoration: new InputDecoration(
                  icon: new Icon(
                    Icons.email,
                    color: Colors.black,
                  ),
                  hintText: "Email Address",
                  border: InputBorder.none),
              style: new TextStyle(fontSize: 16, color: Colors.black),
            ),
          ),
        ),
        new Container(
          height: 1,
          width: 250,
          color: Colors.grey[400],
        ),
        //密码
        Expanded(
          child: Padding(
            padding:
                const EdgeInsets.only(left: 25, right: 25, top: 0, bottom: 0),
            child: new TextFormField(
              decoration: new InputDecoration(
                icon: new Icon(
                  Icons.lock,
                  color: Colors.black,
                ),
                hintText: "Password",
                border: InputBorder.none,
                suffixIcon: new IconButton(
                    icon: new Icon(
                      Icons.remove_red_eye,
                      color: Colors.black,
                    ),
                    onPressed: () {}),
              ),
              obscureText: true,
              style: new TextStyle(fontSize: 16, color: Colors.black),
            ),
          ),
        ),
        new Container(
          height: 1,
          width: 250,
          color: Colors.grey[400],
        ),

        Expanded(
          child: Padding(
            padding:
                const EdgeInsets.only(left: 25, right: 25, top: 0, bottom: 0),
            child: new TextFormField(
              decoration: new InputDecoration(
                icon: new Icon(
                  Icons.lock,
                  color: Colors.black,
                ),
                hintText: "Confirm Passowrd",
                border: InputBorder.none,
                suffixIcon: new IconButton(
                    icon: new Icon(
                      Icons.remove_red_eye,
                      color: Colors.black,
                    ),
                    onPressed: () {}),
              ),
              obscureText: true,
              style: new TextStyle(fontSize: 16, color: Colors.black),
            ),
          ),
        ),
      ],
    ));
  }

  /// build Text Button
  /// @param page ->position
  Widget buildTextButton(String data) {
    return Padding(
      padding: EdgeInsets.only(top: 25),
      child: Container(
        decoration: BoxDecoration(
            borderRadius:BorderRadius.circular(25.0),
            gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [Colors.white, Colors.white])),
        child: SizedBox(
          height: 50,
          width: 150,
          child: TextButton(
            style: ButtonStyle(
              shape: MaterialStateProperty.all(RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25.0))),
            ),
            child: Text(data,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.blue,
                )),
            onPressed: () {},
          ),
        ),
      ),
    );
  }
}
