import 'package:flutter/material.dart';
import 'package:personal_finance/shared/styles.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Container(
        color: Backgrounds.pageBackground,
        child: Column(
          children: [],
        ));
  }
}
