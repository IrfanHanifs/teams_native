import 'package:flutter/material.dart';
import 'package:teams_native/detail_perjalanan_page.dart';

class PerjalananDinasPage extends StatelessWidget {
  const PerjalananDinasPage({super.key});

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
          'Perjalanan Dinas',
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
              'Riwayat Perjalanan',
              style: TextStyle(
                color: Color(0xFF64748B),
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'Daftar Aktif',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w900,
                color: Color(0xFF0F172A),
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 32),
            
            // Travel Cards List
            _buildTravelCard(
              context,
              destination: 'Singapore',
              dates: '12 Jul - 15 Jul 2024',
              status: 'BELUM SELESAI',
              isCompleted: false,
              accentColor: const Color(0xFF10B981),
              icon: Icons.flight_rounded,
            ),
            const SizedBox(height: 20),
            _buildTravelCard(
              context,
              destination: 'Jakarta, Indonesia',
              dates: '22 Aug - 25 Aug 2024',
              status: 'BELUM SELESAI',
              isCompleted: false,
              accentColor: const Color(0xFFF59E0B),
              icon: Icons.location_on_rounded,
            ),
            const SizedBox(height: 20),
            _buildTravelCard(
              context,
              destination: 'Surabaya',
              dates: '05 Jun - 07 Jun 2024',
              status: 'BELUM SELESAI',
              isCompleted: false,
              accentColor: const Color(0xFFEF4444),
              icon: Icons.business_center_rounded,
            ),
            const SizedBox(height: 20),
            _buildTravelCard(
              context,
              destination: 'Bandung',
              dates: '01 May - 02 May 2024',
              status: 'SUDAH SELESAI',
              isCompleted: true,
              accentColor: const Color(0xFF94A3B8),
              icon: Icons.train_rounded,
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildTravelCard(
    BuildContext context, {
    required String destination,
    required String dates,
    required String status,
    required bool isCompleted,
    required Color accentColor,
    required IconData icon,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const DetailPerjalananPage(),
              ),
            );
          },
          borderRadius: BorderRadius.circular(20),
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Left color indicator
                Container(
                  width: 5,
                  decoration: BoxDecoration(
                    color: accentColor,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      bottomLeft: Radius.circular(20),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF1F5F9),
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: Icon(
                                icon,
                                color: isCompleted ? const Color(0xFF94A3B8) : const Color(0xFF2563EB),
                                size: 24,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    destination,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: isCompleted ? const Color(0xFF94A3B8) : const Color(0xFF1E293B),
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Row(
                                    children: [
                                      Icon(Icons.calendar_today_rounded, 
                                        size: 14, 
                                        color: isCompleted ? const Color(0xFFCBD5E1) : const Color(0xFF64748B)
                                      ),
                                      const SizedBox(width: 6),
                                      Text(
                                        dates,
                                        style: TextStyle(
                                          color: isCompleted ? const Color(0xFFCBD5E1) : const Color(0xFF64748B),
                                          fontSize: 13,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        // Bottom Section
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                              decoration: BoxDecoration(
                                color: isCompleted 
                                  ? const Color(0xFFDCFCE7) 
                                  : const Color(0xFFFFE4E6),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                status,
                                style: TextStyle(
                                    color: isCompleted 
                                    ? const Color(0xFF10B981) 
                                    : const Color(0xFFEF4444),
                                  fontSize: 10,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ),
                            const Text(
                              'Lihat Detail',
                              style: TextStyle(
                                color: Color(0xFF2563EB),
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
