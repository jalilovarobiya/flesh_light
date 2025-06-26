import 'package:flutter/material.dart';
import 'package:torch_light/torch_light.dart';

class FleshLight extends StatefulWidget {
  FleshLight({super.key});

  @override
  State<FleshLight> createState() => _FleshLightState();
}

class _FleshLightState extends State<FleshLight> {
  bool isFleshLightOn = false;
  bool isTorchAvailable = false;

  @override
  void initState() {
    super.initState();
    checkTorchAvailable();
  }

  @override
  void dispose() {
    if (isFleshLightOn) {
      TorchLight.disableTorch();
    }
    super.dispose();
  }

  void checkTorchAvailable() async {
    try {
      bool available = await TorchLight.isTorchAvailable();
      setState(() {
        isTorchAvailable = available;
      });
    } catch (e) {
      print("Torch mavjudligini tekshirish xatosi: $e");
    }
  }

  Future<void> toggleFlashlight() async {
    if (!isTorchAvailable) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Bu qurilmada flashlight mavjud emas')),
      );
      return;
    }

    try {
      if (isFleshLightOn) {
        await TorchLight.disableTorch();
      } else {
        await TorchLight.enableTorch();
      }
      setState(() {
        isFleshLightOn = !isFleshLightOn;
      });
    } catch (e) {
      print("Flashlight xatosi: $e");
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Flashlight xatosi: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: isFleshLightOn ? Colors.white : Colors.black,
      appBar: AppBar(
        centerTitle: true,
        title: Text("Flesh light", style: TextStyle(color: Colors.white)),
        backgroundColor: isFleshLightOn ? Colors.grey[300] : Colors.grey[900],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isFleshLightOn ? Icons.flash_on : Icons.flash_off,
              size: 100,
              color: isFleshLightOn ? Colors.yellow : Colors.grey,
            ),
            SizedBox(height: 30),
            Text(
              isFleshLightOn ? "Yoniq" : "O'chiq",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: isFleshLightOn ? Colors.black : Colors.white,
              ),
            ),
            SizedBox(height: 50),
            ElevatedButton(
              onPressed: isTorchAvailable ? toggleFlashlight : null,
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                backgroundColor: isFleshLightOn ? Colors.orange : Colors.blue,
              ),
              child: Text(
                isFleshLightOn ? "O'chirish" : "Yoqish",
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
            SizedBox(height: 20),
            if (!isTorchAvailable)
              Text(
                "Flashlight mavjud emas",
                style: TextStyle(color: Colors.red, fontSize: 16),
              ),
          ],
        ),
      ),
    );
  }
}
