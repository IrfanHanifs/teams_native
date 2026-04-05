import 'package:flutter/material.dart';
import 'package:teams_native/detail_cuti_page.dart';
import 'package:teams_native/ajukan_cuti_page.dart';

class CutiPage extends StatelessWidget {
  const CutiPage({super.key});

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
          'Pengajuan Cuti',
          style: TextStyle(
            color: Color(0xFF2563EB),
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Cuti',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF0F172A),
                    letterSpacing: -1,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Riwayat pengajuan izin dan cuti Anda.',
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF64748B),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 32),
                
                // Leave History List
                _buildLeaveCard(
                  context,
                  dateRange: '20 JUN - 22 JUN 2024',
                  title: 'Cuti Tahunan',
                  duration: '3 Hari',
                  status: 'DISETUJUI',
                  statusColor: const Color(0xFF10B981),
                  icon: Icons.calendar_month_rounded,
                ),
                const SizedBox(height: 16),
                _buildLeaveCard(
                  context,
                  dateRange: '01 MEI - 02 MEI 2024',
                  title: 'Cuti Alasan Penting',
                  duration: '2 Hari',
                  status: 'DITOLAK',
                  statusColor: const Color(0xFFEF4444),
                  icon: Icons.home_rounded,
                ),
                const SizedBox(height: 16),
                _buildLeaveCard(
                  context,
                  dateRange: '15 JUL - 15 JUL 2024',
                  title: 'Keperluan Mendesak',
                  duration: '1 Hari',
                  status: 'PENDING',
                  statusColor: const Color(0xFFF59E0B),
                  icon: Icons.warning_amber_rounded,
                ),
                const SizedBox(height: 16),
                _buildLeaveCard(
                  context,
                  dateRange: '10 APR - 11 APR 2024',
                  title: 'Cuti Melahirkan',
                  duration: '2 Hari',
                  status: 'DISETUJUI',
                  statusColor: const Color(0xFF10B981),
                  icon: Icons.calendar_month_rounded,
                ),
                const SizedBox(height: 120), // Bottom space for action button
              ],
            ),
          ),
          
          // Action Button at the bottom
          Positioned(
            left: 24,
            right: 24,
            bottom: 32,
            child: Container(
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
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AjukanCutiPage(),
                      ),
                    );
                  },
                  borderRadius: BorderRadius.circular(16),
                  child: const Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.add, color: Colors.white, size: 24),
                        SizedBox(width: 8),
                        Text(
                          'Ajukan Cuti',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLeaveCard(
    BuildContext context, {
    required String dateRange,
    required String title,
    required String duration,
    required String status,
    required Color statusColor,
    required IconData icon,
  }) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        onTap: () {
          if (title == 'Cuti Tahunan') {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const DetailCutiPage(isApproved: true),
              ),
            );
          } else if (title == 'Cuti Alasan Penting') {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const DetailCutiPage(isApproved: false),
              ),
            );
          }
        },
        borderRadius: BorderRadius.circular(20),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Left color indicator
                Container(
                  width: 6,
                  color: statusColor,
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
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Icon(
                                icon,
                                color: const Color(0xFF2563EB),
                                size: 24,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    dateRange,
                                    style: const TextStyle(
                                      color: Color(0xFF94A3B8),
                                      fontSize: 10,
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    title,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF1E293B),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            _buildStatusBadge(status, statusColor),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                const Icon(
                                  Icons.access_time_rounded,
                                  size: 16,
                                  color: Color(0xFF64748B),
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  duration,
                                  style: const TextStyle(
                                    color: Color(0xFF64748B),
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                            const Row(
                              children: [
                                Text(
                                  'Detail',
                                  style: TextStyle(
                                    color: Color(0xFF2563EB),
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Icon(
                                  Icons.chevron_right_rounded,
                                  size: 18,
                                  color: Color(0xFF2563EB),
                                ),
                              ],
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

  Widget _buildStatusBadge(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: 9,
          fontWeight: FontWeight.w900,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}
