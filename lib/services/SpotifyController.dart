import 'package:spotify_auth_player/spotify_auth_player.dart';

class SpotifyController {
  SpotifyController() {
    connection();
  }

  void connection() async {
    await Spotifire.init(clientid: "122d3f79c9684799ac7b597d77b3213f");
    await Spotifire.connectRemote.then(print);
  }

  void play() async {
    if (await Spotifire.isRemoteConnected) {
      print("remote connected");
      await Spotifire.playPlaylist(
          playlistUri: "spotify:playlist:37i9dQZF1DX3rxVfibe1L0");
      print("played");
    }
  }

  void pause() async {
    await Spotifire.pauseMusic;
    print("paused");
  }

  void resume() async {
    await Spotifire.resumeMusic;
    print("resumed");
  }
}
