import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../../core/presentation/widgets/primary_button.dart';
import '../../../data/models/client_model.dart';
import '../../bloc/clients_bloc.dart';
import '../../bloc/clients_event.dart';
import 'quick_sale_client_section.dart';
import 'quick_sale_order_section.dart';

class QuickSaleSheet extends StatefulWidget {
  const QuickSaleSheet({super.key});

  @override
  State<QuickSaleSheet> createState() => _QuickSaleSheetState();
}

class _QuickSaleSheetState extends State<QuickSaleSheet> {
  final _formKey = GlobalKey<FormState>();
  ClientModel? _selectedClient;
  final _fNameCtrl = TextEditingController();
  final _lNameCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _companyCtrl = TextEditingController();
  final _innCtrl = TextEditingController();
  final _kppCtrl = TextEditingController();
  bool _isCorporate = false;
  String? _skillLevel;
  String? _source;
  final _priceCtrl = TextEditingController();
  final _rentPriceCtrl = TextEditingController();
  final _coachPriceCtrl = TextEditingController();

  String _saleType = 'rent';
  int _classesCount = 8;
  int _payMethod = 1;
  String? _coachId;

  @override
  void dispose() {
    _fNameCtrl.dispose();
    _lNameCtrl.dispose();
    _phoneCtrl.dispose();
    _companyCtrl.dispose();
    _innCtrl.dispose();
    _kppCtrl.dispose();
    _priceCtrl.dispose();
    _rentPriceCtrl.dispose();
    _coachPriceCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    final needsCoach = [
      'indiv_training',
      'group_sub',
      'indiv_sub',
      'single',
    ].contains(_saleType);
    if (needsCoach && _coachId == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Выберите тренера!')));
      return;
    }

    final data = {
      'isNewClient': _selectedClient == null,
      'clientId': _selectedClient?.id,
      'firstName': _fNameCtrl.text.trim(),
      'lastName': _lNameCtrl.text.trim(),
      'phone': _phoneCtrl.text.trim(),
      'isCorporate': _isCorporate,
      'companyName': _isCorporate ? _companyCtrl.text.trim() : null,
      'inn': _isCorporate ? _innCtrl.text.trim() : null,
      'kpp': _isCorporate ? _kppCtrl.text.trim() : null,
      'skillLevel': _skillLevel,
      'acquisitionSource': _source,
      'saleCategory': _saleType,
      'paymentMethod': _payMethod,
      'coachId': _coachId,
      'price': _saleType == 'indiv_training'
          ? 0
          : (int.tryParse(_priceCtrl.text) ?? 0),
      'rentPrice': int.tryParse(_rentPriceCtrl.text) ?? 0,
      'coachPrice': int.tryParse(_coachPriceCtrl.text) ?? 0,
      'totalClasses': (_saleType == 'group_sub' || _saleType == 'indiv_sub')
          ? _classesCount
          : 1,
    };

    context.read<ClientsBloc>().add(QuickSaleRequested(data));
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    return Padding(
      padding: EdgeInsets.fromLTRB(16, 16, 16, bottomInset + 16),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Row(
                children: [
                  Icon(Icons.flash_on, color: Colors.orange),
                  SizedBox(width: 8),
                  Text(
                    'Быстрая продажа',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const Divider(height: 32),
              QuickSaleClientSection(
                selectedClient: _selectedClient,
                onClientSelected: (c) => setState(() => _selectedClient = c),
                firstNameCtrl: _fNameCtrl,
                lastNameCtrl: _lNameCtrl,
                phoneCtrl: _phoneCtrl,
                companyCtrl: _companyCtrl,
                innCtrl: _innCtrl,
                kppCtrl: _kppCtrl,
                onCorporateChanged: (v) => setState(() => _isCorporate = v),
                onSkillChanged: (v) => setState(() => _skillLevel = v),
                onSourceChanged: (v) => setState(() => _source = v),
              ),
              const SizedBox(height: 24),
              QuickSaleOrderSection(
                saleType: _saleType,
                paymentMethod: _payMethod,
                classesCount: _classesCount,
                selectedCoachId: _coachId,
                onTypeChanged: (v) => setState(() => _saleType = v),
                onMethodChanged: (v) => setState(() => _payMethod = v),
                onClassesChanged: (v) => setState(() => _classesCount = v),
                onCoachChanged: (v) => setState(() => _coachId = v),
                priceCtrl: _priceCtrl,
                rentPriceCtrl: _rentPriceCtrl,
                coachPriceCtrl: _coachPriceCtrl,
              ),
              const SizedBox(height: 24),
              PrimaryButton(
                text: 'Провести продажу',
                color: Colors.orange,
                onPressed: _submit,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
