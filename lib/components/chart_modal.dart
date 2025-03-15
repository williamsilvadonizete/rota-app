import 'package:flutter/material.dart';
import 'package:rota_app/constants.dart';
import 'package:rota_app/components/chart_widget.dart';

class ChartModal {
  static void show(BuildContext context) {
    showModalBottomSheet(
      backgroundColor: primaryColorDark,
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      isScrollControlled: true,
      builder: (context) {
        return FractionallySizedBox(
          heightFactor: 0.6,  // Reduz o tamanho do modal
          child: Center(  // Centraliza o conteúdo
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),  // Adiciona padding
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text(
                      'Gráfico de Desempenho',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: primaryColor),
                    ),
                  ),
                  const SizedBox(height: 20),  // Espaço entre o título e o gráfico
                  const SizedBox(
                    width: double.infinity,  // Tamanho máximo para o gráfico
                    child: ChartWidget(), // Exibindo o ChartWidget dentro do modal
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
