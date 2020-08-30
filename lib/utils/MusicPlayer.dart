import 'dart:async';
import 'WalkDetector.dart';
import 'package:walk_or_silence/services/SpotifyController.dart';

class MusicPlayer {
  String _status = 'stopped';
  SpotifyController spotifyController;
  var walkDetector = WalkDetector();
  StreamSubscription<String> subscription;

  String get getStatus => _status;

  //Functions
  subscribeToStatusStream() async {
    spotifyController = SpotifyController();

    Future.delayed(Duration(seconds: 3), () {
      //Connection to status stream
      var statusStream = walkDetector.startRecording();
      subscription = statusStream.listen(onWalkingStatusChanged);
    });
  }

  pauseStatusStream() async {
    subscription.pause();
    pause();
  }

  play() {
    spotifyController.play();
  }

  pause() {
    spotifyController.pause();
  }

  resume() {
    spotifyController.resume();
  }

  //TODO resume, seekTo, skipNext and skipPrevious

  onWalkingStatusChanged(newStatus) {
    print(_status);
    print(newStatus);

    // Handle status changed
    if (_status == 'stopped' && newStatus == 'walking') {
      resume();
    } else if (_status == 'walking' && newStatus == 'stopped') {
      pause();
    }
    _status = newStatus;
  }

  onWalkingStatusError(error) {
    print(error);
  }

//TODO: Rewrite seekToSecond
//TODO: Rewrite setDuration and setPosition
}
