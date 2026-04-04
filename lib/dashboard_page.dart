import 'package:flutter/material.dart';
import 'package:teams_native/lembur_page.dart';
import 'package:teams_native/cuti_page.dart';
import 'package:teams_native/perjalanan_dinas_page.dart';
import 'package:teams_native/izin_page.dart';
import 'package:teams_native/sakit_tanpa_page.dart';
import 'package:teams_native/sakit_surat_page.dart';
import 'package:teams_native/riwayat_presensi_page.dart';
import 'package:teams_native/profil_page.dart';
import 'package:teams_native/presensi_camera_page.dart';
import 'package:teams_native/detail_perjalanan_page.dart';
import 'package:teams_native/detail_presensi_page.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int _currentIndex = 0;
  int _attendanceState = 0; // 0: Initial, 1: On Time, 2: Late, 3: Late (Var), 4: Finished, 5: Missed Checkout

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: _buildBody(),
      bottomNavigationBar: _buildBottomNavBar(),
    );
  }

  Widget _buildBody() {
    switch (_currentIndex) {
      case 0:
        return _buildDashboardView();
      case 1:
        return const RiwayatPresensiPage();
      case 2:
        return const ProfilPage();
      default:
        return _buildDashboardView();
    }
  }

  Widget _buildDashboardView() {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            const SizedBox(height: 32),
            _buildStatusCard(),
            const SizedBox(height: 24),
            _buildTravelAssignmentCard(),
            const SizedBox(height: 32),
            _buildSectionTitle('Menu Layanan'),
            const SizedBox(height: 16),
            _buildMenuGrid(),
            const SizedBox(height: 32),
            _buildSectionTitle('Riwayat Presensi Hari Ini'),
            const SizedBox(height: 16),
            _buildAttendanceHistory(),
            const SizedBox(height: 24),
            _buildWorkingHoursInfo(),
            const SizedBox(height: 48), // Space for bottom nav reduced
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        const CircleAvatar(
          radius: 28,
          backgroundImage: NetworkImage(
              'https://randomuser.me/api/portraits/men/32.jpg'), // Placeholder image
        ),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Selamat Datang, Andika',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0F172A),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              "Jum'at, 10 April 2026 • 08:15 WIB",
              style: TextStyle(
                fontSize: 13,
                color: const Color(0xFF64748B),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatusCard() {
    List<Color> colors;
    String status;
    String linkText;
    String pillText;
    IconData icon;
    bool showLink = true;
    Color glowColor;

    switch (_attendanceState) {
      case 0: // a. N/A (Abu-abu)
        colors = [const Color(0xFF94A3B8), const Color(0xFF64748B)];
        status = 'N/A';
        linkText = 'Klik disini untuk melakukan presensi';
        pillText = 'Anda belum melakukan presensi masuk.';
        icon = Icons.hourglass_empty_rounded;
        glowColor = const Color(0xFF94A3B8);
        break;
      case 1: // b. Tepat Waktu (Biru)
        colors = [const Color(0xFF007AFF), const Color(0xFF01BEFD)];
        status = 'Tepat Waktu';
        linkText = 'Klik disini untuk melakukan presensi kepulangan';
        pillText = 'Anda sudah melakukan presensi masuk.';
        icon = Icons.verified_user_rounded;
        glowColor = const Color(0xFF007AFF);
        break;
      case 2: // c. Terlambat (Orange)
      case 3: // d. Terlambat (Orange)
        colors = [const Color(0xFFF59E0B), const Color(0xFFD97706)];
        status = 'Terlambat';
        linkText = 'Klik disini untuk melakukan presensi kepulangan';
        pillText = 'Anda sudah melakukan presensi masuk.';
        icon = Icons.warning_amber_rounded;
        glowColor = const Color(0xFFF59E0B);
        break;
      case 4: // e. Selesai (Hijau)
        colors = [const Color(0xFF10B981), const Color(0xFF059669)];
        status = 'Selesai';
        linkText = '';
        pillText = 'Terima kasih telah melakukan presensi.';
        icon = Icons.check_circle_rounded;
        showLink = false;
        glowColor = const Color(0xFF10B981);
        break;
      case 5: // f. Belum Presensi (Merah)
        colors = [const Color(0xFFEF4444), const Color(0xFFDC2626)];
        status = 'Belum Presensi';
        linkText = 'Klik disini untuk melakukan presensi kepulangan';
        pillText = 'Anda belum melakukan presensi kepulangan.';
        icon = Icons.error_outline_rounded;
        glowColor = const Color(0xFFEF4444);
        break;
      default:
        colors = [const Color(0xFF007AFF), const Color(0xFF01BEFD)];
        status = 'Tepat Waktu';
        linkText = 'Klik di sini untuk melakukan presensi';
        pillText = 'Anda belum melakukan presensi masuk.';
        icon = Icons.verified_user_rounded;
        glowColor = const Color(0xFF007AFF);
    }

    return GestureDetector(
      onTap: () {
        setState(() {
          _attendanceState = (_attendanceState + 1) % 6;
        });
      },
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          gradient: LinearGradient(
            colors: colors,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: glowColor.withOpacity(0.3),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        padding: const EdgeInsets.all(24),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'STATUS KEHADIRAN',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  status,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 36,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 8),
                if (showLink)
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const PresensiCameraPage(),
                        ),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Row(
                        children: [
                          Text(
                            linkText,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              decoration: TextDecoration.underline,
                              decorationColor: Colors.white54,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Icon(
                            Icons.arrow_forward_ios_rounded,
                            size: 11,
                            color: Colors.white.withOpacity(0.8),
                          ),
                        ],
                      ),
                    ),
                  ),
                if (showLink) const SizedBox(height: 16),
                if (!showLink) const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    pillText,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ],
            ),
            Positioned(
              right: 0,
              bottom: 0,
              child: Icon(
                icon,
                size: 56,
                color: Colors.white.withOpacity(0.2),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTravelAssignmentCard() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: const Border(
          left: BorderSide(color: Color(0xFF2563EB), width: 6),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFFEFF6FF),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.flight_takeoff_rounded,
              color: Color(0xFF2563EB),
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Penugasan Perjalanan Dinas',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: Color(0xFF1E293B),
                  ),
                ),
                const SizedBox(height: 2),
                const Text(
                  'Singapore (12 Jul - 15 Jul 2024)',
                  style: TextStyle(
                    fontSize: 12,
                    color: Color(0xFF64748B),
                  ),
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const DetailPerjalananPage()),
              );
            },
            child: const Text(
              'Lihat Detail',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2563EB),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Color(0xFF0F172A),
      ),
    );
  }

  Widget _buildMenuGrid() {
    final List<Map<String, dynamic>> menuItems = [
      {'title': 'Lembur', 'icon': Icons.access_time_rounded, 'color': Colors.orange},
      {'title': 'Cuti', 'icon': Icons.calendar_today_rounded, 'color': Colors.blue},
      {'title': 'Perjalanan Dinas', 'icon': Icons.flight_rounded, 'color': Colors.teal},
      {'title': 'Izin', 'icon': Icons.assignment_turned_in_rounded, 'color': Colors.purple},
      {'title': 'Sakit (Surat)', 'icon': Icons.medical_services_rounded, 'color': Colors.red},
      {'title': 'Sakit (Tanpa)', 'icon': Icons.sick_rounded, 'color': Colors.orangeAccent},
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: menuItems.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.9,
      ),
      itemBuilder: (context, index) {
        final item = menuItems[index];
        return Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              if (item['title'] == 'Lembur') {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const LemburPage()),
                );
              } else if (item['title'] == 'Cuti') {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const CutiPage()),
                );
              } else if (item['title'] == 'Perjalanan Dinas') {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const PerjalananDinasPage()),
                );
              } else if (item['title'] == 'Izin') {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const IzinPage()),
                );
              } else if (item['title'] == 'Sakit (Tanpa)') {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SakitTanpaPage()),
                );
              } else if (item['title'] == 'Sakit (Surat)') {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SakitSuratPage()),
                );
              }
            },
            borderRadius: BorderRadius.circular(16),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.black.withOpacity(0.05)),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: (item['color'] as Color).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      item['icon'],
                      color: item['color'],
                      size: 24,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    item['title'],
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF334155),
                      height: 1.2,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildAttendanceHistory() {
    String checkInTime = '-- : --';
    String checkInDate = 'Belum Waktunya';
    String checkInStatus = 'N/A';
    Color checkInColor = const Color(0xFF94A3B8);
    bool checkInActive = false;

    String checkOutTime = '-- : --';
    String checkOutDate = 'Belum Waktunya';
    String checkOutStatus = 'N/A';
    Color checkOutColor = const Color(0xFF94A3B8);
    bool checkOutActive = false;

    switch (_attendanceState) {
      case 0: // a. N/A (Default abu-abu)
        break;
      case 1: // b. Tepat Waktu (Hijau)
        checkInTime = '08:02';
        checkInDate = '10 April 2026';
        checkInStatus = 'Tepat Waktu';
        checkInColor = const Color(0xFF10B981);
        checkInActive = true;
        break;
      case 2: // c. Terlambat (Orange)
      case 3: // d. Terlambat (Orange)
        checkInTime = '08:45';
        checkInDate = '10 April 2026';
        checkInStatus = 'Terlambat';
        checkInColor = const Color(0xFFF59E0B);
        checkInActive = true;
        break;
      case 4: // e. Selesai (Merah)
        checkInTime = '08:02';
        checkInDate = '10 April 2026';
        checkInStatus = 'Tepat Waktu';
        checkInColor = const Color(0xFF10B981);
        checkInActive = true;

        checkOutTime = '17:05';
        checkOutDate = '10 April 2026';
        checkOutStatus = 'Selesai';
        checkOutColor = const Color(0xFFEF4444);
        checkOutActive = true;
        break;
      case 5: // f. Belum Presensi (Merah-ish Variant)
        checkInTime = '08:02';
        checkInDate = '10 April 2026';
        checkInStatus = 'Tepat Waktu';
        checkInColor = const Color(0xFF10B981);
        checkInActive = true;

        checkOutStatus = 'Belum Keluar';
        break;
    }

    return GestureDetector(
      onTap: () {
        setState(() {
          _attendanceState = (_attendanceState + 1) % 6;
        });
      },
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () {
                if (checkInActive) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DetailPresensiPage(
                        isSelesai: _attendanceState == 4,
                        isTerlambat: _attendanceState == 2 || _attendanceState == 3,
                      ),
                    ),
                  );
                }
              },
              child: _buildAttendanceCard(
                'MASUK',
                checkInTime,
                checkInDate,
                checkInStatus,
                checkInColor,
                isActive: checkInActive,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: GestureDetector(
              onTap: () {
                if (checkOutActive || _attendanceState == 5) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DetailPresensiPage(
                        isSelesai: _attendanceState == 4,
                        isTerlambat: false, // Pulang normally doesn't use this flag here
                      ),
                    ),
                  );
                }
              },
              child: _buildAttendanceCard(
                'PULANG',
                checkOutTime,
                checkOutDate,
                checkOutStatus,
                checkOutColor,
                isActive: checkOutActive,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAttendanceCard(String label, String time, String date, String location, Color color,
      {bool isActive = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
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
      child: Column(
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w800,
              color: Color(0xFF64748B),
              letterSpacing: 1.0,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            time,
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w900,
              color: isActive ? color : const Color(0xFFCBD5E1),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            date,
            style: const TextStyle(
              fontSize: 11,
              color: Color(0xFF64748B),
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  isActive ? Icons.access_time_filled_rounded : Icons.access_time_filled_rounded,
                  size: 14,
                  color: color,
                ),
                const SizedBox(width: 4),
                Flexible(
                  child: Text(
                    location,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWorkingHoursInfo() {
    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: const BoxDecoration(
                color: Color(0xFF10B981),
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 8),
            const Text(
              'Jam Kerja: 08:00 - 17:00',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: Color(0xFF334155),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNavBar() {
    return Container(
      height: 80,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(0, Icons.home_rounded, 'BERANDA'),
          _buildNavItem(1, Icons.history_rounded, 'RIWAYAT'),
          _buildNavItem(2, Icons.person_rounded, 'PROFIL'),
        ],
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label) {
    bool isSelected = _currentIndex == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          _currentIndex = index;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFEFF6FF) : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected ? const Color(0xFF2563EB) : const Color(0xFF94A3B8),
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: isSelected ? const Color(0xFF2563EB) : const Color(0xFF94A3B8),
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
