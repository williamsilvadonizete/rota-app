import 'package:flutter/material.dart';
import '../../constants.dart';

import '../../components/dot_indicators.dart';
import '../auth/sign_in_screen.dart';
import 'components/onboard_content.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  int currentPage = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColorDark, // Altere para a cor desejada
      body: SafeArea(
        child: Column(
          children: [
            const Spacer(flex: 2),
            Expanded(
              flex: 14,
              child: PageView.builder(
                itemCount: demoData.length,
                onPageChanged: (value) {
                  setState(() {
                    currentPage = value;
                  });
                },
                itemBuilder: (context, index) => OnboardContent(
                  illustration: demoData[index]["illustration"],
                  title: demoData[index]["title"],
                  text: demoData[index]["text"],
                ),
              ),
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                demoData.length,
                (index) => DotIndicator(isActive: index == currentPage),
              ),
            ),
            const Spacer(flex: 2),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SignInScreen(),
                    ),
                  );
                },
                child: Text("Explorar".toUpperCase()),
              ),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}

// Demo data for our Onboarding screen
List<Map<String, dynamic>> demoData = [
  {
    "illustration": "assets/Illustrations/Illustrations_1.png",
    "title": "Bem-Vindo ao Rota Gourmet!",
    "text":
        "Somos o melhor clube Gastronômico do Brasil, conosco você ganha até 100% de desconto no segundo prato, em qualquer um do nossos parceiros. Veja como é rápido e fácil.",
  },
  {
    "illustration": "assets/Illustrations/Illustrations_2.png",
    "title": "Já escolheu seu restaurante?",
    "text":
        "Navegue pelo aplicativo e conheça os restaurantes, seus cardápios, e os dias dos benefícios. Você vai adorar, são muitas opções!",
  },
  {
    "illustration": "assets/Illustrations/Illustrations_3.png",
    "title": "Escolha como usar o seu Desconto",
    "text":
        "Se comer fora já era bom, imagina comer nos melhores restaurantes da cidade com descontos excelentes como esses! 100% em um prato se você for acompanhado, até 30% se for sozinho ou até 50% se pedir delivery ou balcão. Aproveite do seu jeito!",
  },
  {
    "illustration": "assets/Illustrations/Illustrations_4.png",
    "title": "Você é VIP nos Restaurantes",
    "text":
        "Se já escolheu o restaurante do dia, decidiu se vai sozinho ou acompanhado e confirmou os dias de aceitação, agora basta ir. Chegando lá, aproveite a noite, você merece! Na hora da conta, informe que é associado Rota Gourmet.",
  },
  {
    "illustration": "assets/Illustrations/Illustrations_5.png",
    "title": "Delivery Simples e Prático",
    "text":
        "Pedir o delivery é super simples. Veja o cardápio, escolha sua opção e faça o pedido no restaurante por whatsapp ou telefone. Os botões de contato estão na tela do restaurante aqui no app! Chegando o seu pedido, é só validar seu voucher com o entregador.",
  },
    {
    "illustration": "assets/Illustrations/Illustrations_6.png",
    "title": "Delivery Simples e Prático",
    "text":
        "Na hora da conta, seja no restaurante ou na entrega do delivery é sempre igual. Informe que é associado Rota Gourmet e clique em VALIDAR VOCHER na tela do restaurante escolhido. Escanei o código fornecido pelo restaurante, preencha os dados e PRONTO! Confira tudo navegando livremente pelo App e aproveite!",
  },
    {
    "illustration": "assets/Illustrations/Illustrations_7.png",
    "title": "Viu como é fácil?",
    "text":
        "Só aqui você encontra os melhores restaurantes com descontos especiais. Você não vai mais parar em casa!",
  },
];
