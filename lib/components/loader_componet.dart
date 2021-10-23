import 'package:flutter/material.dart';

class loaderComponent extends StatelessWidget {
  final String text;

  loaderComponent({this.text=''});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 200,
        height: 120,
        decoration: BoxDecoration(
          color: Colors.green[300],
          borderRadius: BorderRadius.circular(10)
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 20,),
            Text(text, style: TextStyle(fontSize: 20),),
          ],
        ),
      ),
    );
  }
}