import 'dart:async';

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
  var N = 32;
  var tmpList;
  var timer;

  @override
  void initState() {
    super.initState();
    // setState(() {
    //   musicPlayer.setDuration();
    //   musicPlayer.setPosition();
    // });
    // musicPlayer.subscribeToStatusStream();
  }

  void startRecording() {
    tmpList = new List<GyroscopeEvent>();
    GyroscopeEvent gyroscopeEvent;
    timer = Timer.periodic(Duration(milliseconds: 3), (timer) {
      gyroscopeEvents.listen((GyroscopeEvent event) {
        gyroscopeEvent = GyroscopeEvent(event.x, event.y, event.z);
      });
      if(tmpList.length < 32){
        if(gyroscopeEvent != null)
          tmpList.add(gyroscopeEvent);
      } else if(tmpList.length == 32){
        detectWalking();
      }
    });
  }

  void detectWalking() async {
    print(tmpList);
    if (tmpList.length == N) {
      for (var detection in tmpList) {
        var list = <double>[];
        list.add(detection.x);
        list.add(detection.y);
        list.add(detection.z);
        axes.add(list);
      }
      //Empty tmplist to continuosly collecting data
      tmpList.clear();

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

      print(mostSensitiveAxis.length);
      //Fast Fourier Transfotmation on the most sensitive axis
      var fft = FFT().Transform(mostSensitiveAxis);
      print('Fft: $fft');

      //Calculate frequency for every detection 0 to N-1
      for (var n = 0; n < N; n++) {
        var fn = (n - 1) * 10 / N;
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

      axes.clear();
    } else {
      print('not yet: ${tmpList.length}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("WalkOrSilence Demo")),
        body: Column(
          children: [
            FlatButton(onPressed: () => startRecording(), child: Text("Play"))
          ],
        ));
  }
}
