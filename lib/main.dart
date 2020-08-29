import 'package:flutter/material.dart';
import 'utils/MusicPlayer.dart';
import 'utils/WalkDetector.dart';

typedef void OnError(Exception exception);

void main() {
  runApp(new MaterialApp(home: new WalkOrSilence()));
}

class WalkOrSilence extends StatefulWidget {
  @override
  _WalkOrSilenceState createState() => new _WalkOrSilenceState();
}

class _WalkOrSilenceState extends State<WalkOrSilence> {
  MusicPlayer musicPlayer = MusicPlayer();
  WalkDetector walkDetector = WalkDetector();

  @override
  void initState() {
    super.initState();
    // setState(() {
    //   musicPlayer.setDuration();
    //   musicPlayer.setPosition();
    // });
    // musicPlayer.subscribeToStatusStream();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("WalkOrSilence Demo")),
        body: Column(
          children: [
            FlatButton(onPressed: () => walkDetector.startRecording(), child: Text("Play"))
          ],
        ));
  }
}
