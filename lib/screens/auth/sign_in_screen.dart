import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rota_app/components/custom_bar.dart';
import 'package:rota_app/components/wave_bar.dart';

import '../../components/buttons/socal_button.dart';
import '../../components/welcome_text.dart';
import '../../constants.dart';
import 'sign_up_screen.dart';
import 'components/sign_in_form.dart';

class SignInScreen extends StatelessWidget {
  const SignInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColorDark,
      appBar: const CustomAppBar(showBackButton: false),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const WelcomeText(
                title: "Bem-Vindo",
                text:
                    "Digite seu E-mail ou Telefone para entrar. Você não vai mais parar em Casa! :)",
              ),
              const SignInForm(),
              const SizedBox(height: defaultPadding),
              kOrText,
              const SizedBox(height: defaultPadding * 1.5),

              Center(
                child: Text.rich(
                  TextSpan(
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall!
                        .copyWith(fontWeight: FontWeight.w600, color: labelColor),
                    text: "Nāo tem uma conta? ",
                    children: <TextSpan>[
                      TextSpan(
                        text: "Cadastre-se",
                        style: const TextStyle(color: primaryColor),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const SignUpScreen(),
                                ),
                              ),
                      )
                    ],
                  ),
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
