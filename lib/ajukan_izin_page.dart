import 'dart:ui';
import 'package:flutter/material.dart';

class AjukanIzinPage extends StatefulWidget {
  const AjukanIzinPage({super.key});

  @override
  State<AjukanIzinPage> createState() => _AjukanIzinPageState();
}

class _AjukanIzinPageState extends State<AjukanIzinPage> {
  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();

  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        if (isStartDate) {
          _startDateController.text = "${picked.month}/${picked.day}/${picked.year}";
        } else {
          _endDateController.text = "${picked.month}/${picked.day}/${picked.year}";
        }
      });
    }
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
          'Ajukan Izin (Lainnya)',
          style: TextStyle(
            color: Color(0xFF0F172A),
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Buat Pengajuan Baru',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0F172A),
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Lengkapi detail izin Anda di bawah ini.',
              style: TextStyle(
                fontSize: 14,
                color: Color(0xFF64748B),
                fontWeight: FontWeight.w400,
              ),
            ),
            const SizedBox(height: 32),
            
            // Form Card
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.03),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Start Date
                  _buildLabel('Tanggal Mulai'),
                  const SizedBox(height: 8),
                  InkWell(
                    onTap: () => _selectDate(context, true),
                    child: IgnorePointer(
                      child: _buildField(
                        controller: _startDateController,
                        hint: 'mm/dd/yyyy',
                        icon: Icons.calendar_today_outlined,
                        suffixIcon: Icons.calendar_today,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // End Date
                  _buildLabel('Tanggal Selesai'),
                  const SizedBox(height: 8),
                  InkWell(
                    onTap: () => _selectDate(context, false),
                    child: IgnorePointer(
                      child: _buildField(
                        controller: _endDateController,
                        hint: 'mm/dd/yyyy',
                        icon: Icons.calendar_month_outlined,
                        suffixIcon: Icons.calendar_today,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Subject
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildLabel('Subjek'),
                      const Text(
                        'Maksimal 50 karakter',
                        style: TextStyle(
                          fontSize: 11,
                          color: Color(0xFF94A3B8),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  _buildField(
                    hint: 'Contoh: Izin Kedukaan',
                    icon: Icons.label_important_rounded,
                  ),
                  const SizedBox(height: 16),

                  // Info Banner
                  _buildInfoBanner(),
                  const SizedBox(height: 24),

                  // Description
                  _buildLabel('Keterangan'),
                  const SizedBox(height: 8),
                  _buildTextArea(
                    hint: 'Alasan pengajuan izin...',
                    icon: Icons.notes_rounded,
                  ),
                  const SizedBox(height: 24),

                  // Attachment
                  _buildDashedAttachment(),
                ],
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: _buildSubmitButton(),
      ),
    );
  }

  Widget _buildLabel(String label) {
    return Text(
      label,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.bold,
        color: Color(0xFF334155),
      ),
    );
  }

  Widget _buildField({TextEditingController? controller, required String hint, required IconData icon, IconData? suffixIcon}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF64748B), size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                hintText: hint,
                hintStyle: const TextStyle(
                  color: Color(0xFF94A3B8),
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(vertical: 14),
              ),
            ),
          ),
          if (suffixIcon != null)
            Icon(suffixIcon, color: Colors.black, size: 20),
        ],
      ),
    );
  }

  Widget _buildTextArea({required String hint, required IconData icon}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      height: 120,
      decoration: BoxDecoration(
        color: const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 2),
            child: Icon(icon, color: const Color(0xFF64748B), size: 20),
          ),
          const SizedBox(width: 12),
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
        ],
      ),
    );
  }

  Widget _buildInfoBanner() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFEFF6FF),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFDBEAFE)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.info_rounded, color: Color(0xFF2563EB), size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Untuk izin satu hari, isi tanggal yang sama pada kolom mulai dan selesai.',
              style: TextStyle(
                fontSize: 13,
                color: const Color(0xFF2563EB).withOpacity(0.8),
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDashedAttachment() {
    return CustomPaint(
      painter: DashRectPainter(color: const Color(0xFFCBD5E1)),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.attachment_rounded, color: Color(0xFF334155)),
            SizedBox(width: 12),
            Text(
              'Lampiran (Opsional)',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Color(0xFF334155),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSubmitButton() {
    return Container(
      width: double.infinity,
      height: 56,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
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
          borderRadius: BorderRadius.circular(12),
          child: const Center(
            child: Text(
              'Ajukan Izin',
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
