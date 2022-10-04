import 'package:chatapp/AudioRecordFolder/AudioRecorder.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:permission_handler/permission_handler.dart';
final pathtosaveaudio='audio_example_aac';
class SondRecorder
{
  FlutterSoundRecorder? _sundrecorder;
  bool _isRecorderInitilize=false;
  bool get isRecording=>_sundrecorder!.isRecording;
  Future init()async{
    _sundrecorder=FlutterSoundRecorder();
    final state=await Permission.microphone.request();
    if(state!=PermissionStatus.granted)
      {
        throw RecordingPermissionException('Microphone Permission');
      }
  await _sundrecorder!.openRecorder();
    _isRecorderInitilize=true;
  }
  void dispose(){
    if(_isRecorderInitilize)return;
    _sundrecorder!.closeRecorder();
    _sundrecorder=null;
    _isRecorderInitilize=false;
  }


  Future _recoder()async{
    if(_isRecorderInitilize)return;
    await _sundrecorder!.startRecorder(toFile: pathtosaveaudio);
  }
  Future _stop()async{
    if(_isRecorderInitilize)return;
    await _sundrecorder!.stopRecorder();
  }
  Future togglerRecording()async{
    if(_sundrecorder!.isStopped)
      {
        await _recoder();
      }
    else
      {
        await _stop();
      }
  }
}