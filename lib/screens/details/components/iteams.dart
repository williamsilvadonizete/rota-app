import 'package:flutter/material.dart';
import '../../../components/cards/iteam_card.dart';
import '../../../constants.dart';
import '../../addToOrder/add_to_order_screen.dart';

class Items extends StatefulWidget {
  const Items({super.key});

  @override
  State<Items> createState() => _ItemsState();
}

class _ItemsState extends State<Items> {
  int _selectedTabIndex = 0;
  
  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DefaultTabController(
          length: demoTabs.length,
          child: TabBar(
            isScrollable: true,
            unselectedLabelColor: Theme.of(context).brightness == Brightness.dark 
                ? Colors.white70 
                : titleColor,
            labelStyle: Theme.of(context).textTheme.titleLarge!.copyWith(
              color: primaryColor,
              fontWeight: FontWeight.bold,
            ),
            unselectedLabelStyle: Theme.of(context).textTheme.titleLarge!.copyWith(
              color: Theme.of(context).brightness == Brightness.dark 
                  ? Colors.white70 
                  : titleColor,
            ),
            onTap: (value) {
              setState(() {
                _selectedTabIndex = value;
              });
            },
            tabs: demoTabs,
          ),
        ),
        if (_selectedTabIndex == 0) ...[
          ...List.generate(
            demoData.length,
            (index) => Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: defaultPadding, vertical: defaultPadding / 2),
              child: ItemCard(
                title: demoData[index]["title"],
                description: demoData[index]["description"],
                image: demoData[index]["image"],
                foodType: demoData[index]['foodType'],
                price: demoData[index]["price"],
                priceRange: demoData[index]["priceRange"],
                press: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AddToOrderScrreen(),
                  ),
                ),
              ),
            ),
          ),
        ] else ...[
          Padding(
            padding: const EdgeInsets.all(defaultPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildInfoSection(
                  context,
                  "Sobre o Restaurante",
                  "Fundado em 2010, nosso restaurante é conhecido por sua culinária autêntica e ambiente acolhedor. Com mais de uma década de experiência, nos dedicamos a oferecer a melhor experiência gastronômica para nossos clientes.",
                ),
                const SizedBox(height: defaultPadding),
                _buildInfoSection(
                  context,
                  "Horário de Funcionamento",
                  "Segunda a Sexta: 11:00 - 22:00\nSábado e Domingo: 12:00 - 23:00",
                ),
                const SizedBox(height: defaultPadding),
                _buildInfoSection(
                  context,
                  "Localização",
                  "Rua das Flores, 123\nCentro, São Paulo - SP\nCEP: 01234-567",
                ),
                const SizedBox(height: defaultPadding),
                _buildInfoSection(
                  context,
                  "Contato",
                  "Telefone: (11) 1234-5678\nWhatsApp: (11) 98765-4321\nEmail: contato@restaurante.com",
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildInfoSection(BuildContext context, String title, String content) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            color: isDarkMode ? Colors.white : Colors.black87,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          content,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: isDarkMode ? Colors.white70 : Colors.black54,
            height: 1.5,
          ),
        ),
      ],
    );
  }
}

final List<Tab> demoTabs = <Tab>[
  const Tab(
    child: Text('Cardápio'),
  ),
  const Tab(
    child: Text('Informações'),
  ),
];

final List<Map<String, dynamic>> demoData = List.generate(
  3,
  (index) => {
    "image": "assets/images/featured _items_${index + 1}.png",
    "title": "Cookie Sandwich",
    "description": "Shortbread, chocolate turtle cookies, and red velvet.",
    "price": 7.4,
    "foodType": "Chinese",
    "priceRange": "\$" * 2,
  },
);
