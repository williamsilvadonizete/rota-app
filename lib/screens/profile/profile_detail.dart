import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rota_gourmet/components/app_colors.dart';
import 'package:rota_gourmet/components/custom_status_bar.dart';
import 'package:rota_gourmet/components/dropdown/estado_drop_down.dart';
import 'package:rota_gourmet/components/fields/cep_text_field.dart';
import 'package:rota_gourmet/components/fields/cpf_text_field.dart';
import 'package:rota_gourmet/components/fields/telefone_text_field.dart';
import 'package:rota_gourmet/constants.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';
import '../../components/buttons/secondery_button.dart';

class ProfileDetailScreen extends StatefulWidget {
  const ProfileDetailScreen({super.key});

  @override
  _ProfileDetailScreenState createState() => _ProfileDetailScreenState();
}

class _ProfileDetailScreenState extends State<ProfileDetailScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Cartão de Crédito
  String cardNumber = '';
  String expiryDate = '';
  String cardHolderName = '';
  String cvvCode = '';
  bool isCvvFocused = false;
  bool useGlassMorphism = false;
  bool useBackgroundImage = false;
  bool useFloatingAnimation = true;
  bool isLightTheme = false;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: CustomStatusAppBar(showBackButton: true),
      body: Column(
        children: [
          TabBar(
            controller: _tabController,
            labelColor: primaryColor,
            unselectedLabelColor: labelColor,
            indicatorColor: primaryColor,
            tabs: const [
              Tab(text: "Perfil"),
              Tab(text: "Endereço"),
              Tab(text: "Pagamento"),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildProfileTab(),
                _buildAddressTab(),
                _buildPaymentTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileTab() {
    return _buildForm([
      _buildSectionTitle("Informações Pessoais"),
      _buildReadOnlyField("Nome", "William Souza"),
      _buildReadOnlyField("E-mail", "william@email.com"),
      TelefoneTextField(),
      CpfTextField(),
      const SizedBox(height: 16),
      SeconderyButton(
        press: () {},
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              "assets/icons/profile.svg",
              height: 24,
              colorFilter: const ColorFilter.mode(primaryColor, BlendMode.srcIn),
            ),
            const SizedBox(width: 8),
            Text(
              "Salvar Dados",
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: primaryColor),
            )
          ],
        ),
      ),
    ]);
  }

  Widget _buildAddressTab() {
    return _buildForm([
      _buildSectionTitle("Endereço"),
      CepTextField(),
      _buildCustomTextField("Rua"),
      _buildCustomTextField("Número", keyboardType: TextInputType.number),
      _buildCustomTextField("Bairro"),
      _buildCustomTextField("Cidade"),
      EstadoDropdown(),
      const SizedBox(height: 16),
      SeconderyButton(
        press: () {},
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              "assets/icons/location.svg",
              height: 24,
              colorFilter: const ColorFilter.mode(primaryColor, BlendMode.srcIn),
            ),
            const SizedBox(width: 8),
            Text(
              "Salvar Endereço",
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: primaryColor),
            )
          ],
        ),
      ),
    ]);
  }

  Widget _buildPaymentTab() {
    SystemChrome.setSystemUIOverlayStyle(
      isLightTheme ? SystemUiOverlayStyle.dark : SystemUiOverlayStyle.light,
    );
    return _buildForm([
      _buildSectionTitle("Dados de Pagamento"),
      CreditCardWidget(
        enableFloatingCard: useFloatingAnimation,
        glassmorphismConfig: _getGlassmorphismConfig(),
        cardNumber: cardNumber,
        expiryDate: expiryDate,
        cardHolderName: cardHolderName,
        cvvCode: cvvCode,
        bankName: 'Axis Bank',
        frontCardBorder: useGlassMorphism ? null : Border.all(color: Colors.grey),
        backCardBorder: useGlassMorphism ? null : Border.all(color: Colors.grey),
        showBackView: isCvvFocused,
        obscureCardNumber: true,
        obscureCardCvv: true,
        isHolderNameVisible: true,
        cardBgColor: isLightTheme ? AppColors.cardBgLightColor : AppColors.cardBgColor,
        backgroundImage: useBackgroundImage ? 'assets/images/card_bg.png' : null,
        isSwipeGestureEnabled: true,
        onCreditCardWidgetChange: (CreditCardBrand creditCardBrand) {},
        customCardTypeIcons: <CustomCardTypeIcon>[
          CustomCardTypeIcon(
            cardType: CardType.mastercard,
            cardImage: Image.asset(
              'assets/images/mastercard.png',
              height: 48,
              width: 48,
            ),
          ),
        ],
      ),
      CreditCardForm(
        formKey: formKey,
        cardNumber: cardNumber,
        expiryDate: expiryDate,
        cardHolderName: cardHolderName,
        cvvCode: cvvCode,
        onCreditCardModelChange: onCreditCardModelChange,
        obscureCvv: true,
        obscureNumber: true,
        inputConfiguration: const InputConfiguration(
          cardHolderTextStyle: TextStyle(color: primaryColor),
          cardNumberTextStyle: TextStyle(color: primaryColor),
          cvvCodeTextStyle: TextStyle(color: primaryColor),
          expiryDateTextStyle: TextStyle(color: primaryColor),
          cardNumberDecoration: InputDecoration(
            labelText: 'Número do Cartão',
            hintText: 'XXXX XXXX XXXX XXXX',
            labelStyle: TextStyle(color: primaryColor),
            hintStyle: TextStyle(color: primaryColor),
            filled: true,
            fillColor: Colors.black54,
          ),
          expiryDateDecoration: InputDecoration(
            labelText: 'Data de Validade',
            labelStyle: TextStyle(color: primaryColor),
            hintStyle: TextStyle(color: primaryColor),
            hintText: 'XX/XX',
          ),
          cvvCodeDecoration: InputDecoration(
            labelText: 'CVV',
            labelStyle: TextStyle(color: primaryColor),
            hintStyle: TextStyle(color: primaryColor),
            hintText: 'XXX',
          ),
          cardHolderDecoration: InputDecoration(
            labelText: 'Titular do Cartão',
            focusColor: primaryColor,
            fillColor: primaryColor,
          ),
        ),
      ),
      const SizedBox(height: 16),
      SeconderyButton(
        press: () {},
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              "assets/icons/delivery.svg",
              height: 24,
              colorFilter: const ColorFilter.mode(primaryColor, BlendMode.srcIn),
            ),
            const SizedBox(width: 8),
            Text(
              "Salvar Dados",
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: primaryColor),
            )
          ],
        ),
      ),
    ]);
  }

  void _onValidate() {
    if (formKey.currentState?.validate() ?? false) {
      print('valid!');
    } else {
      print('invalid!');
    }
  }

  Glassmorphism? _getGlassmorphismConfig() {
    if (!useGlassMorphism) {
      return null;
    }

    final LinearGradient gradient = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: <Color>[Colors.grey.withAlpha(50), Colors.grey.withAlpha(50)],
      stops: const <double>[0.3, 0],
    );

    return isLightTheme
        ? Glassmorphism(blurX: 8.0, blurY: 16.0, gradient: gradient)
        : Glassmorphism.defaultConfig();
  }

  void onCreditCardModelChange(CreditCardModel creditCardModel) {
    setState(() {
      cardNumber = creditCardModel.cardNumber;
      expiryDate = creditCardModel.expiryDate;
      cardHolderName = creditCardModel.cardHolderName;
      cvvCode = creditCardModel.cvvCode;
      isCvvFocused = creditCardModel.isCvvFocused;
    });
  }

  Widget _buildCustomTextField(String label, {bool obscureText = false, TextInputType? keyboardType}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        obscureText: obscureText,
        keyboardType: keyboardType,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: primaryColor),
          filled: true,
          fillColor: Colors.black54,
        ),
      ),
    );
  }

  Widget _buildForm(List<Widget> children) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: children,
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Text(
        title,
        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
      ),
    );
  }

  Widget _buildReadOnlyField(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w600)),
          const SizedBox(height: 4),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            child: Text(value, style: const TextStyle(color: Colors.grey)),
          ),
        ],
      ),
    );
  }
}
