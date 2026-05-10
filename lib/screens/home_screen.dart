import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/app_state.dart';
import '../widgets/editable_overlay.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Timer? _bannerTimer;
  int _currentBanner = 0;

  // 이미지 원본 크기
  static const double imgWidth = 1730;

  // Banner (전체 997, 이미지 744, 점 297, 겹침 44)
  static const double bannerTop3x = 60;
  static const double bannerImgHeight = 217;
  static const double bannerDotsOffset = 217;
  static const double bannerDotsHeight = 83;

  // Balance
  static const double balanceTop3x = 880;
  static const double balanceLeft3x = 263;
  static const double balanceCoverWidth3x = 800;
  static const double balanceCoverHeight3x = 100;

  @override
  void initState() {
    super.initState();
    _startBannerAutoScroll();
  }

  @override
  void dispose() {
    _bannerTimer?.cancel();
    super.dispose();
  }

  void _startBannerAutoScroll() {
    _bannerTimer = Timer.periodic(const Duration(seconds: 4), (timer) {
      setState(() {
        _currentBanner = (_currentBanner + 1) % 4;
      });
    });
  }

  double _toScreenX(double px3x, double screenWidth) {
    return px3x * screenWidth / imgWidth;
  }

  double _toScreenY(double py3x, double screenWidth) {
    return py3x * screenWidth / imgWidth;
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final screenWidth = MediaQuery.of(context).size.width;
    final scale = screenWidth / imgWidth;

    return Scaffold(
      backgroundColor: const Color(0xFFF4F4F4),
      body: GestureDetector(
        onTap: () => state.registerTap(),
        child: Stack(
          children: [
            Column(
              children: [
                Container(
                  height: MediaQuery.of(context).padding.top,
                  color: Colors.white,
                ),
                Image.asset(
                  'assets/images/gnb.png',
                  width: screenWidth,
                  fit: BoxFit.fitWidth,
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: SizedBox(
                      width: screenWidth,
                      child: Stack(
                        children: [
                          Image.asset(
                            'assets/images/home_content.png',
                            width: screenWidth,
                            fit: BoxFit.fitWidth,
                          ),

                          // ===== 배너 이미지 =====
                          Positioned(
                            top: _toScreenY(bannerTop3x, screenWidth),
                            left: _toScreenX(0, screenWidth),
                            right: _toScreenX(0, screenWidth),
                            height: _toScreenY(bannerImgHeight, screenWidth),
                            child: AnimatedSwitcher(
                              duration: const Duration(milliseconds: 500),
                              child: Image.asset(
                                'assets/images/banner${_currentBanner + 1}.jpg',
                                key: ValueKey(_currentBanner),
                                fit: BoxFit.cover,
                                width: double.infinity,
                                height: double.infinity,
                              ),
                            ),
                          ),

                          // ===== 점 이미지 =====
                          Positioned(
                            top: _toScreenY(
                                bannerTop3x + bannerDotsOffset, screenWidth),
                            left: _toScreenX(0, screenWidth),
                            right: _toScreenX(0, screenWidth),
                            height: _toScreenY(bannerDotsHeight, screenWidth),
                            child: Image.asset(
                              'assets/images/dots_${_currentBanner + 1}.png',
                              fit: BoxFit.cover,
                            ),
                          ),

                          // ===== 잔액 가림막 =====
                          Positioned(
                            top: _toScreenY(balanceTop3x - 2, screenWidth),
                            left: _toScreenX(balanceLeft3x, screenWidth),
                            width: _toScreenX(balanceCoverWidth3x, screenWidth),
                            height:
                                _toScreenY(balanceCoverHeight3x, screenWidth),
                            child: Container(color: const Color(0xFFFEFFFF)),
                          ),

                          // ===== 잔액 오버레이 =====
                          Positioned(
                            top: _toScreenY(balanceTop3x, screenWidth),
                            left: _toScreenX(balanceLeft3x, screenWidth),
                            child: GestureDetector(
                              onTap: state.editMode
                                  ? () async {
                                      final result = await showEditDialog(
                                        context,
                                        title: '잔액 수정 (숫자만)',
                                        currentValue: state.balance.toString(),
                                        keyboardType: TextInputType.number,
                                      );
                                      if (result != null) {
                                        final parsed = int.tryParse(result
                                            .replaceAll(',', '')
                                            .replaceAll('원', ''));
                                        if (parsed != null)
                                          state.updateBalance(parsed);
                                      }
                                    }
                                  : null,
                              child: Container(
                                padding: state.editMode
                                    ? const EdgeInsets.symmetric(
                                        horizontal: 4, vertical: 2)
                                    : EdgeInsets.zero,
                                decoration: state.editMode
                                    ? BoxDecoration(
                                        border: Border.all(
                                            color: const Color(0xFF2D55B0),
                                            width: 1.5),
                                        borderRadius: BorderRadius.circular(4),
                                      )
                                    : null,
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    RichText(
                                      text: TextSpan(
                                        children: [
                                          TextSpan(
                                            text: state.formattedBalance,
                                            style: TextStyle(
                                              fontFamily: 'Pretendard',
                                              fontSize: 19 * scale * 4,
                                              fontWeight: FontWeight.w600,
                                              color: const Color(0xFF252525),
                                              height: 1.2,
                                              letterSpacing: -0.5,
                                            ),
                                          ),
                                          TextSpan(
                                            text: ' 원',
                                            style: TextStyle(
                                              fontFamily: 'KBFGText',
                                              fontSize: 19 * scale * 4,
                                              fontWeight: FontWeight.w300,
                                              color: const Color(0xFF252525),
                                              height: 1.2,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(width: 8 * scale * 4),
                                    Image.asset(
                                      'assets/images/badge_hidden.png',
                                      height: _toScreenY(89, screenWidth),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Image.asset(
                'assets/images/tabbar.png',
                width: screenWidth,
                fit: BoxFit.fitWidth,
              ),
            ),
            if (state.editMode)
              Positioned(
                top: MediaQuery.of(context).padding.top + 10,
                right: 16,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2D55B0),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.2),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.edit, color: Colors.white, size: 14),
                      SizedBox(width: 4),
                      Text(
                        '편집 모드',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
