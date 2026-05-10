import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  VideoPlayerController? _controller;
  bool _navigated = false;

  @override
  void initState() {
    super.initState();

    // 영상 로드 시도
    _controller = VideoPlayerController.asset('assets/images/splash_video.mp4')
      ..initialize().then((_) {
        if (mounted) {
          setState(() {});
          _controller?.play();
        }
      }).catchError((e) {
        // 영상 없으면 무시
        debugPrint('Splash video not found: $e');
      });

    // 영상 끝 감지
    _controller?.addListener(() {
      final c = _controller;
      if (c != null &&
          c.value.isInitialized &&
          c.value.position >= c.value.duration &&
          c.value.duration > Duration.zero &&
          !_navigated) {
        _navigated = true;
        _goHome();
      }
    });

    // 안전장치: 4초 후 강제 이동 (크롬에서 영상 끝 감지 안 될 때)
    Future.delayed(const Duration(seconds: 4), () {
      if (!_navigated && mounted) {
        _navigated = true;
        _goHome();
      }
    });
  }

  void _goHome() {
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => const HomeScreen(),
        transitionsBuilder: (_, animation, __, child) {
          return FadeTransition(opacity: animation, child: child);
        },
        transitionDuration: const Duration(milliseconds: 1000),
      ),
    );
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = _controller;
    final isReady = c != null && c.value.isInitialized;

    return Scaffold(
      backgroundColor: const Color(0xFFFFCC00),
      body: isReady
          ? SizedBox.expand(
              child: FittedBox(
                fit: BoxFit.cover,
                child: SizedBox(
                  width: c.value.size.width,
                  height: c.value.size.height,
                  child: VideoPlayer(c),
                ),
              ),
            )
          : Image.asset(
              'assets/images/intro1.png',
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            ),
    );
  }
}
