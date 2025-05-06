import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:permission_handler/permission_handler.dart';

class QrScannerWidget extends StatefulWidget {
  const QrScannerWidget({super.key});

  @override
  State<QrScannerWidget> createState() => _QrScannerWidgetState();
}

class _QrScannerWidgetState extends State<QrScannerWidget> {
  final MobileScannerController cameraController = MobileScannerController();
  bool isScanCompleted = false;
  bool _isCameraPermissionGranted = false;

  // Método para verificar permissão da câmera
  Future<void> _checkCameraPermission() async {
    final status = await Permission.camera.status;
    setState(() {
      _isCameraPermissionGranted = status.isGranted;
    });
  }

  // Método para solicitar permissão da câmera
  Future<void> _requestCameraPermission() async {
    final status = await Permission.camera.request();
    setState(() {
      _isCameraPermissionGranted = status.isGranted;
    });
  }

  // Método para mostrar diálogo quando permissão é negada permanentemente
  void _showPermissionDeniedDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Permissão necessária'),
        content: const Text(
            'Para escanear QR Codes, é necessário conceder permissão para acessar a câmera. '
            'Por favor, habilite a permissão nas configurações do aplicativo.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await openAppSettings();
            },
            child: const Text('Abrir Configurações'),
          ),
        ],
      ),
    );
  }

  Future<void> _showQrScanner(BuildContext context) async {
    await _checkCameraPermission();

    if (!_isCameraPermissionGranted) {
      await _requestCameraPermission();
      if (!_isCameraPermissionGranted) {
        if (await Permission.camera.isPermanentlyDenied) {
          _showPermissionDeniedDialog(context);
        }
        return;
      }
    }

    if (!mounted) return;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.black87,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => SizedBox(
        height: MediaQuery.of(context).size.height * 0.7,
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                "Escaneie o QR Code",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Expanded(
              child: MobileScanner(
                controller: cameraController,
                onDetect: (capture) {
                  if (!isScanCompleted) {
                    final List<Barcode> barcodes = capture.barcodes;
                    for (final barcode in barcodes) {
                      if (barcode.rawValue != null) {
                        isScanCompleted = true;
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("QR Code escaneado: ${barcode.rawValue}"),
                          ),
                        );
                      }
                    }
                  }
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: ElevatedButton(
                onPressed: () {
                  cameraController.stop();
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                child: const Text("Fechar Scanner"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _checkCameraPermission();
  }

  @override
  void dispose() {
    cameraController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          const Text(
            "Escaneie um QR Code",
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          ElevatedButton.icon(
            onPressed: () async {
              isScanCompleted = false;
              await _showQrScanner(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            ),
            icon: const Icon(Icons.qr_code_scanner, color: Colors.white),
            label: const Text(
              "Abrir Scanner",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}