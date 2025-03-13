import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../entry_point.dart';

import '../../components/buttons/secondery_button.dart';
import '../../components/welcome_text.dart';
import '../../constants.dart';

class FindRestaurantsScreen extends StatelessWidget {
  const FindRestaurantsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColorDark,
      appBar: AppBar(
        backgroundColor: primaryColorDark,
        leading: IconButton(
          icon: const Icon(Icons.close, color: primaryColor,),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const EntryPoint(),
              ),
            );
          },
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
                text:
                    "Por favor, insira sua localização ou permita o acesso à \nsua localização para encontrar restaurantes próximos.",
              ),

              // Getting Current Location
              SeconderyButton(
                press: () {},
                child: Row(
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
                      "Sua localizaçāo atual",
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium!
                          .copyWith(color: primaryColor),
                    )
                  ],
                ),
              ),
              const SizedBox(height: defaultPadding),

              // New Address Form
              Form(
                child: Column(
                  children: [
                    TextFormField(
                      // onSaved: (value) => _location = value,
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium!
                          .copyWith(color: titleColor),
                      cursorColor: primaryColor,
                      decoration: InputDecoration(
                        prefixIcon: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SvgPicture.asset(
                            "assets/icons/marker.svg",
                            colorFilter: const ColorFilter.mode(
                                bodyTextColor, BlendMode.srcIn),
                          ),
                        ),
                        hintText: "Entre o endereço",
                        contentPadding: kTextFieldPadding,
                      ),
                    ),
                    const SizedBox(height: defaultPadding),
                    Image.asset(
                      "assets/images/location.png", // Substitua pelo caminho correto da sua imagem
                      height: 150, // Ajuste a altura conforme necessário
                      width: double.infinity, // Para ocupar toda a largura disponível
                      fit: BoxFit.contain, // Ajuste para manter a proporção da imagem
                    ),
                    ElevatedButton(
                      onPressed: () {
                        // Use your onw way how you combine both New Address and Current Location
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const EntryPoint(),
                          ),
                        );
                      },
                      child: const Text("Continue"),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: defaultPadding),
            ],
          ),
        ),
      ),
    );
  }
}
