import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:rota_gourmet/components/custom_bar.dart';
import 'sign_in_screen.dart';
import '../../components/welcome_text.dart';
import '../../constants.dart';
import '../signUp/components/sign_up_form.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColorDark,
      appBar: const CustomAppBar(showBackButton: true),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const WelcomeText(
                title: "Criar uma conta",
                text: "Digite seu Nome, E-mail e Senha \npara se inscrever.",
              ),

              // Sign Up Form
              const SignUpForm(),
              const SizedBox(height: defaultPadding),

              // Already have account
              Center(
                child: Text.rich(
                  TextSpan(
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall!
                        .copyWith(fontWeight: FontWeight.w500,),
                    text: "Você possui uma conta? ",
                    children: <TextSpan>[
                      TextSpan(
                        text: "Entrar",
                        style: const TextStyle(color: primaryColor),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const SignInScreen(),
                                ),
                              ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: defaultPadding),
              Center(
                child: Text(
                  "Ao se inscrever, você concorda com nossos Termos \nCondições e Política de Privacidade.",
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
