import 'package:flutter/material.dart';

class DetailPresensiPage extends StatelessWidget {
  final bool isSelesai;
  const DetailPresensiPage({super.key, this.isSelesai = true});

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
          'Detail Presensi',
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
            // Selected Date Card
            _buildDateHeaderCard(),
            const SizedBox(height: 32),
            
            // Detail Info Cards
            _buildDetailInfoCard(
              label: 'CLOCK IN',
              value: '08:24',
              suffix: 'AM',
              badgeText: 'ON TIME',
              badgeColor: const Color(0xFF10B981),
              icon: Icons.access_time_filled_rounded,
              iconBgColor: const Color(0xFFEFF6FF),
              iconColor: const Color(0xFF2563EB),
            ),
            const SizedBox(height: 16),
            _buildDetailInfoCard(
              label: 'CLOCK OUT',
              value: isSelesai ? '17:45' : '--:--',
              suffix: isSelesai ? 'PM' : '',
              badgeText: isSelesai ? 'COMPLETED' : 'IN PROGRESS',
              badgeColor: isSelesai ? const Color(0xFF94A3B8) : const Color(0xFF2563EB),
              icon: Icons.logout_rounded,
              iconBgColor: const Color(0xFFFFF7ED),
              iconColor: const Color(0xFFF97316),
            ),
            const SizedBox(height: 16),
            _buildDetailInfoCard(
              label: 'WORK LOCATION',
              value: 'Office Jakarta Selatan',
              icon: Icons.location_on_rounded,
              iconBgColor: const Color(0xFFE0F7FA),
              iconColor: const Color(0xFF00ACC1),
            ),
            const SizedBox(height: 16),
            _buildDetailInfoCard(
              label: 'ATTENDANCE STATUS',
              value: isSelesai ? 'Tepat Waktu' : 'Belum Keluar',
              icon: Icons.check_circle_rounded,
              iconBgColor: const Color(0xFFDCFCE7),
              iconColor: const Color(0xFF10B981),
              hasDot: true,
            ),
            
            const SizedBox(height: 48),
            
            // Duration Section
            const Text(
              'DURATION',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w800,
                color: Color(0xFF94A3B8),
                letterSpacing: 1.0,
              ),
            ),
            const SizedBox(height: 16),
            const Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Text(
                  '9',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF1E293B),
                  ),
                ),
                SizedBox(width: 8),
                Text(
                  'Hours',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF64748B),
                  ),
                ),
                SizedBox(width: 16),
                Text(
                  '21',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF1E293B),
                  ),
                ),
                SizedBox(width: 8),
                Text(
                  'Mins',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF64748B),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildDateHeaderCard() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFF2563EB),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF2563EB).withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
      child: const Column(
        children: [
          Text(
            'SELECTED DATE',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 11,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.0,
            ),
          ),
          SizedBox(height: 12),
          Text(
            'Rabu',
            style: TextStyle(
              color: Colors.white,
              fontSize: 36,
              fontWeight: FontWeight.w900,
            ),
          ),
          SizedBox(height: 2),
          Text(
            '1 April 2026',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailInfoCard({
    required String label,
    required String value,
    String? suffix,
    String? badgeText,
    Color? badgeColor,
    required IconData icon,
    required Color iconBgColor,
    required Color iconColor,
    bool hasDot = false,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: iconBgColor,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: iconColor, size: 24),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF94A3B8),
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      value,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF1E293B),
                      ),
                    ),
                    if (suffix != null) ...[
                      const SizedBox(width: 4),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 2.0),
                        child: Text(
                          suffix,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF64748B),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
          if (badgeText != null)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: badgeColor!.withOpacity(0.12),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                badgeText,
                style: TextStyle(
                  color: badgeColor,
                  fontSize: 9,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          if (hasDot)
            Container(
              width: 8,
              height: 8,
              decoration: const BoxDecoration(
                color: Color(0xFF10B981),
                shape: BoxShape.circle,
              ),
            ),
        ],
      ),
    );
  }
}
