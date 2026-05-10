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

    _controller = VideoPlayerController.asset('assets/images/splash_video.mp4')
      ..initialize().then((_) {
        if (mounted) {
          setState(() {});
          _controller?.play();
        }
      }).catchError((e) {
        debugPrint('Splash video error: $e');
      });

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

    // 안전장치: 5초 후 강제 이동
    Future.delayed(const Duration(seconds: 5), () {
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
        transitionDuration: const Duration(milliseconds: 400),
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
                fit: BoxFit.contain,
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