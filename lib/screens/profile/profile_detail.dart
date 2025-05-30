import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:rota_gourmet/providers/theme_provider.dart';
import 'package:rota_gourmet/components/app_colors.dart';
import 'package:rota_gourmet/components/dropdown/estado_drop_down.dart';
import 'package:rota_gourmet/components/fields/cep_text_field.dart';
import 'package:rota_gourmet/components/fields/cpf_text_field.dart';
import 'package:rota_gourmet/components/fields/telefone_text_field.dart';
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
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;
    
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Informações Pessoais'),
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
      ),
      body: Column(
        children: [
          TabBar(
            controller: _tabController,
            labelColor: ThemeProvider.primaryColor,
            unselectedLabelColor: isDarkMode ? Colors.grey[400] : Colors.grey[600],
            indicatorColor: ThemeProvider.primaryColor,
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
              colorFilter: ColorFilter.mode(
                Theme.of(context).textTheme.bodyMedium?.color ?? Colors.grey,
                BlendMode.srcIn,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              "Salvar Dados",
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Theme.of(context).textTheme.bodyMedium?.color,
                fontWeight: FontWeight.w600,
              ),
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
              colorFilter: ColorFilter.mode(
                Theme.of(context).textTheme.bodyMedium?.color ?? Colors.grey,
                BlendMode.srcIn,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              "Salvar Endereço",
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Theme.of(context).textTheme.bodyMedium?.color,
                fontWeight: FontWeight.w600,
              ),
            )
          ],
        ),
      ),
    ]);
  }

  Widget _buildPaymentTab() {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;
    
    SystemChrome.setSystemUIOverlayStyle(
      isDarkMode ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark,
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
        cardBgColor: isDarkMode ? AppColors.cardBgColor : AppColors.cardBgLightColor,
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
        inputConfiguration: InputConfiguration(
          cardHolderTextStyle: TextStyle(color: ThemeProvider.primaryColor),
          cardNumberTextStyle: TextStyle(color: ThemeProvider.primaryColor),
          cvvCodeTextStyle: TextStyle(color: ThemeProvider.primaryColor),
          expiryDateTextStyle: TextStyle(color: ThemeProvider.primaryColor),
          cardNumberDecoration: InputDecoration(
            labelText: 'Número do Cartão',
            hintText: 'XXXX XXXX XXXX XXXX',
            labelStyle: TextStyle(
              color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.7),
            ),
            hintStyle: TextStyle(
              color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.5),
            ),
            prefixIcon: Icon(
              Icons.credit_card_outlined,
              color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.7),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.24) ?? Colors.grey,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: ThemeProvider.primaryColor,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            filled: true,
            fillColor: Theme.of(context).cardColor,
          ),
          expiryDateDecoration: InputDecoration(
            labelText: 'Data de Validade',
            hintText: 'XX/XX',
            labelStyle: TextStyle(
              color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.7),
            ),
            hintStyle: TextStyle(
              color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.5),
            ),
            prefixIcon: Icon(
              Icons.calendar_today_outlined,
              color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.7),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.24) ?? Colors.grey,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: ThemeProvider.primaryColor,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            filled: true,
            fillColor: Theme.of(context).cardColor,
          ),
          cvvCodeDecoration: InputDecoration(
            labelText: 'CVV',
            hintText: 'XXX',
            labelStyle: TextStyle(
              color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.7),
            ),
            hintStyle: TextStyle(
              color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.5),
            ),
            prefixIcon: Icon(
              Icons.security_outlined,
              color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.7),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.24) ?? Colors.grey,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: ThemeProvider.primaryColor,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            filled: true,
            fillColor: Theme.of(context).cardColor,
          ),
          cardHolderDecoration: InputDecoration(
            labelText: 'Titular do Cartão',
            labelStyle: TextStyle(
              color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.7),
            ),
            prefixIcon: Icon(
              Icons.person_outline,
              color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.7),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.24) ?? Colors.grey,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: ThemeProvider.primaryColor,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            filled: true,
            fillColor: Theme.of(context).cardColor,
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
              colorFilter: ColorFilter.mode(
                Theme.of(context).textTheme.bodyMedium?.color ?? Colors.grey,
                BlendMode.srcIn,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              "Salvar Dados",
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Theme.of(context).textTheme.bodyMedium?.color,
                fontWeight: FontWeight.w600,
              ),
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

    return Glassmorphism(blurX: 8.0, blurY: 16.0, gradient: gradient);
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
        style: TextStyle(
          color: Theme.of(context).textTheme.bodyMedium?.color,
          fontWeight: FontWeight.w500,
        ),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(
            color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.7),
          ),
          prefixIcon: Icon(
            _getIconForField(label),
            color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.7),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.24) ?? Colors.grey,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: ThemeProvider.primaryColor,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          filled: true,
          fillColor: Theme.of(context).cardColor,
        ),
      ),
    );
  }

  IconData _getIconForField(String label) {
    switch (label.toLowerCase()) {
      case 'rua':
        return Icons.streetview_outlined;
      case 'número':
        return Icons.numbers_outlined;
      case 'bairro':
        return Icons.location_city_outlined;
      case 'cidade':
        return Icons.location_city_outlined;
      default:
        return Icons.edit_outlined;
    }
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
        style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
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
          Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).textTheme.bodySmall?.color,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              value,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }
}
