import 'package:flutter/material.dart';

class AjukanSakitSuratPage extends StatefulWidget {
  const AjukanSakitSuratPage({super.key});

  @override
  State<AjukanSakitSuratPage> createState() => _AjukanSakitSuratPageState();
}

class _AjukanSakitSuratPageState extends State<AjukanSakitSuratPage> {
  DateTime? _startDate;
  DateTime? _endDate;

  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2101),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF2563EB),
              onPrimary: Colors.white,
              onSurface: Color(0xFF0F172A),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        if (isStartDate) {
          _startDate = picked;
        } else {
          _endDate = picked;
        }
      });
    }
  }

  String _formatDate(DateTime? date) {
    if (date == null) return 'Pilih Tanggal';
    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun',
      'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des'
    ];
    return "${date.day} ${months[date.month - 1]} ${date.year}";
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF2563EB)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Pengajuan Izin Sakit (Surat)',
          style: TextStyle(
            color: Color(0xFF0F172A),
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Pengajuan Izin Sakit\n(Surat)',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.w900,
                color: Color(0xFF0F172A),
                letterSpacing: -1,
                height: 1.1,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Silakan lengkapi formulir di bawah dengan melampirkan surat keterangan dokter yang sah.',
              style: TextStyle(
                fontSize: 14,
                color: Color(0xFF64748B),
                fontWeight: FontWeight.w500,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 32),
            
            // Form Card
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 15,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Start Date
                  _buildFormLabel('Tanggal Mulai Izin'),
                  const SizedBox(height: 10),
                  _buildDatePickerField(
                    _formatDate(_startDate),
                    isPlaceholder: _startDate == null,
                    onTap: () => _selectDate(context, true),
                  ),
                  const SizedBox(height: 6),
                  _buildHelpText('Pilih tanggal awal sakit Anda'),
                  
                  const SizedBox(height: 24),
                  
                  // End Date
                  _buildFormLabel('Tanggal Selesai Izin'),
                  const SizedBox(height: 10),
                  _buildDatePickerField(
                    _formatDate(_endDate),
                    isPlaceholder: _endDate == null,
                    onTap: () => _selectDate(context, false),
                  ),
                  const SizedBox(height: 6),
                  _buildHelpText('Pilih estimasi tanggal sembuh'),
                  
                  const SizedBox(height: 24),
                  
                  // Attachment
                  _buildFormLabel('Dokumen Pendukung'),
                  const SizedBox(height: 10),
                  _buildUploadField(),
                  const SizedBox(height: 6),
                  _buildHelpText('Unggah foto/file surat keterangan dokter'),
                  
                  const SizedBox(height: 24),
                  
                  // Description
                  _buildFormLabel('Alasan / Deskripsi'),
                  const SizedBox(height: 10),
                  _buildTextAreaField(
                    hint: 'Berikan deskripsi singkat kondisi Anda...',
                    icon: Icons.notes_rounded,
                  ),
                  const SizedBox(height: 6),
                  _buildHelpText('Contoh: Gejala flu dan demam tinggi'),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Policy Alert
            _buildPolicyAlert(),
            
            const SizedBox(height: 32),
            
            // Submit Button
            _buildSubmitButton(),
            
            const SizedBox(height: 48),
          ],
        ),
      ),
    );
  }

  Widget _buildFormLabel(String label) {
    return Text(
      label,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.bold,
        color: Color(0xFF334155),
      ),
    );
  }

  Widget _buildHelpText(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 2),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 11,
          color: Color(0xFF64748B),
          height: 1.4,
        ),
      ),
    );
  }

  Widget _buildDatePickerField(String value, {bool isPlaceholder = false, VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: const Color(0xFFF1F5F9),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.black.withOpacity(0.05)),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                value,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: isPlaceholder ? FontWeight.w500 : FontWeight.bold,
                  color: isPlaceholder ? const Color(0xFF94A3B8) : const Color(0xFF1E293B),
                ),
              ),
            ),
            Icon(
              Icons.calendar_today_rounded,
              color: isPlaceholder ? const Color(0xFF94A3B8) : const Color(0xFF2563EB),
              size: 18,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextAreaField({required String hint, required IconData icon}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      height: 120,
      decoration: BoxDecoration(
        color: const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.black.withOpacity(0.05)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: TextField(
              maxLines: null,
              decoration: InputDecoration(
                hintText: hint,
                hintStyle: const TextStyle(
                  color: Color(0xFF94A3B8),
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
                border: InputBorder.none,
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 2),
            child: Icon(icon, color: const Color(0xFF94A3B8), size: 18),
          ),
        ],
      ),
    );
  }

  Widget _buildUploadField() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFCBD5E1),
        ),
      ),
      child: const Column(
        children: [
          Icon(Icons.cloud_upload_outlined, color: Color(0xFF2563EB), size: 40),
          SizedBox(height: 12),
          Text(
            'Klik untuk unggah surat dokter',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1E293B),
            ),
          ),
          SizedBox(height: 4),
          Text(
            'PDF, JPG, PNG (Maks. 5MB)',
            style: TextStyle(
              fontSize: 12,
              color: Color(0xFF64748B),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPolicyAlert() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFEFF6FF),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFDBEAFE)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.info_outline_rounded, color: Color(0xFF2563EB), size: 24),
          const SizedBox(width: 16),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'KEBIJAKAN PERUSAHAAN',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF1E40AF),
                    letterSpacing: 0.5,
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  'Pengajuan izin sakit dengan surat maksimal dilakukan 7 hari kerja setelah tanggal ketidakhadiran.',
                  style: TextStyle(
                    fontSize: 12,
                    color: Color(0xFF1E40AF),
                    height: 1.6,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubmitButton() {
    return Container(
      width: double.infinity,
      height: 56,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: const LinearGradient(
          colors: [Color(0xFF2563EB), Color(0xFF1E40AF)],
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF2563EB).withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
        onTap: () {
          Navigator.pop(context);
        },
          borderRadius: BorderRadius.circular(16),
          child: const Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Ajukan Izin',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(width: 8),
                Icon(Icons.send_rounded, color: Colors.white, size: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
