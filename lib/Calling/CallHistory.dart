import 'package:flutter/material.dart';

class CallHistory extends StatefulWidget {
  const CallHistory({Key? key}) : super(key: key);
  @override
  State<CallHistory> createState() => _CallHistoryState();
}
class _CallHistoryState extends State<CallHistory> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("No history found",style: TextStyle(fontSize: 18),)
        ],
      ),
    );
  }
}
