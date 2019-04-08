import 'package:flutter/material.dart';
import 'package:provide/provide.dart';
import '../provide/counter.dart';

class CartPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: <Widget>[Number(), AddBtn()],
        ),
      ),
    );
  }
}

class Number extends StatefulWidget {
  _NumberState createState() => _NumberState();
}

class _NumberState extends State<Number> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 80.0),
      child: Provide<Counter>(
        builder: (context, child, counter) {
          return Text(
            "${counter.value}",
            style: Theme.of(context).textTheme.display1,
          );
        },
      ),
    );
  }
}

class AddBtn extends StatefulWidget {
  _AddBtnState createState() => _AddBtnState();
}

class _AddBtnState extends State<AddBtn> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: RaisedButton(
        onPressed: () {
          Provide.value<Counter>(context).increment();
        },
        child: Text("增量"),
      ),
    );
  }
}
