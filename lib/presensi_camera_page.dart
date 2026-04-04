import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'dart:io';
import 'hasil_presensi_page.dart';

class PresensiCameraPage extends StatefulWidget {
  const PresensiCameraPage({super.key});

  @override
  State<PresensiCameraPage> createState() => _PresensiCameraPageState();
}

class _PresensiCameraPageState extends State<PresensiCameraPage>
    with TickerProviderStateMixin {
  CameraController? _cameraController;
  List<CameraDescription>? _cameras;
  bool _isInitialized = false;
  bool _isCapturing = false;
  String? _errorMessage;

  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _initAnimations();
    _initCamera();
  }

  void _initAnimations() {
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 0.9, end: 1.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  Future<void> _initCamera() async {
    try {
      final cameras = await availableCameras();
      if (cameras.isEmpty) {
        setState(() => _errorMessage = 'Tidak ada kamera yang tersedia.');
        return;
      }

      _cameras = cameras;

      // Prefer front camera for selfie/presensi
      CameraDescription selectedCamera = cameras.first;
      for (final cam in cameras) {
        if (cam.lensDirection == CameraLensDirection.front) {
          selectedCamera = cam;
          break;
        }
      }

      _cameraController = CameraController(
        selectedCamera,
        ResolutionPreset.high,
        enableAudio: false,
        imageFormatGroup: ImageFormatGroup.jpeg,
      );

      await _cameraController!.initialize();

      if (!mounted) return;
      setState(() => _isInitialized = true);
    } catch (e) {
      if (!mounted) return;
      setState(() => _errorMessage = 'Gagal mengakses kamera: ${e.toString()}');
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _cameraController?.dispose();
    super.dispose();
  }

  Future<void> _onCapture() async {
    if (_isCapturing || _cameraController == null || !_isInitialized) return;

    setState(() => _isCapturing = true);

    try {
      final XFile photo = await _cameraController!.takePicture();

      // Save to temp directory
      final dir = await getTemporaryDirectory();
      final fileName = 'presensi_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final savedPath = p.join(dir.path, fileName);
      await File(photo.path).copy(savedPath);

      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HasilPresensiPage(imagePath: savedPath),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      setState(() => _isCapturing = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal mengambil foto: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _switchCamera() async {
    if (_cameras == null || _cameras!.length < 2) return;
    final currentDir = _cameraController?.description.lensDirection;
    CameraDescription next = _cameras!.firstWhere(
      (c) => c.lensDirection != currentDir,
      orElse: () => _cameras!.first,
    );
    await _cameraController?.dispose();
    _cameraController = CameraController(
      next,
      ResolutionPreset.high,
      enableAudio: false,
    );
    await _cameraController!.initialize();
    if (!mounted) return;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Camera preview or loading/error state
          _buildCameraLayer(),

          // Dark overlay with transparent hole
          if (_isInitialized) _buildDarkOverlay(),

          // Scanning frame corners
          if (_isInitialized) _buildScanningFrame(),

          // Top bar with close button
          _buildTopBar(context),

          // Bottom controls
          _buildBottomControls(),

          // Flash on capture
          if (_isCapturing)
            AnimatedOpacity(
              opacity: _isCapturing ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 100),
              child: Container(color: Colors.white.withOpacity(0.7)),
            ),
        ],
      ),
    );
  }

  Widget _buildCameraLayer() {
    if (_errorMessage != null) {
      return Container(
        color: Colors.black,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.videocam_off_rounded, color: Colors.white38, size: 64),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Text(
                  _errorMessage!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white60, fontSize: 14),
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: () {
                  setState(() => _errorMessage = null);
                  _initCamera();
                },
                icon: const Icon(Icons.refresh_rounded),
                label: const Text('Coba Lagi'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF007AFF),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (!_isInitialized || _cameraController == null) {
      return Container(
        color: Colors.black,
        child: const Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(color: Color(0xFF007AFF)),
              SizedBox(height: 16),
              Text(
                'Mempersiapkan kamera...',
                style: TextStyle(color: Colors.white60, fontSize: 14),
              ),
            ],
          ),
        ),
      );
    }

    return SizedBox.expand(
      child: FittedBox(
        fit: BoxFit.cover,
        child: SizedBox(
          width: _cameraController!.value.previewSize?.height ?? 100,
          height: _cameraController!.value.previewSize?.width ?? 100,
          child: CameraPreview(_cameraController!),
        ),
      ),
    );
  }

  Widget _buildDarkOverlay() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final w = constraints.maxWidth;
        final h = constraints.maxHeight;
        final frameW = w * 0.72;
        final frameH = frameW * 1.25;
        final frameL = (w - frameW) / 2;
        final frameT = h * 0.22;

        return CustomPaint(
          painter: _DarkOverlayPainter(
            frameRect: Rect.fromLTWH(frameL, frameT, frameW, frameH),
          ),
          size: Size(w, h),
        );
      },
    );
  }

  Widget _buildScanningFrame() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final w = constraints.maxWidth;
        final h = constraints.maxHeight;
        final frameW = w * 0.72;
        final frameH = frameW * 1.25;
        final frameL = (w - frameW) / 2;
        final frameT = h * 0.22;

        return Stack(
          children: [
            Positioned(left: frameL, top: frameT, child: _buildCorner(isTopLeft: true)),
            Positioned(right: frameL, top: frameT, child: _buildCorner(isTopRight: true)),
            Positioned(left: frameL, top: frameT + frameH - 36, child: _buildCorner(isBottomLeft: true)),
            Positioned(right: frameL, top: frameT + frameH - 36, child: _buildCorner(isBottomRight: true)),
          ],
        );
      },
    );
  }

  Widget _buildCorner({
    bool isTopLeft = false,
    bool isTopRight = false,
    bool isBottomLeft = false,
    bool isBottomRight = false,
  }) {
    return CustomPaint(
      size: const Size(36, 36),
      painter: _CornerPainter(
        color: Colors.white.withOpacity(0.8),
        strokeWidth: 3.5,
        isTopLeft: isTopLeft,
        isTopRight: isTopRight,
        isBottomLeft: isBottomLeft,
        isBottomRight: isBottomRight,
      ),
    );
  }



  Widget _buildTopBar(BuildContext context) {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.white.withOpacity(0.2)),
                  ),
                  child: const Icon(Icons.close, color: Colors.white, size: 24),
                ),
              ),
              const Text(
                'Presensi',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5,
                  shadows: [Shadow(color: Colors.black45, blurRadius: 4)],
                ),
              ),
              const SizedBox(width: 40), // Balanced spacing
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBottomControls() {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 36.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Switch camera & capture button row
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Switch camera button
                  if (_cameras != null && _cameras!.length > 1)
                    GestureDetector(
                      onTap: _switchCamera,
                      child: Container(
                        width: 46,
                        height: 46,
                        margin: const EdgeInsets.only(right: 32),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white.withOpacity(0.3)),
                        ),
                        child: const Icon(
                          Icons.flip_camera_ios_rounded,
                          color: Colors.white,
                          size: 22,
                        ),
                      ),
                    )
                  else
                    const SizedBox(width: 78),

                  // Main capture button
                  GestureDetector(
                    onTap: (_isInitialized && !_isCapturing) ? _onCapture : null,
                    child: AnimatedBuilder(
                      animation: _pulseAnimation,
                      builder: (context, child) {
                        return Transform.scale(
                          scale: _isCapturing ? 0.88 : _pulseAnimation.value,
                          child: Container(
                            width: 72,
                            height: 72,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: _isInitialized
                                  ? const Color(0xFF007AFF)
                                  : Colors.grey,
                              boxShadow: _isInitialized
                                  ? [
                                      BoxShadow(
                                        color: const Color(0xFF007AFF).withOpacity(0.5),
                                        blurRadius: 20,
                                        spreadRadius: 4,
                                      ),
                                    ]
                                  : null,
                            ),
                            child: _isCapturing
                                ? const Padding(
                                    padding: EdgeInsets.all(20),
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2.5,
                                    ),
                                  )
                                : const Icon(
                                    Icons.camera_alt_rounded,
                                    color: Colors.white,
                                    size: 32,
                                  ),
                          ),
                        );
                      },
                    ),
                  ),

                  const SizedBox(width: 78),
                ],
              ),
              const SizedBox(height: 20),

              // Location pill
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: Colors.white.withOpacity(0.25)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.location_on_rounded,
                      size: 16,
                      color: Colors.white.withOpacity(0.9),
                    ),
                    const SizedBox(width: 6),
                    const Text(
                      'Jakarta Selatan, Indonesia',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Painters ────────────────────────────────────────────────────────────────

class _DarkOverlayPainter extends CustomPainter {
  final Rect frameRect;
  _DarkOverlayPainter({required this.frameRect});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.black.withOpacity(0.55);
    final path = Path()
      ..addRect(Rect.fromLTWH(0, 0, size.width, size.height))
      ..addRRect(RRect.fromRectAndRadius(frameRect, const Radius.circular(12)))
      ..fillType = PathFillType.evenOdd;
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_DarkOverlayPainter old) => old.frameRect != frameRect;
}

