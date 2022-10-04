import 'dart:async';

import 'package:flutter/cupertino.dart';

class Timercontroller extends ValueNotifier<bool>
{

  Timercontroller({bool isPlaying=false}) : super(isPlaying);
  void startTimer()=>value=true;
  void stopTimer()=>value=false;
}
class TimerWidget extends StatefulWidget {
  final Timercontroller controller;
  const TimerWidget({Key? key,required this.controller}) : super(key: key);

  @override
  _TimerWidgetState createState() => _TimerWidgetState();
}

class _TimerWidgetState extends State<TimerWidget> {

 Duration duration=Duration();
 Timer? timer;
  void reset()=>setState(() {
    duration=Duration();
  });
  void addTime(){
    final addseconds=1;
    setState(() {
      final seconds=duration.inSeconds+addseconds;
      if(seconds<0)
        {
          timer?.cancel();
        }else{
        duration=Duration(seconds: seconds);
      }
    });
  }
  void startTimer({bool resets=true}){
    if(!mounted)return;
    if(resets)
      {
        reset();
      }
    timer=Timer.periodic(Duration(seconds: 1), (_)=>addTime());
  }
  void stopTimer({bool resets=true})
  {
    if(!mounted)return;
    if(resets)
      {
        reset();
      }
    setState(() {
      timer?.cancel();
    });
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    widget.controller.addListener(() {
      if(widget.controller.value)
        {
          startTimer();
        }else
          {
            startTimer();
          }
    });
  }
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
