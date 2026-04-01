import 'package:flutter/material.dart';

class AjukanCutiPage extends StatefulWidget {
  const AjukanCutiPage({super.key});

  @override
  State<AjukanCutiPage> createState() => _AjukanCutiPageState();
}

class _AjukanCutiPageState extends State<AjukanCutiPage> {
  String? _selectedLeaveType;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF0F172A)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Ajukan Cuti',
          style: TextStyle(
            color: Color(0xFF0F172A),
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'PERMOHONAN BARU',
              style: TextStyle(
                color: Color(0xFF2563EB),
                fontSize: 12,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Formulir Cuti',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.w900,
                color: Color(0xFF0F172A),
                letterSpacing: -1,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Pastikan semua data terisi dengan benar sebelum mengirim pengajuan.',
              style: TextStyle(
                fontSize: 14,
                color: Color(0xFF64748B),
                fontWeight: FontWeight.w500,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 32),
            
            // Container for form
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
                  _buildFormLabel('Tanggal Mulai Cuti'),
                  const SizedBox(height: 10),
                  _buildDatePickerField('12 Okt 2023'),
                  const SizedBox(height: 6),
                  _buildHelpText('Pilih tanggal awal cuti Anda'),
                  
                  const SizedBox(height: 24),
                  
                  // End Date
                  _buildFormLabel('Tanggal Selesai Cuti'),
                  const SizedBox(height: 10),
                  _buildDatePickerField('Pilih Tanggal', isPlaceholder: true),
                  const SizedBox(height: 6),
                  _buildHelpText('Pilih tanggal terakhir cuti Anda'),
                  _buildHelpText('Untuk cuti satu hari, isikan dengan tanggal yang sama dengan tanggal mulai cuti.'),
                  
                  const SizedBox(height: 24),
                  
                  // Leave Type
                  _buildFormLabel('Jenis Cuti'),
                  const SizedBox(height: 10),
                  _buildDropdownField(),
                  const SizedBox(height: 6),
                  _buildHelpText('Tentukan kategori keperluan cuti'),
                  
                  const SizedBox(height: 24),
                  
                  // Notes
                  _buildFormLabel('Keterangan'),
                  const SizedBox(height: 10),
                  _buildTextAreaField(),
                  const SizedBox(height: 6),
                  _buildHelpText('Berikan penjelasan singkat mengenai permohonan Anda'),
                  
                  const SizedBox(height: 24),
                  
                  // Attachment
                  _buildFormLabel('Lampiran File Pendukung'),
                  const SizedBox(height: 10),
                  _buildUploadField(),
                  const SizedBox(height: 6),
                  _buildHelpText('Unggah dokumen pendukung jika diperlukan (misal: surat keterangan dokter)'),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Info Alert
            _buildInfoBanner(),
            
            const SizedBox(height: 32),
            
            // Submit Button
            _buildSubmitButton(),
            
            const SizedBox(height: 40),
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

  Widget _buildDatePickerField(String value, {bool isPlaceholder = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const Icon(Icons.calendar_today_outlined, color: Color(0xFF64748B), size: 18),
          const SizedBox(width: 12),
          Text(
            value,
            style: TextStyle(
              fontSize: 15,
              fontWeight: isPlaceholder ? FontWeight.w500 : FontWeight.bold,
              color: isPlaceholder ? const Color(0xFF94A3B8) : const Color(0xFF1E293B),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdownField() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const Icon(Icons.category_outlined, color: Color(0xFF64748B), size: 18),
          const SizedBox(width: 12),
          Expanded(
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _selectedLeaveType,
                hint: const Text(
                  'Pilih Jenis Cuti',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF94A3B8),
                  ),
                ),
                isExpanded: true,
                icon: const Icon(Icons.keyboard_arrow_down_rounded, color: Color(0xFF64748B)),
                items: ['Cuti Tahunan', 'Cuti Sakit', 'Cuti Melahirkan', 'Izin Penting']
                    .map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(
                      value,
                      style: const TextStyle(fontSize: 15, color: Color(0xFF1E293B)),
                    ),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    _selectedLeaveType = newValue;
                  });
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextAreaField() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      height: 120,
      decoration: BoxDecoration(
        color: const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(12),
      ),
      child: const TextField(
        maxLines: null,
        decoration: InputDecoration(
          hintText: 'Alasan cuti...',
          hintStyle: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w500,
            color: Color(0xFF94A3B8),
          ),
          border: InputBorder.none,
          contentPadding: EdgeInsets.zero,
        ),
      ),
    );
  }

  Widget _buildUploadField() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 24),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFFCBD5E1),
          style: BorderStyle.solid, // Should be dashed, but Flutter requires custom painter for dashed
        ),
      ),
      child: const Column(
        children: [
          Icon(Icons.cloud_upload_outlined, color: Color(0xFF64748B), size: 36),
          SizedBox(height: 12),
          Text(
            'Unggah File',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1E293B),
            ),
          ),
          SizedBox(height: 4),
          Text(
            'PDF, JPG, atau PNG (Maks. 5MB)',
            style: TextStyle(
              fontSize: 12,
              color: Color(0xFF64748B),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoBanner() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFE0F7FA),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFB2EBF2)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.info_outline_rounded, color: Color(0xFF00ACC1), size: 24),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Informasi Sisa Cuti',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF006064),
                  ),
                ),
                SizedBox(height: 4),
                Text.rich(
                  TextSpan(
                    text: 'Anda masih memiliki ',
                    style: TextStyle(fontSize: 12, color: Color(0xFF006064)),
                    children: [
                      TextSpan(
                        text: '12 hari',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextSpan(text: ' sisa cuti tahunan yang dapat digunakan.'),
                    ],
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
          onTap: () {},
          borderRadius: BorderRadius.circular(16),
          child: const Center(
            child: Text(
              'Ajukan Cuti',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
