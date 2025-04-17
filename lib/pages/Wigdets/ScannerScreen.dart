import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class ScannerScreen extends StatefulWidget {
  const ScannerScreen({super.key});

  @override
  State<ScannerScreen> createState() => _ScannerScreenState();
}

class _ScannerScreenState extends State<ScannerScreen> {
  final MobileScannerController controller = MobileScannerController(
    torchEnabled: true,
  );
  bool isTorchOn = true;
  bool _alreadyScanned = false;
  final AudioPlayer _player = AudioPlayer();

  void toggleTorch() {
    controller.toggleTorch();
    setState(() {
      isTorchOn = !isTorchOn;
    });
  }

  @override
  void dispose() {
    controller.dispose();
    _player.dispose();
    super.dispose();
  }

  void _handleDetection(BarcodeCapture capture) async {
    if (_alreadyScanned) return;
    _alreadyScanned = true;

    final String? code = capture.barcodes.first.rawValue;
    if (code != null) {
      await _player.play(AssetSource('sounds/beep.mp3')); // Play the beep sound
      await controller.stop();
      // ignore: use_build_context_synchronously
      Navigator.pop(context, code);
    } else {
      _alreadyScanned = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Scanning..."),
        actions: [
          IconButton(
            icon: Icon(
              isTorchOn ? Icons.flash_on : Icons.flash_off,
              color: isTorchOn ? Colors.amber : Colors.grey[300],
            ),
            onPressed: toggleTorch,
          ),
        ],
      ),
      body: MobileScanner(controller: controller, onDetect: _handleDetection),
    );
  }
}
