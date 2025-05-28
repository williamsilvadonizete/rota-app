import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:rota_gourmet/constants.dart';

class QrScannerModal {
  static void show({
    required BuildContext context,
    required Function(String) onScanCompleted,
  }) {
    showModalBottomSheet(
      context: context,
      builder: (context) => _QrScannerContent(onScanCompleted: onScanCompleted),
      backgroundColor: Colors.black87,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      isScrollControlled: true,
    );
  }
}

class _QrScannerContent extends StatefulWidget {
  final Function(String) onScanCompleted;

  const _QrScannerContent({required this.onScanCompleted});

  @override
  State<_QrScannerContent> createState() => _QrScannerContentState();
}

class _QrScannerContentState extends State<_QrScannerContent> {
  late MobileScannerController cameraController;
  bool isScanCompleted = false;
  bool _isCameraAvailable = true;

  @override
  void initState() {
    super.initState();
    cameraController = MobileScannerController(
      detectionSpeed: DetectionSpeed.normal,
      facing: CameraFacing.back,
    );
    _checkCameraStatus();
  }

  Future<void> _checkCameraStatus() async {
    try {
      await cameraController.start();
      setState(() => _isCameraAvailable = true);
    } catch (e) {
      setState(() => _isCameraAvailable = false);
    }
  }

  @override
  void dispose() {
    cameraController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.6,
      child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              "Escaneie o QR Code",
              style: TextStyle(
                color: labelColor,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: _isCameraAvailable
                ? MobileScanner(
                    controller: cameraController,
                    onDetect: (capture) => _handleDetection(capture),
                  )
                : _buildCameraSimulator(context),
          ),
          _buildCloseButton(),
        ],
      ),
    );
  }

  void _handleDetection(BarcodeCapture capture) {
    if (!isScanCompleted) {
      for (final barcode in capture.barcodes) {
        if (barcode.rawValue != null) {
          isScanCompleted = true;
          widget.onScanCompleted(barcode.rawValue!);
          Navigator.pop(context);
        }
      }
    }
  }

  Widget _buildCameraSimulator(BuildContext context) {
    return Container(
      color: Colors.black,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.camera_alt, size: 50, color: labelColor),
            const SizedBox(height: 16),
            const Text(
              'Câmera não disponível no simulador',
              style: TextStyle(color: labelColor, fontSize: 16),
            ),
            const SizedBox(height: 24),
            _buildSimulatorInputField(),
          ],
        ),
      ),
    );
  }

  Widget _buildSimulatorInputField() {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.8,
      child: TextField(
        decoration: InputDecoration(
          filled: true,
          fillColor: primaryColorDark,
          hintText: 'Digite um código para simular',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        onSubmitted: (value) {
          if (value.isNotEmpty) {
            widget.onScanCompleted(value);
            Navigator.pop(context);
          }
        },
      ),
    );
  }

  Widget _buildCloseButton() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: ElevatedButton(
        onPressed: () => Navigator.pop(context),
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          minimumSize: const Size(double.infinity, 50),
        ),
        child: const Text("Fechar Scanner"),
      ),
    );
  }
}