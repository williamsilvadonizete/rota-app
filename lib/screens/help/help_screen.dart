import 'package:flutter/material.dart';
import 'package:rota_gourmet/constants.dart';
import 'package:rota_gourmet/providers/theme_provider.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Ajuda'),
        backgroundColor: ThemeProvider.primaryColor,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(defaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Perguntas Frequentes',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: defaultPadding),
            _buildFAQItem(
              context,
              'Como faço para pedir comida?',
              'Para fazer um pedido, navegue até o restaurante desejado, escolha os itens do cardápio e adicione ao carrinho. Depois, finalize o pedido e escolha a forma de pagamento.',
            ),
            _buildFAQItem(
              context,
              'Como posso rastrear meu pedido?',
              'Após confirmar seu pedido, você receberá atualizações em tempo real sobre o status da entrega. Você pode acompanhar o progresso na seção "Meus Pedidos".',
            ),
            _buildFAQItem(
              context,
              'Quais formas de pagamento são aceitas?',
              'Aceitamos cartões de crédito, débito, PIX e dinheiro na entrega.',
            ),
            _buildFAQItem(
              context,
              'Como posso alterar meu endereço de entrega?',
              'Você pode alterar seu endereço de entrega a qualquer momento no perfil do usuário, na seção "Informações Pessoais".',
            ),
            _buildFAQItem(
              context,
              'Como funciona o sistema de avaliações?',
              'Após cada pedido entregue, você pode avaliar o restaurante e o entregador. Suas avaliações ajudam outros usuários a escolherem os melhores estabelecimentos.',
            ),
            _buildFAQItem(
              context,
              'Como posso cancelar um pedido?',
              'Você pode cancelar seu pedido até o momento em que o restaurante começar a prepará-lo. Para cancelar, acesse "Meus Pedidos" e selecione a opção de cancelamento.',
            ),
            _buildFAQItem(
              context,
              'Como funciona o programa de fidelidade?',
              'A cada pedido realizado, você acumula pontos que podem ser trocados por descontos em pedidos futuros. Os pontos são creditados automaticamente após a confirmação da entrega.',
            ),
            _buildFAQItem(
              context,
              'Como posso entrar em contato com o suporte?',
              'Você pode entrar em contato com nosso suporte através do e-mail suporte@rotagourmet.com ou pelo telefone (00) 0000-0000.',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFAQItem(BuildContext context, String question, String answer) {
    return Card(
      margin: const EdgeInsets.only(bottom: defaultPadding),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(defaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.help_outline,
                  color: ThemeProvider.primaryColor,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    question,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              answer,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }
} 