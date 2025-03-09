import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:rota_app/components/custom_status_bar.dart';
import '../../../constants.dart';

class Body extends StatelessWidget {
  const Body({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 33, 32, 32), // Cor de fundo escura
      appBar: CustomStatusAppBar(showBackButton: true),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24),
              ...menuItems.map((item) => ProfileMenuCard(
                    svgSrc: item["icon"]!,
                    title: item["title"]!,
                    subTitle: item["subTitle"]!,
                    press: item["action"],
                  )),
            ],
          ),
        ),
      ),
    );
  }
}

class ProfileMenuCard extends StatelessWidget {
  const ProfileMenuCard({
    super.key,
    required this.title,
    required this.subTitle,
    required this.svgSrc,
    this.press,
  });

  final String title, subTitle, svgSrc;
  final VoidCallback? press;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: InkWell(
        onTap: press,
        borderRadius: BorderRadius.circular(12),
        splashColor: Colors.white12,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.black54, // Fundo dos cards escuro
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 6,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white12, // Fundo do ícone sutilmente diferente
                  borderRadius: BorderRadius.circular(8),
                ),
                child: SvgPicture.asset(
                  svgSrc,
                  height: 24,
                  width: 24,
                  colorFilter: const ColorFilter.mode(
                    Colors.white70,
                    BlendMode.srcIn,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subTitle,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white60,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.arrow_forward_ios_rounded,
                size: 20,
                color: Colors.white38,
              )
            ],
          ),
        ),
      ),
    );
  }
}

// Lista de itens do menu
final List<Map<String, dynamic>> menuItems = [
  {
    "icon": "assets/icons/profile.svg",
    "title": "Informações do Perfil",
    "subTitle": "Altere as informações da sua conta",
    "action": () {},
  },
  {
    "icon": "assets/icons/lock.svg",
    "title": "Alterar Senha",
    "subTitle": "Atualize suas configurações de segurança",
    "action": () {},
  },
  {
    "icon": "assets/icons/card.svg",
    "title": "Métodos de Pagamento",
    "subTitle": "Gerencie seus cartões de crédito e débito",
    "action": () {},
  },
  {
    "icon": "assets/icons/marker.svg",
    "title": "Endereços",
    "subTitle": "Adicione ou remova seus endereços de entrega",
    "action": () {},
  },
  {
    "icon": "assets/icons/share.svg",
    "title": "Indicar um Amigo",
    "subTitle": "Ganhe R\$10 por cada amigo indicado",
    "action": () {},
  },
];