class _CornerPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final bool isTopLeft, isTopRight, isBottomLeft, isBottomRight;

  _CornerPainter({
    required this.color,
    required this.strokeWidth,
    this.isTopLeft = false,
    this.isTopRight = false,
    this.isBottomLeft = false,
    this.isBottomRight = false,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    const len = 28.0;
    const r = 8.0;
    final w = size.width;
    final h = size.height;

    if (isTopLeft) {
      canvas.drawLine(const Offset(r, 0), const Offset(len, 0), paint);
      canvas.drawLine(const Offset(0, r), const Offset(0, len), paint);
      canvas.drawArc(const Rect.fromLTWH(0, 0, r * 2, r * 2), -3.14159, 3.14159 / 2, false, paint);
    }
    if (isTopRight) {
      canvas.drawLine(Offset(w - len, 0), Offset(w - r, 0), paint);
      canvas.drawLine(Offset(w, r), Offset(w, len), paint);
      canvas.drawArc(Rect.fromLTWH(w - r * 2, 0, r * 2, r * 2), -3.14159 / 2, 3.14159 / 2, false, paint);
    }
    if (isBottomLeft) {
      canvas.drawLine(Offset(r, h), Offset(len, h), paint);
      canvas.drawLine(Offset(0, h - len), Offset(0, h - r), paint);
      canvas.drawArc(Rect.fromLTWH(0, h - r * 2, r * 2, r * 2), 3.14159 / 2, 3.14159 / 2, false, paint);
    }
    if (isBottomRight) {
      canvas.drawLine(Offset(w - len, h), Offset(w - r, h), paint);
      canvas.drawLine(Offset(w, h - len), Offset(w, h - r), paint);
      canvas.drawArc(Rect.fromLTWH(w - r * 2, h - r * 2, r * 2, r * 2), 0, 3.14159 / 2, false, paint);
    }
  }

  @override
  bool shouldRepaint(_CornerPainter old) => false;
}
