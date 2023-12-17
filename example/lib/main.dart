import 'package:flutter/material.dart';
import 'package:flutter_line/flutter_line.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  Widget dialog(BuildContext context) {
    var title = const Padding(
      padding: EdgeInsets.all(10),
      child: Text('title',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
    );
    var message = const Padding(
      padding: EdgeInsets.all(10),
      child: Text('message', style: TextStyle(fontSize: 16)),
    );

    var cancel = const Padding(
        padding: EdgeInsets.all(10),
        child: Text(
          'cancel',
          textAlign: TextAlign.center,
        ));
    var confirm = const Padding(
        padding: EdgeInsets.all(10),
        child: Text(
          'confirm',
          textAlign: TextAlign.center,
        ));

    return Container(
      margin: const EdgeInsets.all(60),
      decoration: BoxDecoration(
        color: const Color(0xfff0f0f0),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          title,
          message,
          const Line(
            axis: Axis.horizontal,
            color: Colors.redAccent,
            thickness: 4,
          ),
          Row(
            children: [
              Expanded(child: cancel),
              const Line(
                axis: Axis.vertical,
                color: Colors.blueAccent,
                thickness: 4,
              ),
              Expanded(child: confirm),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('flutter_line'),
        ),
        body: Center(
          child: dialog(context),
        ),
      ),
    );
  }
}
