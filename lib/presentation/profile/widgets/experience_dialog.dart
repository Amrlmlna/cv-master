import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../domain/entities/user_profile.dart';
import '../../common/widgets/custom_text_form_field.dart';

class ExperienceDialog extends StatefulWidget {
  final Experience? existing;

  const ExperienceDialog({super.key, this.existing});

  @override
  State<ExperienceDialog> createState() => _ExperienceDialogState();
}

class _ExperienceDialogState extends State<ExperienceDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleCtrl;
  late TextEditingController _companyCtrl;
  late TextEditingController _startCtrl;
  late TextEditingController _endCtrl;
  late TextEditingController _descCtrl;

  @override
  void initState() {
    super.initState();
    _titleCtrl = TextEditingController(text: widget.existing?.jobTitle);
    _companyCtrl = TextEditingController(text: widget.existing?.companyName);
    _startCtrl = TextEditingController(text: widget.existing?.startDate);
    _endCtrl = TextEditingController(text: widget.existing?.endDate);
    _descCtrl = TextEditingController(text: widget.existing?.description);
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _companyCtrl.dispose();
    _startCtrl.dispose();
    _endCtrl.dispose();
    _descCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickDate(TextEditingController controller) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: const ColorScheme.dark(
              primary: Colors.white,
              onPrimary: Colors.black,
              surface: Color(0xFF1E1E1E),
              onSurface: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      // Format: MMM yyyy (e.g. Jan 2024)
      controller.text = DateFormat('MMM yyyy').format(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: const Color(0xFF1E1E1E), // Dark Card
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Text(
        widget.existing == null ? 'TAMBAH PENGALAMAN' : 'EDIT PENGALAMAN',
        style: const TextStyle(
          color: Colors.white, 
          fontWeight: FontWeight.w900, 
          fontSize: 18,
          letterSpacing: 1.0,
        ),
      ),
      content: SizedBox(
        width: double.maxFinite,
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomTextFormField(
                  controller: _titleCtrl,
                  labelText: 'Posisi / Jabatan',
                  hintText: 'Software Engineer',
                  isDark: true,
                  validator: (v) => v!.isEmpty ? 'Wajib diisi' : null,
                ),
                const SizedBox(height: 16),
                CustomTextFormField(
                  controller: _companyCtrl,
                  labelText: 'Perusahaan',
                  hintText: 'PT Teknologi Maju',
                  isDark: true,
                  validator: (v) => v!.isEmpty ? 'Wajib diisi' : null,
                ),
                const SizedBox(height: 16),
                
                // Dates - Full Width for better UX
                Row(
                  children: [
                    Expanded(
                      child: CustomTextFormField(
                        controller: _startCtrl,
                        labelText: 'Mulai',
                        hintText: 'Pilih Tanggal',
                        isDark: true,
                        readOnly: true,
                        prefixIcon: Icons.calendar_today,
                        onTap: () => _pickDate(_startCtrl),
                        validator: (v) => v!.isEmpty ? 'Wajib diisi' : null,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: CustomTextFormField(
                        controller: _endCtrl,
                        labelText: 'Selesai',
                        hintText: 'Sampai Sekarang',
                        isDark: true,
                        readOnly: true,
                        prefixIcon: Icons.event,
                        onTap: () => _pickDate(_endCtrl),
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 16),
                CustomTextFormField(
                  controller: _descCtrl,
                  labelText: 'Deskripsi Singkat',
                  hintText: 'Jelaskan tanggung jawab utama dan pencapaianmu...',
                  isDark: true,
                  maxLines: 4,
                  validator: (v) => v!.isEmpty ? 'Wajib diisi' : null,
                ),
              ],
            ),
          ),
        ),
      ),
      actionsPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context), 
          style: TextButton.styleFrom(foregroundColor: Colors.white54),
          child: const Text('BATAL'),
        ),
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              final exp = Experience(
                jobTitle: _titleCtrl.text,
                companyName: _companyCtrl.text,
                startDate: _startCtrl.text,
                endDate: _endCtrl.text.isEmpty ? null : _endCtrl.text,
                description: _descCtrl.text,
              );
              Navigator.pop(context, exp);
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
          child: const Text('SIMPAN', style: TextStyle(fontWeight: FontWeight.bold)),
        ),
      ],
    );
  }
}
