// import 'package:flutter/material.dart';
// import 'package:torch_light/torch_light.dart';

// class FleshLight extends StatefulWidget {
//   const FleshLight({super.key});

//   @override
//   State<FleshLight> createState() => _FleshLightState();
// }

// class _FleshLightState extends State<FleshLight> {
//   bool isFleshLightOn = false;

//   @override
//   void initState() {
//     super.initState();
//     checkTorchAvailable();
//   }

//   @override
//   void dispose() {
//     if (isFleshLightOn) {
//       TorchLight.disableTorch();
//     }
//     super.dispose();
//   }

//   void checkTorchAvailable() async {
//     try {
//       bool available = await TorchLight.isTorchAvailable();
//       setState(() {
//         isFleshLightOn = available;
//       });
//     } catch (e) {
//       print("Torch mavjudligini tekshiring: $e");
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: isFleshLightOn ? Colors.white : Colors.black,
//       appBar: AppBar(
//         centerTitle: true,
//         title: Text("Flesh light", style: TextStyle(color: Colors.white)),
//         backgroundColor: isFleshLightOn ? Colors.grey[300] : Colors.grey[900],
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(isFleshLightOn ? Icons.flash_on : Icons.flash_off),
//             SizedBox(height: 30),
//             Text(
//               isFleshLightOn ? "Yoniq" : "O'chiq",
//               style: TextStyle(
//                 fontSize: 24,
//                 fontWeight: FontWeight.bold,
//                 color: isFleshLightOn ? Colors.black : Colors.white,
//               ),
//             ),
//             SizedBox(height: 50),
//             // GestureDetector(),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class FleshLight extends StatefulWidget {
  const FleshLight({super.key});

  @override
  _FleshLightState createState() => _FleshLightState();
}

class _FleshLightState extends State<FleshLight> {
  static const platform = MethodChannel('flashlight');
  bool _isOn = false;

  Future<void> _toggleFlashlight() async {
    try {
      final bool result = await platform.invokeMethod('toggleFlashlight');
      setState(() {
        _isOn = result;
      });
    } on PlatformException catch (e) {
      print("Flashlight xatosi: '${e.message}'");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              _isOn ? Icons.flash_on : Icons.flash_off,
              size: 100,
              color: _isOn ? Colors.yellow : Colors.grey,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _toggleFlashlight,
              child: Text(_isOn ? "Yoqish" : "O'chirish"),
            ),
          ],
        ),
      ),
    );
  }
}
