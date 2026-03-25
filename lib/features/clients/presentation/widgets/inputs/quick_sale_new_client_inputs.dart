import 'package:flutter/material.dart';
import '../../../../../core/presentation/widgets/custom_text_field.dart';
import '../../../../../core/presentation/widgets/custom_dropdown.dart';

class QuickSaleNewClientInputs extends StatefulWidget {
  final TextEditingController firstNameCtrl;
  final TextEditingController lastNameCtrl;
  final TextEditingController phoneCtrl;
  final TextEditingController companyCtrl;
  final TextEditingController innCtrl;
  final TextEditingController kppCtrl;
  final ValueChanged<bool> onCorporateChanged;
  final ValueChanged<String?> onSkillChanged;
  final ValueChanged<String?> onSourceChanged;

  const QuickSaleNewClientInputs({
    super.key,
    required this.firstNameCtrl,
    required this.lastNameCtrl,
    required this.phoneCtrl,
    required this.companyCtrl,
    required this.innCtrl,
    required this.kppCtrl,
    required this.onCorporateChanged,
    required this.onSkillChanged,
    required this.onSourceChanged,
  });

  @override
  State<QuickSaleNewClientInputs> createState() =>
      _QuickSaleNewClientInputsState();
}

class _QuickSaleNewClientInputsState extends State<QuickSaleNewClientInputs> {
  bool _isCorporate = false;
  String? _skillLevel;
  String? _source;

  void _toggleCorporate(bool value) {
    setState(() => _isCorporate = value);
    widget.onCorporateChanged(value);
  }

  void _changeSkill(String? val) {
    setState(() => _skillLevel = val);
    widget.onSkillChanged(val);
  }

  void _changeSource(String? val) {
    setState(() => _source = val);
    widget.onSourceChanged(val);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomTextField(controller: widget.firstNameCtrl, label: 'Имя *'),
        CustomTextField(controller: widget.lastNameCtrl, label: 'Фамилия *'),
        CustomTextField(
          controller: widget.phoneCtrl,
          label: 'Телефон',
          keyboardType: TextInputType.phone,
        ),
        const SizedBox(height: 16),

        CustomDropdown<String>(
          value: _skillLevel,
          items: const ['Новичок', 'Любитель', 'Профи'],
          onChanged: _changeSkill,
          label: 'Уровень игры',
          itemLabelBuilder: (v) => v,
        ),
        const SizedBox(height: 16),
        CustomDropdown<String>(
          value: _source,
          items: const ['Instagram', 'Рекомендация', 'Google', 'Мимо проходил'],
          onChanged: _changeSource,
          label: 'Источник',
          itemLabelBuilder: (v) => v,
        ),
        const SizedBox(height: 16),

        SwitchListTile(
          title: const Text(
            'Юридическое лицо',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          value: _isCorporate,
          onChanged: _toggleCorporate,
          contentPadding: EdgeInsets.zero,
        ),
        if (_isCorporate) ...[
          CustomTextField(
            controller: widget.companyCtrl,
            label: 'Название компании *',
          ),
          Row(
            children: [
              Expanded(
                child: CustomTextField(
                  controller: widget.innCtrl,
                  label: 'ИНН',
                  keyboardType: TextInputType.number,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: CustomTextField(
                  controller: widget.kppCtrl,
                  label: 'КПП',
                  keyboardType: TextInputType.number,
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }
}
