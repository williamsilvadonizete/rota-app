import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:rota_app/components/city_selection_modal.dart';
import 'package:rota_app/components/notification_permission.dart';
import 'package:rota_app/constants.dart';
import 'package:rota_app/components/chart_modal.dart';  // Importa o ChartModal

class CustomStatusAppBar extends StatefulWidget implements PreferredSizeWidget {
  @override
  final Size preferredSize;

  final bool showBackButton;

  const CustomStatusAppBar({
    super.key,
    this.showBackButton = false,
  }) : preferredSize = const Size.fromHeight(120.0);

  @override
  _CustomStatusAppBarState createState() => _CustomStatusAppBarState();
}

class _CustomStatusAppBarState extends State<CustomStatusAppBar> {
  String selectedCity = 'Uberlândia';  // Cidade inicial

  // Função para abrir o modal do gráfico utilizando o ChartModal
  void _openChartModal() {
    PerformanceChartModal.show(
      context: context,
      totalSpent: 500.00, // Valor gasto (pago)
      totalSaved: 300.00, // Valor economizado
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: primaryColor,
      centerTitle: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
      ),
      // leading: widget.showBackButton
      //     ? IconButton(
      //         onPressed: () => Navigator.of(context).pop(),
      //         icon: const Icon(Icons.arrow_back, color: primaryColorDark),
      //       )
      //     : IconButton(
      //         onPressed: () {},
      //         icon: const Icon(Icons.subject, color: primaryColorDark),
      //       ),
      actions: [
        IconButton(
          onPressed: () {},
          icon: NotificationPermissionWidget(),
        ),
        IconButton(
          onPressed: _openChartModal, // Chama o método para abrir o modal
          icon: const Icon(
            Icons.bar_chart,
            color: primaryColorDark,
          ),
        ),
      ],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(80.0),
        child: Padding(
          padding: const EdgeInsets.only(left: 25, bottom: 15),
          child: _buildUserInfo(context),
        ),
      ),
    );
  }

  Widget _buildUserInfo(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: const BoxDecoration(
            color: primaryColor,
            shape: BoxShape.circle,
          ),
          child: SvgPicture.asset(
            "assets/icons/logo.svg",
            fit: BoxFit.contain,
          ),
        ),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'William Silva',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: primaryColorDark,
              ),
            ),
            GestureDetector(
              onTap: () => CitySelectionModal.show(
                context,
                onCitySelected: (city) {
                  setState(() {
                    selectedCity = city;  // Atualiza a cidade selecionada
                  });
                  print("Cidade selecionada: $city");
                },
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.location_on,
                    color: primaryColorDark,
                    size: 16,
                  ),
                  const SizedBox(width: 4),  // Espaço entre o ícone e o texto
                  Text(
                    selectedCity,
                    style: const TextStyle(
                        fontSize: 14, color: primaryColorDark, decoration: TextDecoration.underline),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
