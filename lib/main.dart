import 'package:flutter/material.dart';
import 'utils/MusicPlayer.dart';

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

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("WalkOrSilence Demo")),
        body: Column(
          children: [
            FlatButton(onPressed: () => musicPlayer.subscribeToStatusStream(), child: Text("Play")),
            FlatButton(onPressed: () => musicPlayer.pauseStatusStream(), child: Text("Pause"))
          ],
        ));
  }
}
