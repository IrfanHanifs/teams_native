import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AjukanCutiPage extends StatefulWidget {
  const AjukanCutiPage({super.key});

  @override
  State<AjukanCutiPage> createState() => _AjukanCutiPageState();
}

class _AjukanCutiPageState extends State<AjukanCutiPage> {
  String? _selectedLeaveType;
  DateTime? _startDate;
  DateTime? _endDate;
  String? _fileName;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickFile() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _fileName = pickedFile.name;
      });
    }
  }

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
                  _buildDatePickerField(
                    _formatDate(_startDate),
                    isPlaceholder: _startDate == null,
                    onTap: () => _selectDate(context, true),
                  ),
                  const SizedBox(height: 6),
                  _buildHelpText('Pilih tanggal awal cuti Anda'),
                  
                  const SizedBox(height: 24),
                  
                  // End Date
                  _buildFormLabel('Tanggal Selesai Cuti'),
                  const SizedBox(height: 10),
                  _buildDatePickerField(
                    _formatDate(_endDate),
                    isPlaceholder: _endDate == null,
                    onTap: () => _selectDate(context, false),
                  ),
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
                  _buildTextAreaField(
                    hint: 'Alasan cuti...',
                    icon: Icons.notes_rounded,
                  ),
                  const SizedBox(height: 6),
                  _buildHelpText('Berikan penjelasan singkat mengenai permohonan Anda'),
                  
                  const SizedBox(height: 24),
                  
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

  Widget _buildDropdownField() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.black.withOpacity(0.05)),
      ),
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
          icon: const Icon(Icons.keyboard_arrow_down_rounded, color: Color(0xFF2563EB)),
          dropdownColor: Colors.white,
          borderRadius: BorderRadius.circular(16),
          items: ['Cuti Tahunan', 'Cuti Sakit', 'Cuti Melahirkan', 'Izin Penting']
              .map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  children: [
                    Icon(
                      _getIconForType(value),
                      size: 18,
                      color: const Color(0xFF2563EB),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      value,
                      style: const TextStyle(
                        fontSize: 15,
                        color: Color(0xFF1E293B),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
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
    );
  }

  IconData _getIconForType(String type) {
    switch (type) {
      case 'Cuti Tahunan':
        return Icons.calendar_month_rounded;
      case 'Cuti Sakit':
        return Icons.medical_information_rounded;
      case 'Cuti Melahirkan':
        return Icons.child_friendly_rounded;
      case 'Izin Penting':
        return Icons.priority_high_rounded;
      default:
        return Icons.category_rounded;
    }
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
    return InkWell(
      onTap: _pickFile,
      child: CustomPaint(
        painter: DashRectPainter(color: const Color(0xFFCBD5E1)),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 24),
          decoration: BoxDecoration(
            color: const Color(0xFFF8FAFC),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              Icon(
                _fileName != null ? Icons.insert_drive_file_rounded : Icons.cloud_upload_outlined,
                color: const Color(0xFF2563EB),
                size: 32,
              ),
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  _fileName ?? 'Pilih File Lampiran',
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: _fileName != null ? const Color(0xFF1E293B) : const Color(0xFF64748B),
                  ),
                ),
              ),
              if (_fileName == null) ...[
                const SizedBox(height: 4),
                const Text(
                  'Format: JPG atau PNG (Maks. 5MB)',
                  style: TextStyle(
                    fontSize: 11,
                    color: Color(0xFF94A3B8),
                  ),
                ),
              ] else ...[
                const SizedBox(height: 4),
                const Text(
                  'Klik untuk mengganti file',
                  style: TextStyle(
                    fontSize: 11,
                    color: Color(0xFF2563EB),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ],
          ),
        ),
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

class DashRectPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final double gap;

  DashRectPainter({this.color = Colors.black, this.strokeWidth = 1.0, this.gap = 5.0});

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    Path path = Path();
    path.addRRect(RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.width, size.height),
      const Radius.circular(12),
    ));

    Path dashPath = Path();
    double dashWidth = 10.0;
    double dashGap = 5.0;

    for (PathMetric pathMetric in path.computeMetrics()) {
      double distance = 0.0;
      while (distance < pathMetric.length) {
        dashPath.addPath(
          pathMetric.extractPath(distance, distance + dashWidth),
          Offset.zero,
        );
        distance += dashWidth + dashGap;
      }
    }

    canvas.drawPath(dashPath, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
