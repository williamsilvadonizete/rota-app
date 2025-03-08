import 'package:flutter/material.dart';

import '../../constants.dart';

import '../../components/welcome_text.dart';

class ResetEmailSentScreen extends StatelessWidget {
  const ResetEmailSentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColorDark,
      appBar: AppBar(
        title: const Text("Esqueceu a Senha"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const WelcomeText(
                title: "Redefiniçāo de senha enviada!",
                text:
                    "Nós enviamos instruçoes no seu email"),
            const SizedBox(height: defaultPadding),
            ElevatedButton(
              onPressed: () {},
              child: const Text("Enviar Novamente"),
            ),
          ],
        ),
      ),
    );
  }
}
