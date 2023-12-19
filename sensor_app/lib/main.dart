import 'package:flutter/material.dart';
import 'package:sensors/sensors.dart';
import 'package:geolocator/geolocator.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SensorDisplay(),
    );
  }
}

class SensorDisplay extends StatefulWidget {
  @override
  _SensorDisplayState createState() => _SensorDisplayState();
}

class _SensorDisplayState extends State<SensorDisplay> {
  double _accelerometerX = 0.0;
  double _accelerometerY = 0.0;
  double _accelerometerZ = 0.0;

  double _gyroscopeX = 0.0;
  double _gyroscopeY = 0.0;
  double _gyroscopeZ = 0.0;

  double _latitude = 0.0;
  double _longitude = 0.0;

  bool _isListening = false;

  var gyroscopeSubscription;
  var accelerometerSubscription;
  var locationSubscription;

  @override
  void initState() {
    super.initState();
  }

  // Initialize sensor listeners
  void _startListening() {
    gyroscopeSubscription = gyroscopeEvents.listen((GyroscopeEvent event) {
      setState(() {
        _gyroscopeX = event.x;
        _gyroscopeY = event.y;
        _gyroscopeZ = event.z;
      });
    });

    accelerometerSubscription =
        accelerometerEvents.listen((AccelerometerEvent event) {
      setState(() {
        _accelerometerX = event.x;
        _accelerometerY = event.y;
        _accelerometerZ = event.z;
      });
    });

    locationSubscription =
        Geolocator.getPositionStream().listen((Position position) {
      setState(() {
        _latitude = position.latitude;
        _longitude = position.longitude;
      });
    });

    setState(() {
      _isListening = true;
    });
  }

  void _stopListening() {
    gyroscopeSubscription?.cancel();
    accelerometerSubscription?.cancel();
    locationSubscription?.cancel();

    setState(() {
      _isListening = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sensor Display'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Accelerometer: X=$_accelerometerX, Y=$_accelerometerY, Z=$_accelerometerZ',
            ),
            Text('Gyroscope: X=$_gyroscopeX, Y=$_gyroscopeY, Z=$_gyroscopeZ'),
            Text('GPS: Latitude=$_latitude, Longitude=$_longitude'),
            Container(height: 20),
            _isListening
                ? ElevatedButton(
                    onPressed: _stopListening,
                    child: Text('Stop Listening'),
                  )
                : ElevatedButton(
                    onPressed: _startListening,
                    child: Text('Start Listening'),
                  ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _stopListening(); // Make sure to stop listening when the widget is disposed.
    super.dispose();
  }
}
