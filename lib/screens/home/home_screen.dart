import 'package:flutter/material.dart';
import 'package:rota_app/components/custom_status_bar.dart';
import 'package:rota_app/components/cards/big/big_card_image_slide.dart';
import 'package:rota_app/components/cards/big/restaurant_info_big_card.dart';
import 'package:rota_app/components/section_title.dart';
import 'package:rota_app/constants.dart';
import 'package:rota_app/demo_data.dart';
import 'package:rota_app/screens/details/details_screen.dart';
import 'package:rota_app/screens/featured/featurred_screen.dart';
import 'package:rota_app/screens/home/components/medium_card_list.dart';
import 'package:fl_chart/fl_chart.dart'; // Adicione o pacote fl_chart no pubspec.yaml

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isChartVisible = false; // Estado para controlar a visibilidade do gráfico

  void _toggleChartVisibility() {
    setState(() {
      _isChartVisible = !_isChartVisible;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColorDark,
      appBar: CustomStatusAppBar(
        showBackButton: true,
        onChartPressed: _toggleChartVisibility, // Passa a função de callback
        isChartVisible: _isChartVisible, // Passa o estado para a AppBar
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (_isChartVisible) _buildChart(), // Exibe o gráfico se visível
              const SizedBox(height: defaultPadding),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
                child: BigCardImageSlide(images: demoBigImages),
              ),
              const SizedBox(height: defaultPadding * 2),
              SectionTitle(
                title: "Parceiros em Destaque",
                press: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const FeaturedScreen(),
                  ),
                ),
              ),
              const SizedBox(height: defaultPadding),
              const MediumCardList(
                title: "Categorias",
                restaurants: [
                  {
                    "image": "assets/images/pizza.png",
                    "name": "Pizza",
                  },
                  {
                    "image": "assets/images/stack.png",
                    "name": "Steakhouse",
                  },
                  {
                    "image": "assets/images/internacional.png",
                    "name": "Internacional",
                  },
                  {
                    "image": "assets/images/hamburguer.png",
                    "name": "Hamburguer",
                  },
                ],
              ),
              const SizedBox(height: 20),
              const MediumCardList(
                title: "Para comer agora",
                restaurants: [
                  {
                    "image": "assets/images/medium_3.png",
                    "name": "Pizza do Chef",
                    "location": "Av. Paulista, 123",
                    "deliveryTime": 30,
                    "rating": 4.8,
                  },
                  {
                    "image": "assets/images/medium_4.png",
                    "name": "Sushi House",
                    "location": "Rua das Flores, 456",
                    "deliveryTime": 20,
                    "rating": 4.5,
                  },
                ],
              ),
              const SizedBox(height: 20),
              const MediumCardList(
                title: "Para comer a noite",
                restaurants: [
                  {
                    "image": "assets/images/medium_1.png",
                    "name": "Pizza do Chef",
                    "location": "Av. Paulista, 123",
                    "deliveryTime": 30,
                    "rating": 4.8,
                  },
                  {
                    "image": "assets/images/medium_2.png",
                    "name": "Sushi House",
                    "location": "Rua das Flores, 456",
                    "deliveryTime": 20,
                    "rating": 4.5,
                  },
                ],
              ),
              const SizedBox(height: 20),
              SectionTitle(
                title: "Restaurantes",
                press: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const FeaturedScreen(),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              ...List.generate(
                3,
                (index) => Padding(
                  padding: const EdgeInsets.fromLTRB(
                      defaultPadding, 0, defaultPadding, defaultPadding),
                  child: RestaurantInfoBigCard(
                    images: demoBigImages..shuffle(),
                    name: "McDonald's",
                    rating: 4.3,
                    numOfRating: 200,
                    deliveryTime: 25,
                    range: "30-80",
                    foodType: const ["Chinese", "American", "Deshi food"],
                    press: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const DetailsScreen(),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildChart() {
    // Dados mock para os últimos 4 meses
    final List<BarChartGroupData> mockBarData = [
      BarChartGroupData(
        x: 0,
        barRods: [
          BarChartRodData(fromY: 0, toY: 70, color: Colors.blue),
        ],
      ),
      BarChartGroupData(
        x: 1,
        barRods: [
          BarChartRodData(fromY: 0, toY: 50, color: Colors.blue),
        ],
      ),
      BarChartGroupData(
        x: 2,
        barRods: [
          BarChartRodData(fromY: 0, toY: 90, color: Colors.blue),
        ],
      ),
      BarChartGroupData(
        x: 3,
        barRods: [
          BarChartRodData(fromY: 0, toY: 30, color: Colors.blue),
        ],
      ),
    ];

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: defaultPadding, vertical: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: primaryColorDark, // Cor de fundo ajustada para primaryColorDark
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: SizedBox(
        height: 250, // Definindo uma altura fixa para o gráfico
        child: BarChart(
          BarChartData(
            alignment: BarChartAlignment.spaceAround,
            maxY: 100,
            barGroups: mockBarData, // Dados dos últimos 4 meses
            borderData: FlBorderData(show: false), // Remover bordas
            titlesData: FlTitlesData(show: false), // Desabilitar títulos
            gridData: FlGridData(show: false), // Remover linhas de grade
            barTouchData: BarTouchData(
              touchTooltipData: BarTouchTooltipData( // Cor do fundo da legenda
                getTooltipItem: (group, groupIndex, rod, rodIndex) {
                  return BarTooltipItem(
                    rod.toY.toString(), // Exibe o valor da barra
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
