import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:pedometer/pedometer.dart';

class MusicPlayer {
  AudioPlayer advancedPlayer;
  AudioCache audioCache;
  Stream<PedestrianStatus> _pedestrianStatusStream;
  Duration _duration = new Duration();
  Duration _position = new Duration();
  String _status = '?';

  MusicPlayer() {
    advancedPlayer = new AudioPlayer();
    audioCache = new AudioCache(fixedPlayer: advancedPlayer);
  }

  //Setters
  void setDuration() {
    advancedPlayer.durationHandler = (d) => _duration = d;
  }

  void setPosition() {
    advancedPlayer.positionHandler = (p) => _duration = p;
  }

  //Getters
  Stream<PedestrianStatus> getPedestrianStatusStream() {
    return _pedestrianStatusStream;
  }

  String getStatus() {
    return _status;
  }

  //Functions
  subscribeToStatusStream() async {
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
  }

  void onPedestrianStatusError(error) {
    /// Handle the error
    print(error);
  }

  void onStepCountError(error) {
    /// Handle the error
    print(error);
  }
}
