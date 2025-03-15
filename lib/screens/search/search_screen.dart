import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rota_app/screens/filter/filter_screen.dart';
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
      appBar: AppBar(
        backgroundColor: primaryColorDark, // Cor do fundo da AppBar
        title: const Text(
          "Encontre restaurantes",
          style: TextStyle(
            color: primaryColor, // Cor do texto
          ),
        ),
        actions: [
          // Ícone de filtro
          IconButton(
            icon: const Icon(Icons.filter_list),
            color: primaryColor,
            onPressed: _showFilterModal, // Exibe o filtro como um BottomSheet
          ),
        ],
      ),
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

  // Função que abre o modal de filtros usando showModalBottomSheet
  void _showFilterModal() {
    showModalBottomSheet(
      context: context,
      backgroundColor: primaryColorDark,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      isScrollControlled: true,
      builder: (context) {
        return FractionallySizedBox(
          heightFactor: 0.8, // Faz com que o modal ocupe 80% da altura da tela
          child: const FilterScreen(), // Utiliza a tela FilterScreen no BottomSheet
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
          hintText: "Buscar Restaurantes",
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
