import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geolocator/geolocator.dart';
import '../../entry_point.dart';
import '../../components/buttons/secondery_button.dart';
import '../../components/welcome_text.dart';
import '../../constants.dart';

class FindRestaurantsScreen extends StatefulWidget {
  const FindRestaurantsScreen({super.key});

  @override
  State<FindRestaurantsScreen> createState() => _FindRestaurantsScreenState();
}

class _FindRestaurantsScreenState extends State<FindRestaurantsScreen> {
  String _location = '';
  bool _isLoadingLocation = false;
  bool _checkingInitialPermission = true;

  @override
  void initState() {
    super.initState();
    _checkLocationPermission();
  }

  Future<void> _checkLocationPermission() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      LocationPermission permission = await Geolocator.checkPermission();

      if (serviceEnabled && 
          (permission == LocationPermission.whileInUse || 
           permission == LocationPermission.always)) {
        await _getCurrentLocation(skipNavigation: false);
      }
    } catch (e) {
      print('Erro ao verificar permissão: $e');
    } finally {
      if (mounted) {
        setState(() => _checkingInitialPermission = false);
      }
    }
  }

  Future<void> _getCurrentLocation({bool skipNavigation = true}) async {
    if (_isLoadingLocation) return;
    
    setState(() => _isLoadingLocation = true);
    
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      LocationPermission permission = await Geolocator.checkPermission();

      if (!serviceEnabled) {
        if (mounted) {
          await _showLocationServiceDisabledDialog(context);
        }
        return;
      }

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          if (mounted) {
            _showPermissionDeniedMessage(context);
          }
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        if (mounted) {
          await _showPermissionPermanentlyDeniedMessage(context);
        }
        return;
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best,
      );

      if (mounted) {
        setState(() {
          _location = '${position.latitude}, ${position.longitude}';
        });
      }

      if (!skipNavigation && mounted) {
        _navigateToNextScreen();
      }

    } catch (e) {
      print('Erro ao obter localização: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Erro ao obter localização')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoadingLocation = false);
      }
    }
  }

  Future<void> _showLocationServiceDisabledDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Localização desativada'),
          content: const Text('Por favor, ative o serviço de localização para usar este recurso.'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text('Abrir configurações'),
              onPressed: () async {
                Navigator.of(context).pop();
                await Geolocator.openLocationSettings();
              },
            ),
          ],
        );
      },
    );
  }

  void _showPermissionDeniedMessage(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Permissão de localização negada')),
    );
  }

  Future<void> _showPermissionPermanentlyDeniedMessage(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Permissão necessária'),
          content: const Text('Para usar este recurso, você precisa conceder permissão de localização nas configurações do aplicativo.'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text('Abrir configurações'),
              onPressed: () async {
                Navigator.of(context).pop();
                await Geolocator.openAppSettings();
              },
            ),
          ],
        );
      },
    );
  }

  void _navigateToNextScreen() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const EntryPoint(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_checkingInitialPermission) {
      return Scaffold(
        backgroundColor: primaryColorDark,
        body: Center(
          child: CircularProgressIndicator(
            color: primaryColor,
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: primaryColorDark,
      appBar: AppBar(
        backgroundColor: primaryColorDark,
        leading: IconButton(
          icon: const Icon(Icons.close, color: primaryColor),
          onPressed: () => _navigateToNextScreen(),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const WelcomeText(
                title: "Encontre restaurantes perto de você",
                text: "Por favor, insira sua localização ou permita o acesso à sua localização para encontrar restaurantes próximos.",
              ),

              SeconderyButton(
                press: () => _getCurrentLocation(skipNavigation: false),
                child: _isLoadingLocation
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: primaryColor,
                        ),
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                            "assets/icons/location.svg",
                            height: 24,
                            colorFilter: const ColorFilter.mode(
                              primaryColor,
                              BlendMode.srcIn,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            "Sua localização atual",
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(color: primaryColor),
                          )
                        ],
                      ),
              ),
              const SizedBox(height: defaultPadding),

              if (_location.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(bottom: defaultPadding),
                  child: Text(
                    'Localização: $_location',
                    style: Theme.of(context).textTheme.bodySmall!.copyWith(color: Colors.white),
                  ),
                ),

              Form(
                child: Column(
                  children: [
                    const SizedBox(height: defaultPadding),
                    Image.asset(
                      "assets/images/location.png",
                      height: 150,
                      width: double.infinity,
                      fit: BoxFit.contain,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        if (_location.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Por favor, informe ou obtenha sua localização')),
                          );
                          return;
                        }
                        _navigateToNextScreen();
                      },
                      child: const Text("Continue"),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}