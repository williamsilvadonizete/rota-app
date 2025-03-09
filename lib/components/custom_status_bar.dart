import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:rota_app/constants.dart';

class CustomStatusAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  final Size preferredSize;

  final bool showBackButton;

  const CustomStatusAppBar({super.key, this.showBackButton = false})
      : preferredSize = const Size.fromHeight(140.0); // Tamanho total do AppBar

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: primaryColor,
      centerTitle: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
      ),
      leading: showBackButton
          ? IconButton(
              onPressed: () => Navigator.of(context).pop(),
              icon: const Icon(Icons.arrow_back, color: primaryColorDark),
            )
          : IconButton(
              onPressed: () {},
              icon: const Icon(Icons.subject, color: primaryColorDark),
            ),
      actions: [
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.notifications, size: 20),
        ),
      ],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(110.0),
        child: Padding(
          padding: const EdgeInsets.only(left: 30, bottom: 20),
          child: _buildUserInfo(),
        ),
      ),
    );
  }

  Widget _buildUserInfo() {
    return Row(
      children: [
        Stack(
          children: [
           Container(
              width: 80, 
              height: 80,
              decoration: const BoxDecoration(
                color: primaryColor,
                shape: BoxShape.circle,
              ),
              child: SvgPicture.asset(
                "assets/icons/logo.svg",
                fit: BoxFit.contain, 
              ),
            ),
          ],
        ),
        const SizedBox(width: 20),
        const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'William Silva',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: primaryColorDark,
              ),
            ),
            Text(
              'Uberlândia',
              style: TextStyle(fontSize: 18, color: primaryColorDark),
            ),
            
          ],
        ),
      ],
    );
  }
}
