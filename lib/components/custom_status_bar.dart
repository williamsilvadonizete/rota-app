import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:rota_app/components/notification_permission.dart';
import 'package:rota_app/constants.dart';

class CustomStatusAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  final Size preferredSize;

  final bool showBackButton;
  final VoidCallback? onChartPressed; // Callback para o clique no ícone de gráfico
  final bool isChartVisible; // Estado para controlar a cor do ícone

  const CustomStatusAppBar({
    super.key,
    this.showBackButton = false,
    this.onChartPressed,
    this.isChartVisible = false, // Valor padrão
  }) : preferredSize = const Size.fromHeight(120.0); // Tamanho reduzido do AppBar

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: primaryColor,
      centerTitle: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
      ),
      leading: showBackButton
          ? IconButton(
              onPressed: () => Navigator.of(context).pop(),
              icon: const Icon(Icons.arrow_back, color: primaryColorDark),
            )
          : IconButton(
              onPressed: () {},
              icon: const Icon(Icons.subject, color: primaryColorDark),
            ),
      actions: [
        IconButton(
          onPressed: () {},
          icon: NotificationPermissionWidget(),
        ),
        IconButton(
          onPressed: onChartPressed, // Usa o callback aqui
          icon: Icon(
            Icons.bar_chart,
            color: isChartVisible ? Colors.amber : primaryColorDark, // Muda a cor do ícone
          ),
        ),
      ],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(80.0), // Tamanho reduzido do bottom
        child: Padding(
          padding: const EdgeInsets.only(left: 25, bottom: 15), // Padding ajustado
          child: _buildUserInfo(),
        ),
      ),
    );
  }

  Widget _buildUserInfo() {
    return Row(
      children: [
        Container(
          width: 70, // Tamanho reduzido do container
          height: 70,
          decoration: const BoxDecoration(
            color: primaryColor,
            shape: BoxShape.circle,
          ),
          child: SvgPicture.asset(
            "assets/icons/logo.svg",
            fit: BoxFit.contain,
          ),
        ),
        const SizedBox(width: 10), // Espaço reduzido entre os elementos
        const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'William Silva',
              style: TextStyle(
                fontSize: 18, // Tamanho da fonte reduzido
                fontWeight: FontWeight.w700,
                color: primaryColorDark,
              ),
            ),
            Text(
              'Uberlândia',
              style: TextStyle(fontSize: 14, color: primaryColorDark), // Tamanho da fonte reduzido
            ),
          ],
        ),
      ],
    );
  }
}
