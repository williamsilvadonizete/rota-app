import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rota_app/components/custom_status_bar.dart';

import '../../components/cards/big/restaurant_info_big_card.dart';
import '../../components/scalton/big_card_scalton.dart';
import '../../constants.dart';
import '../../demo_data.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  bool _showSearchResult = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        _isLoading = false;
      });
    });
  }

  void showResult() {
    setState(() {
      _isLoading = true;
    });
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        _showSearchResult = true;
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColorDark,
      appBar: CustomStatusAppBar(showBackButton: true),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: defaultPadding),
              const SearchForm(),
              const SizedBox(height: defaultPadding),
              Text(
                _showSearchResult ? "Search" : "Top Restaurantes",
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: titleColor,
                    ),
              ),
              const SizedBox(height: defaultPadding),
              ElevatedButton(
                onPressed: _showFilterDialog, // Função para abrir o pop-up de filtros
                
                child: const Text("Filtros"),
              ),
              const SizedBox(height: defaultPadding),
              Expanded(
                child: ListView.builder(
                  itemCount: _isLoading ? 2 : 5, // 5 é o número de itens de demonstração
                  itemBuilder: (context, index) => Padding(
                    padding: const EdgeInsets.only(bottom: defaultPadding),
                    child: _isLoading
                        ? const BigCardScalton()
                        : RestaurantInfoBigCard(
                            images: demoBigImages..shuffle(),
                            name: "McDonald's",
                            rating: 4.3,
                            range: "80-100",
                            numOfRating: 200,
                            deliveryTime: 25,
                            foodType: const [
                              "Chinese",
                              "American",
                              "Deshi food"
                            ],
                            press: () {},
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

  // Função que abre o diálogo para filtros
  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Filtros'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Exemplo de filtros
              CheckboxListTile(
                title: const Text('Filtro 1'),
                value: true, // Controle do estado do filtro
                onChanged: (bool? value) {},
              ),
              CheckboxListTile(
                title: const Text('Filtro 2'),
                value: false, // Controle do estado do filtro
                onChanged: (bool? value) {},
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Fecha o pop-up
              },
              child: const Text('Fechar'),
            ),
          ],
        );
      },
    );
  }
}

class SearchForm extends StatefulWidget {
  const SearchForm({super.key});

  @override
  State<SearchForm> createState() => _SearchFormState();
}

class _SearchFormState extends State<SearchForm> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: TextFormField(
        onChanged: (value) {
          // Obter dados enquanto digita
        },
        onFieldSubmitted: (value) {
          if (_formKey.currentState!.validate()) {
            // Se os dados estiverem corretos, salve os dados
            _formKey.currentState!.save();
          } else {
            // Caso haja erro na validação
          }
        },
        validator: requiredValidator.call,
        style: Theme.of(context).textTheme.labelLarge,
        textInputAction: TextInputAction.search,
        decoration: InputDecoration(
          hintText: "Buscar",
          contentPadding: kTextFieldPadding,
          prefixIcon: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SvgPicture.asset(
              'assets/icons/search.svg',
              colorFilter: const ColorFilter.mode(
                bodyTextColor,
                BlendMode.srcIn,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
