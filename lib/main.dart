import 'dart:async';
import 'dart:io';
import 'video_recorder.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

void main() {
  runApp(new MaterialApp(
    title: "Video Recorder and Playback",
    home: new ChewieDemo(),
    debugShowCheckedModeBanner: false,
  ));
}

class ChewieDemo extends StatefulWidget {
  final String title;

  ChewieDemo({this.title = 'Chewie Demo'});

  @override
  State<StatefulWidget> createState() {
    return new _ChewieDemoState();
  }
}

class _ChewieDemoState extends State<ChewieDemo> {
  VideoPlayerController _controller;
  String _filePath = '';

  Future _goToNextScreen(BuildContext context) async{
    Map results = await Navigator.of(context).push(
        new MaterialPageRoute<Map>(
            builder: (BuildContext context) {
              return new CameraExampleHome();
            }
        )
    );
    if(results != null && results.containsKey("videoPath")){
        print(results["videoPath"]);
        _filePath = results["videoPath"];
        _controller = new VideoPlayerController.file(File(
            'file://$_filePath'));
    }else{
      _filePath = '';
    }
  }

  @override
  void initState() {
    super.initState();
    _controller = new VideoPlayerController.file(File(
                  'file://$_filePath'));
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(widget.title),
      ),
      body: _filePath == '' ? new Column() : new Column(children: <Widget>[
        new Expanded(
          child: new Center(
            child: new Chewie(
              _controller,
              aspectRatio: 3 / 3,
              autoPlay: false,
              looping: false,
              showControls: true,
              autoInitialize: true,
            ),
          ),
        ),
      ]),
      floatingActionButton: new FloatingActionButton(
          elevation: 0.0,
          child: new Icon(Icons.videocam),
          backgroundColor: new Color(0xFFE57373),
          onPressed: () {
            _controller.pause();
            _goToNextScreen(context);
          }),
    );
  }
}
