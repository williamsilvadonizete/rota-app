import 'package:flutter/material.dart';

class BackgroundWave extends StatelessWidget {
  final double height;

  const BackgroundWave({super.key, required this.height});
  // const BackgroundWave({super.key, required this.title, required this.text});
//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       height: height,
//       child: ClipPath(
//           clipper: BackgroundWaveClipper(),
//           child: Container(
//             width: MediaQuery.of(context).size.width,
//             height: height,
//             decoration: const BoxDecoration(
//                 gradient: LinearGradient(
//               colors: [Color(0xFFFACCCC), Color(0xFFF6EFE9)],
//             )),
//           )),
//     );
//   }
// }

 @override
Widget build(BuildContext context) {
  return SizedBox(
    height: height,
    child: ClipPath(
      clipper: BackgroundWaveClipper(),
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: height,
        decoration: BoxDecoration(
          image: const DecorationImage(
            image: AssetImage("assets/images/bar.png"), // Caminho da imagem
            fit: BoxFit.cover, // Ajusta a imagem ao tamanho do container
          ),
          gradient: const LinearGradient(
            colors: [Color(0xFFFACCCC), Color(0xFFF6EFE9)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Stack(
          alignment: Alignment.center, // Alinha tudo no centro
          children: [
            Image.asset(
              "assets/images/Logo.png", // Caminho da sua logo
              height: 140, // Ajuste o tamanho da logo
            ),
          ],
        ),
      ),
    ),
  );
}
}

class BackgroundWaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();

    const minSize = 140.0;

    // when h = max = 280
    // h = 280, p1 = 210, p1Diff = 70
    // when h = min = 140
    // h = 140, p1 = 140, p1Diff = 0
    final p1Diff = ((minSize - size.height) * 0.6).truncate().abs();
    path.lineTo(0.0, size.height - p1Diff);

    final controlPoint = Offset(size.width * 1.1, size.height);
    final endPoint = Offset(size.width, minSize);

    path.quadraticBezierTo(
        controlPoint.dx, controlPoint.dy, endPoint.dx, endPoint.dy);

    path.lineTo(size.width, 0.0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(BackgroundWaveClipper oldClipper) => oldClipper != this;
}