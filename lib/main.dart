import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pedometer/pedometer.dart';
import 'dart:async';

typedef void OnError(Exception exception);

void main() {
  runApp(new MaterialApp(home: new WalkOrSilence()));
}

class WalkOrSilence extends StatefulWidget {
  @override
  _WalkOrSilenceState createState() => new _WalkOrSilenceState();
}

class _WalkOrSilenceState extends State<WalkOrSilence> {
  AudioPlayer advancedPlayer;
  AudioCache audioCache;

  Duration _duration = new Duration();
  Duration _position = new Duration();

  //Status: walking, stopped, unknown
  Stream<PedestrianStatus> _pedestrianStatusStream;
  String _status = '?';

  bool _connectedToSpotify;

  String localFilePath;

  @override
  void initState() {
    super.initState();
    initPlayer();
    initPlatformState();
  }

  void initPlayer() {
    advancedPlayer = new AudioPlayer();
    audioCache = new AudioCache(fixedPlayer: advancedPlayer);

    advancedPlayer.durationHandler = (d) => setState(() {
          _duration = d;
        });

    advancedPlayer.positionHandler = (p) => setState(() {
          _position = p;
        });
  }

  Future<void> initPlatformState() async {
    /// Init stream
    _pedestrianStatusStream = await Pedometer.pedestrianStatusStream;
    _pedestrianStatusStream
        .listen(onPedestrianStatusChanged)
        .onError(onPedestrianStatusError);
  }

  void seekToSecond(int second) {
    Duration newDuration = Duration(seconds: second);
    advancedPlayer.seek(newDuration);
  }

  void onPedestrianStatusChanged(PedestrianStatus event) {
    // Handle status changed
    _status = event.status;

    if (_status == 'walking')
      audioCache.play('audio.mp3');
    else if (_status == 'stopped') advancedPlayer.pause();

    DateTime timeStamp = event.timeStamp;
  }

  void onPedestrianStatusError(error) {
    /// Handle the error
    print(error);
  }

  void onStepCountError(error) {
    /// Handle the error
    print(error);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("WalkOrSilence Demo")),
        body: Column(
          children: [
            StreamBuilder(
                stream: _pedestrianStatusStream,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Text("No data yet");
                  } else if (snapshot.connectionState == ConnectionState.done) {
                    return Text('Done!');
                  } else if (snapshot.hasError) {
                    return Text('Error!');
                  } else {
                    return Text(snapshot.data.toString() ?? '');
                  }
                }),
          ],
        ));
  }
}
