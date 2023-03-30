import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Loading extends StatelessWidget {
  const Loading({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      height: 30,
      width: 30,
      margin: const EdgeInsets.only(left: 0),
      child: Center(
        child: CircularProgressIndicator(
        color: Colors.white,
      ),
      )
    );
  }
}
