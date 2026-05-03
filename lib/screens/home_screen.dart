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
  final PageController _bannerController = PageController();
  Timer? _bannerTimer;
  int _currentBanner = 0;

  // 이미지 원본 크기
  static const double imgWidth = 1730;

  // 주요 요소 위치 (content 이미지 픽셀 기준)
  // Banner
  static const double bannerTop3x = 80;
  static const double bannerHeight3x = 280;
  // Balance
  static const double balanceTop3x = 880;
  static const double balanceLeft3x = 263;
  static const double balanceCoverWidth3x = 500;
  static const double balanceCoverHeight3x = 100;

  @override
  void initState() {
    super.initState();
    _startBannerAutoScroll();
  }

  @override
  void dispose() {
    _bannerTimer?.cancel();
    _bannerController.dispose();
    super.dispose();
  }

  void _startBannerAutoScroll() {
    _bannerTimer = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (_bannerController.hasClients) {
        _currentBanner = (_currentBanner + 1) % 4;
        _bannerController.animateToPage(
          _currentBanner,
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  // 3x 픽셀 → 실제 화면 좌표 변환
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
    final scale = screenWidth / imgWidth; // 3x → screen 스케일

    return Scaffold(
      backgroundColor: const Color(0xFFF4F4F4),
      body: GestureDetector(
        // 3탭 편집 모드 트리거 (빈 영역 탭 시)
        onTap: () => state.registerTap(),
        child: Stack(
          children: [
            Column(
              children: [
                // ===== 고정 GNB =====
                Image.asset(
                  'assets/images/gnb.png',
                  width: screenWidth,
                  fit: BoxFit.fitWidth,
                ),

            // ===== 스크롤 가능 콘텐츠 =====
            Expanded(
              child: SingleChildScrollView(
                child: SizedBox(
                  width: screenWidth,
                  child: Stack(
                    children: [
                      // 배경: 전체 콘텐츠 스크린샷
                      Image.asset(
                        'assets/images/home_content.png',
                        width: screenWidth,
                        fit: BoxFit.fitWidth,
                      ),

                      // ===== 배너 캐러셀 오버레이 =====
                      Positioned(
                        top: _toScreenY(bannerTop3x, screenWidth),
                        left: _toScreenX(0, screenWidth),
                        right: _toScreenX(0, screenWidth),
                        height: _toScreenY(bannerHeight3x, screenWidth),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12 * scale),
                          child: PageView(
                            controller: _bannerController,
                            onPageChanged: (i) =>
                                setState(() => _currentBanner = i),
                            children: [
                              Image.asset('assets/images/banner1.jpg',
                                  fit: BoxFit.cover),
                              Image.asset('assets/images/banner2.jpg',
                                  fit: BoxFit.cover),
                              Image.asset('assets/images/banner3.jpg',
                                  fit: BoxFit.cover),
                              Image.asset('assets/images/banner4.jpg',
                                  fit: BoxFit.cover),
                            ],
                          ),
                        ),
                      ),

                      // ===== 잔액 가림막 + 오버레이 =====
                      Positioned(
                        top: _toScreenY(balanceTop3x - 2, screenWidth),
                        left: _toScreenX(balanceLeft3x, screenWidth),
                        width: _toScreenX(600, screenWidth),
                        height: _toScreenY(balanceCoverHeight3x, screenWidth),
                        child: Container(color: const Color(0xFFFEFFFF)),
                      ),
                      Positioned(
                        top: _toScreenY(balanceTop3x, screenWidth),
                        left: _toScreenX(balanceLeft3x, screenWidth),
                        child: GestureDetector(
                          onTap: state.editMode ? () async {
                            final result = await showEditDialog(
                              context,
                              title: '잔액 수정 (숫자만)',
                              currentValue: state.balance.toString(),
                              keyboardType: TextInputType.number,
                            );
                            if (result != null) {
                              final parsed = int.tryParse(
                                  result.replaceAll(',', '').replaceAll('원', ''));
                              if (parsed != null) state.updateBalance(parsed);
                            }
                          } : null,
                          child: Container(
                            padding: state.editMode
                                ? const EdgeInsets.symmetric(horizontal: 4, vertical: 2)
                                : EdgeInsets.zero,
                            decoration: state.editMode
                                ? BoxDecoration(
                                    border: Border.all(color: const Color(0xFF2D55B0), width: 1.5),
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
                                          fontWeight: FontWeight.w700,
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

            // ===== 고정 탭 바 (Column 밖 Stack으로 이동) =====
          ],
        ),

        // ===== 탭 바 (투명 배경, 콘텐츠 위에 겹침) =====
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

        // ===== 편집 모드 표시 =====
        if (state.editMode)
          Positioned(
            top: MediaQuery.of(context).padding.top + 10,
            right: 16,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
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