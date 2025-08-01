// @dart=2.9

import 'package:flutter/material.dart';

class TemplatePopay extends StatefulWidget {
  final Widget body;
  final String title;
  final double height;
  final List<Widget> children;
  final Color backgroundColor;
  final FloatingActionButton floatingActionButton;
  final FloatingActionButtonLocation floatingActionButtonLocation;

  TemplatePopay(
      {this.title,
      this.body,
      this.height,
      this.children,
      this.backgroundColor,
      this.floatingActionButton,
      this.floatingActionButtonLocation});

  @override
  _TemplatePopayState createState() => _TemplatePopayState();
}

class _TemplatePopayState extends State<TemplatePopay> {
  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.white,
        child: Stack(children: <Widget>[
          Container(
            height: 200.0,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
            ),
          ),
          Scaffold(
              backgroundColor: Colors.transparent,
              resizeToAvoidBottomInset: true,
              appBar: AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0.0,
                title: Text('Profile'),
              ),
              body: widget.body)
        ]));
  }
}
