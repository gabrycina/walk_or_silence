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
    setState(() {
      musicPlayer.setDuration();
      musicPlayer.setPosition();
    });
    musicPlayer.subscribeToStatusStream();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("WalkOrSilence Demo")),
        body: Column(
          children: [
            StreamBuilder(
                stream: musicPlayer.getPedestrianStatusStream(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Text("No data yet");
                  } else if (snapshot.connectionState ==
                      ConnectionState.active) {
                    return Text(musicPlayer.getStatus());
                  } else if (snapshot.hasError) {
                    return Text('Error!');
                  }
                }),
          ],
        ));
  }
}
