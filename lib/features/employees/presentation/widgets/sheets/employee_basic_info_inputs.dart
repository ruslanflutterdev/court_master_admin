import 'package:flutter/material.dart';
import '../../../../../core/presentation/widgets/custom_text_field.dart';

class EmployeeBasicInfoInputs extends StatelessWidget {
  final TextEditingController firstNameCtrl;
  final TextEditingController lastNameCtrl;
  final TextEditingController emailCtrl;
  final TextEditingController phoneCtrl;
  final TextEditingController passwordCtrl;

  const EmployeeBasicInfoInputs({
    super.key,
    required this.firstNameCtrl,
    required this.lastNameCtrl,
    required this.emailCtrl,
    required this.phoneCtrl,
    required this.passwordCtrl,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Основная информация',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: CustomTextField(
                controller: firstNameCtrl,
                label: 'Имя',
                prefixIcon: Icons.person,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: CustomTextField(
                controller: lastNameCtrl,
                label: 'Фамилия',
                prefixIcon: Icons.person_outline,
              ),
            ),
          ],
        ),
        CustomTextField(
          controller: emailCtrl,
          label: 'Email (для входа)',
          prefixIcon: Icons.email,
          keyboardType: TextInputType.emailAddress,
        ),
        CustomTextField(
          controller: phoneCtrl,
          label: 'Телефон',
          prefixIcon: Icons.phone,
          keyboardType: TextInputType.phone,
        ),
        CustomTextField(
          controller: passwordCtrl,
          label: 'Пароль',
          prefixIcon: Icons.lock,
          isPassword: true,
        ),
      ],
    );
  }
}
