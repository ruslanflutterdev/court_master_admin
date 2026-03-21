import 'package:flutter/material.dart';
import '../../../../core/api/api_client.dart';
import '../../../../core/di/dependencies_container.dart';
import '../../data/models/coach_model.dart';
import '../widgets/coach_profile/coach_profile_header.dart';
import '../widgets/coach_profile/coach_salary_card.dart';

class AdminCoachProfileScreen extends StatefulWidget {
  final CoachModel coach;
  const AdminCoachProfileScreen({super.key, required this.coach});

  @override
  State<AdminCoachProfileScreen> createState() =>
      _AdminCoachProfileScreenState();
}

class _AdminCoachProfileScreenState extends State<AdminCoachProfileScreen> {
  bool _isLoading = false;
  bool _isEditing = false;

  late double _iStateTax,
      _iClubTax,
      _gStateTax,
      _gClubTax,
      _sStateTax,
      _sClubTax;
  late final TextEditingController _iStateTaxCtrl,
      _iClubTaxCtrl,
      _gStateTaxCtrl,
      _gClubTaxCtrl,
      _sStateTaxCtrl,
      _sClubTaxCtrl;

  @override
  void initState() {
    super.initState();
    _iStateTax = widget.coach.indivStateTaxRate;
    _iClubTax = widget.coach.indivClubTaxRate;
    _gStateTax = widget.coach.groupStateTaxRate;
    _gClubTax = widget.coach.groupClubTaxRate;
    _sStateTax = widget.coach.singleStateTaxRate;
    _sClubTax = widget.coach.singleClubTaxRate;

    _iStateTaxCtrl = TextEditingController(text: _iStateTax.toInt().toString());
    _iClubTaxCtrl = TextEditingController(text: _iClubTax.toInt().toString());
    _gStateTaxCtrl = TextEditingController(text: _gStateTax.toInt().toString());
    _gClubTaxCtrl = TextEditingController(text: _gClubTax.toInt().toString());
    _sStateTaxCtrl = TextEditingController(text: _sStateTax.toInt().toString());
    _sClubTaxCtrl = TextEditingController(text: _sClubTax.toInt().toString());
  }

  @override
  void dispose() {
    _iStateTaxCtrl.dispose();
    _iClubTaxCtrl.dispose();
    _gStateTaxCtrl.dispose();
    _gClubTaxCtrl.dispose();
    _sStateTaxCtrl.dispose();
    _sClubTaxCtrl.dispose();
    super.dispose();
  }

  Future<Map<String, dynamic>> _fetchStats() async {
    final response = await sl<ApiClient>().dio.get(
      '/employees/${widget.coach.id}/stats',
    );
    return response.data;
  }

  Future<void> _saveSalarySettings() async {
    setState(() => _isLoading = true);
    try {
      final iState = double.tryParse(_iStateTaxCtrl.text) ?? 0;
      final iClub = double.tryParse(_iClubTaxCtrl.text) ?? 0;
      final gState = double.tryParse(_gStateTaxCtrl.text) ?? 0;
      final gClub = double.tryParse(_gClubTaxCtrl.text) ?? 0;
      final sState = double.tryParse(_sStateTaxCtrl.text) ?? 0;
      final sClub = double.tryParse(_sClubTaxCtrl.text) ?? 0;

      await sl<ApiClient>().dio.put(
        '/employees/${widget.coach.id}',
        data: {
          'indivStateTaxRate': iState,
          'indivClubTaxRate': iClub,
          'groupStateTaxRate': gState,
          'groupClubTaxRate': gClub,
          'singleStateTaxRate': sState,
          'singleClubTaxRate': sClub,
        },
      );

      _iStateTax = iState;
      _iClubTax = iClub;
      _gStateTax = gState;
      _gClubTax = gClub;
      _sStateTax = sState;
      _sClubTax = sClub;

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Сохранено!'),
            backgroundColor: Colors.green,
          ),
        );
        setState(() => _isEditing = false);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Ошибка: $e'), backgroundColor: Colors.red),
        );
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _toggleEdit() {
    setState(() {
      if (_isEditing) {
        _iStateTaxCtrl.text = _iStateTax.toInt().toString();
        _iClubTaxCtrl.text = _iClubTax.toInt().toString();
        _gStateTaxCtrl.text = _gStateTax.toInt().toString();
        _gClubTaxCtrl.text = _gClubTax.toInt().toString();
        _sStateTaxCtrl.text = _sStateTax.toInt().toString();
        _sClubTaxCtrl.text = _sClubTax.toInt().toString();
      }
      _isEditing = !_isEditing;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Профиль тренера')),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _fetchStats(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final stats = snapshot.data ?? {};

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CoachProfileHeader(coach: widget.coach),
                const Divider(height: 40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Договор и Начисления',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        _isEditing ? Icons.close : Icons.edit,
                        color: _isEditing ? Colors.red : Colors.blue,
                      ),
                      onPressed: _toggleEdit,
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                LayoutBuilder(
                  builder: (context, constraints) {
                    final cards = [
                      CoachSalaryCard(
                        title: 'Индивидуальные',
                        stateCtrl: _iStateTaxCtrl,
                        clubCtrl: _iClubTaxCtrl,
                        stateVal: _iStateTax,
                        clubVal: _iClubTax,
                        color: Colors.green,
                        earnedSalary: stats['indivSalary'] ?? 0,
                        isEditing: _isEditing,
                      ),
                      CoachSalaryCard(
                        title: 'Абонементы (Группы)',
                        stateCtrl: _gStateTaxCtrl,
                        clubCtrl: _gClubTaxCtrl,
                        stateVal: _gStateTax,
                        clubVal: _gClubTax,
                        color: Colors.blue,
                        earnedSalary: stats['groupSalary'] ?? 0,
                        isEditing: _isEditing,
                      ),
                      CoachSalaryCard(
                        title: 'Разовые тренировки',
                        stateCtrl: _sStateTaxCtrl,
                        clubCtrl: _sClubTaxCtrl,
                        stateVal: _sStateTax,
                        clubVal: _sClubTax,
                        color: Colors.orange,
                        earnedSalary: stats['singleSalary'] ?? 0,
                        isEditing: _isEditing,
                      ),
                    ];
                    if (constraints.maxWidth > 800) {
                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: cards
                            .map(
                              (c) => Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 6,
                                  ),
                                  child: c,
                                ),
                              ),
                            )
                            .toList(),
                      );
                    }
                    return Column(
                      children: cards
                          .map(
                            (c) => Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: c,
                            ),
                          )
                          .toList(),
                    );
                  },
                ),
                if (_isEditing) ...[
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      icon: _isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Icon(Icons.save, color: Colors.white),
                      label: const Text(
                        'Сохранить налоги',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      onPressed: _isLoading ? null : _saveSalarySettings,
                    ),
                  ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }
}
