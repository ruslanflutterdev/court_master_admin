import 'package:flutter/material.dart';
import '../../../../core/api/api_client.dart';
import '../../../../core/di/dependencies_container.dart';
import '../../data/models/coach_model.dart';

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
  late double _iStateTax;
  late double _iClubTax;
  late double _gStateTax;
  late double _gClubTax;
  late double _sStateTax;
  late double _sClubTax;
  late final TextEditingController _iStateTaxCtrl;
  late final TextEditingController _iClubTaxCtrl;
  late final TextEditingController _gStateTaxCtrl;
  late final TextEditingController _gClubTaxCtrl;
  late final TextEditingController _sStateTaxCtrl;
  late final TextEditingController _sClubTaxCtrl;

  @override
  void initState() {
    super.initState();
    _iStateTax = widget.coach.indivStateTaxRate;
    _iClubTax = widget.coach.indivClubTaxRate;
    _gStateTax = widget.coach.groupStateTaxRate;
    _gClubTax = widget.coach.groupClubTaxRate;
    _sStateTax = 0.0;
    _sClubTax = 0.0;

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
            content: Text('Условия сохранены!'),
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
                Center(
                  child: Column(
                    children: [
                      const CircleAvatar(
                        radius: 40,
                        backgroundColor: Colors.blue,
                        child: Icon(
                          Icons.sports_tennis,
                          size: 40,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        '${widget.coach.firstName} ${widget.coach.lastName}',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (widget.coach.specialization != null)
                        Text(
                          widget.coach.specialization!,
                          style: TextStyle(
                            color: Colors.blue.shade700,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                    ],
                  ),
                ),
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
                      onPressed: () {
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
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                LayoutBuilder(
                  builder: (context, constraints) {
                    if (constraints.maxWidth > 800) {
                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: _buildSalaryCard(
                              'Индивидуальные',
                              _iStateTaxCtrl,
                              _iClubTaxCtrl,
                              _iStateTax,
                              _iClubTax,
                              Colors.green,
                              stats['indivSalary'] ?? 0,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildSalaryCard(
                              'Абонементы (Группы)',
                              _gStateTaxCtrl,
                              _gClubTaxCtrl,
                              _gStateTax,
                              _gClubTax,
                              Colors.blue,
                              stats['groupSalary'] ?? 0,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildSalaryCard(
                              'Разовые тренировки',
                              _sStateTaxCtrl,
                              _sClubTaxCtrl,
                              _sStateTax,
                              _sClubTax,
                              Colors.orange,
                              stats['singleSalary'] ?? 0,
                            ),
                          ),
                        ],
                      );
                    }
                    return Column(
                      children: [
                        _buildSalaryCard(
                          'Индивидуальные',
                          _iStateTaxCtrl,
                          _iClubTaxCtrl,
                          _iStateTax,
                          _iClubTax,
                          Colors.green,
                          stats['indivSalary'] ?? 0,
                        ),
                        const SizedBox(height: 12),
                        _buildSalaryCard(
                          'Абонементы (Группы)',
                          _gStateTaxCtrl,
                          _gClubTaxCtrl,
                          _gStateTax,
                          _gClubTax,
                          Colors.blue,
                          stats['groupSalary'] ?? 0,
                        ),
                        const SizedBox(height: 12),
                        _buildSalaryCard(
                          'Разовые тренировки',
                          _sStateTaxCtrl,
                          _sClubTaxCtrl,
                          _sStateTax,
                          _sClubTax,
                          Colors.orange,
                          stats['singleSalary'] ?? 0,
                        ),
                      ],
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

  Widget _buildSalaryCard(
    String title,
    TextEditingController stateCtrl,
    TextEditingController clubCtrl,
    double stateVal,
    double clubVal,
    Color color,
    num earnedSalary,
  ) {
    return Card(
      elevation: 0,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: color.withAlpha(50), width: 2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Row(
                  children: [
                    Icon(Icons.monetization_on, color: color),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        title,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: color.withAlpha(200),
                        ),
                      ),
                    ),
                  ],
                ),
                const Divider(height: 24),
                _buildRowItem('Налог гос-ва:', stateCtrl, stateVal),
                _buildRowItem('Налог клуба:', clubCtrl, clubVal),
              ],
            ),
          ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            color: color.withAlpha(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Заработано:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: color.withAlpha(200),
                  ),
                ),
                Text(
                  '$earnedSalary ₸',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: color,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRowItem(
    String label,
    TextEditingController controller,
    double value,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
            ),
          ),
          Expanded(
            flex: 1,
            child: _isEditing
                ? SizedBox(
                    height: 35,
                    child: TextFormField(
                      controller: controller,
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.zero,
                        border: OutlineInputBorder(),
                        suffixText: '%',
                      ),
                    ),
                  )
                : Text(
                    '${value.toInt()}%',
                    textAlign: TextAlign.right,
                    style: const TextStyle(fontSize: 16),
                  ),
          ),
        ],
      ),
    );
  }
}
