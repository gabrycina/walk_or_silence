import 'package:flutter/material.dart';
import 'utils/MusicPlayer.dart';
import 'package:sensors/sensors.dart';
import 'dart:math';
import 'package:fft/fft.dart';

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
  var axes = <List<double>>[];
  var N = 64;

  @override
  void initState() {
    super.initState();
    // setState(() {
    //   musicPlayer.setDuration();
    //   musicPlayer.setPosition();
    // });
    // musicPlayer.subscribeToStatusStream();
    //Fill axes matrix with detection's values
    gyroscopeEvents.listen((event) {
      if (axes.length != N) {
        print(event);
        var list = <double>[];
        list.add(event.x);
        list.add(event.y);
        list.add(event.z);
        axes.add(list);
        print(axes.length);
      }
    });
  }

  void detectWalking() async {
    print(axes.length);
    axes.clear();
    await new Future.delayed(const Duration(seconds: 20));
    if (axes.length >= N) {
      //Calculate the most sensitive axis
      var sumOfX = 0.0;
      var sumOfY = 0.0;
      var sumOfZ = 0.0;

      for (var item in axes) {
        sumOfX += item[0].abs();
        sumOfY += item[1].abs();
        sumOfZ += item[2].abs();
      }

      var maxAxis = max(max(sumOfX, sumOfY), sumOfZ);
      var mostSensitiveAxis = <double>[];

      if (maxAxis == sumOfX) {
        print('Most sensitive axis is x');
        for (var item in axes) {
          mostSensitiveAxis.add(item[0]);
        }
      } else if (maxAxis == sumOfY) {
        print('Most sensitive axis is y');
        for (var item in axes) {
          mostSensitiveAxis.add(item[1]);
        }
      } else if (maxAxis == sumOfZ) {
        print('Most sensitive axis is z');
        for (var item in axes) {
          mostSensitiveAxis.add(item[2]);
        }
      }

      //Fast Fourier Transfotmation on the most sensitive axis
      var fft = FFT().Transform(mostSensitiveAxis);
      print('Fft: $fft');

      //Calculate frequency for every detection 0 to N-1
      for (var n = 0; n < N; n++) {
        var fn = (n - 1) * 20 / N;
        print('n=$n and fn=$fn');
      }

      //Get real amplitudes from FFT complex number's list values
      var amplitudes = <double>[];
      for (var item in fft) {
        var newAmplitude = sqrt(pow(item.real, 2) + pow(item.imaginary, 2));
        amplitudes.add(newAmplitude);
      }
      print(amplitudes);

      var omegaC = ((amplitudes[3] +
              amplitudes[4] +
              amplitudes[5] +
              amplitudes[6] +
              amplitudes[7] +
              amplitudes[8]) /
          6);

      var omega0 = ((amplitudes[0] + amplitudes[1] + amplitudes[2]) / 3);

      print('omegaC = $omegaC');
      print('omega0 = $omega0');

      if (omegaC > omega0 && omegaC > 10) {
        print('is walking');
      } else {
        print('he is not');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("WalkOrSilence Demo")),
        body: Column(
          children: [
            FlatButton(onPressed: () => detectWalking(), child: Text("Play"))
          ],
        ));
  }
}

// StreamBuilder(
//   stream: gyroscopeEvents,
//   builder: (BuildContext context, AsyncSnapshot snapshot) {
//     if (snapshot.connectionState == ConnectionState.active)
//       return Container(
//         child: Text(snapshot.data.toString()),
//       );
//     else
//       return Container(
//         child: Text('not active yet'),
//       );
//   },
// ),

// StreamBuilder(
//     stream: musicPlayer.getPedestrianStatusStream(),
//     builder: (context, snapshot) {
//       if (snapshot.connectionState == ConnectionState.waiting) {
//         return Text("No data yet");
//       } else if (snapshot.connectionState ==
//           ConnectionState.active) {
//         return Text(musicPlayer.getStatus());
//       } else if (snapshot.hasError) {
//         return Text('Error!');
//       }
//     }),
